import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../app/router/navigation/nav.dart';
import '../../app/router/navigation/routes.dart';
import '../Custom_Widgets/custom_app_bar.dart';
import 'repo/chat_repo.dart';
import '../../cores/utils/helperFunctions.dart';
import 'model/messageModel.dart';
import '../../cores/services/secure_storage_service.dart';
import '../bookingDetails/repo/bookingDetailRepo.dart';
import '../bookingDetails/model/bookingDetailModel.dart';
import 'ui/request_commission_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../Profile/repo/profileRepo.dart';
import '../Profile/model/getProfileModel.dart' as profile_model;
import '../addDriver/repo/driverRepo.dart';
import '../addDriver/model/driverListModel.dart';
import '../manage_vehicles/model/vehicle_model.dart';
import '../../cores/network/api_service.dart';
import '../../cores/constants/api_constants.dart';
import '../Booking/model/postBookingListModel.dart';
import '../editBooking/repo/editBookingRepo.dart';
import 'package:share_plus/share_plus.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String bookingId;
  final String creatorName;
  final String receiverId;
  final bool isFromDetails;

  const ChatScreen({
    super.key,
    this.userName = "User",
    this.bookingId = "25435",
    this.creatorName = "Guddu",
    this.receiverId = "0",
    this.isFromDetails = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatRepo _chatRepo = ChatRepo();
  final BookingDetailRepo _bookingDetailRepo = BookingDetailRepo();
  final ProfileRepo _profileRepo = ProfileRepo();
  final DriverRepo _driverRepo = DriverRepo();
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  late Razorpay _razorpay;

  List<ChatMessage> _messages = [];
  BookingData? _bookingData;
  profile_model.Data? _userProfile;
  BookingSubDriverDetail? _otherDriverDetails;
  String? _sharedDriverId;
  List<SubDriver> _subDrivers = [];
  List<VehicleItem> _vehicles = [];
  String? _myId;
  num _pendingCommissionAmount = 0;
  bool _isCommissionPaid = false; // shows "Commission is Paid" in booking card
  bool _hasSharedDetails =
      false; // logic for hiding Pay Commission btn until details sent
  String? _roomId;
  String? _chatPartnerId; // the other person's ID derived from roomDetails

  @override
  void initState() {
    super.initState();
    _initPusherAndFetch();
    _fetchBookingDetails();
    _fetchUserProfile();
    _fetchDriversAndVehicles();

    // Razorpay Initialization
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _fetchUserProfile() async {
    try {
      final response = await _profileRepo.getProfile(context: context);
      if (response.data != null) {
        setState(() {
          _userProfile = response.data;
          _myId = _userProfile?.id.toString() ?? "";
        });
      }
    } catch (e) {
      debugPrint("Error fetching profile in chat: $e");
    }
  }

  void _fetchBookingDetails() async {
    try {
      final response = await _bookingDetailRepo.getBookingDetailApi(
        context: context,
        bookingId: widget.bookingId,
      );
      if (response.data != null) {
        setState(() {
          _bookingData = response.data;
          _otherDriverDetails = response.driverDetails;
          _sharedDriverId = (_bookingData!.assignDriverId != null &&
                  _bookingData!.assignDriverId != 0)
              ? _bookingData!.assignDriverId.toString()
              : (_bookingData!.driverId != 0
                  ? _bookingData!.driverId.toString()
                  : null);
        });
        // Now that we have the correct driver/creator IDs, re-fetch messages
        _fetchMessages();
      }
    } catch (e) {
      debugPrint("Error fetching booking details in chat: $e");
    }
  }

  void _sendMessage({
    String? text,
    MessageType type = MessageType.sent,
    bool isMe = true,
    List<String>? images,
    int? apiType,
    Map<String, dynamic>? metaData,
    bool isPaymentRequest = false,
  }) async {
    final String content = text ?? _messageController.text.trim();
    if (content.isEmpty && metaData == null) return;

    if (text == null) {
      _messageController.clear();
    }

    try {
      String effectiveReceiverId = widget.receiverId;
      if (_bookingData != null && _myId != null) {
        final String myIdStr = _myId!.toString();
        final bool isMeCreator =
            myIdStr == _bookingData!.creatorId?.toString() ||
                myIdStr == _bookingData!.driverId.toString();

        if (isMeCreator) {
          // I am the creator, so the receiver should be the assigned driver or the poster
          if (_bookingData!.assignDriverId != null &&
              _bookingData!.assignDriverId != 0) {
            effectiveReceiverId = _bookingData!.assignDriverId.toString();
          } else if (_bookingData!.driverId != 0 &&
              _bookingData!.driverId.toString() != myIdStr) {
            effectiveReceiverId = _bookingData!.driverId.toString();
          }
        } else {
          // I am the driver side, so the receiver should be the creator
          if (_bookingData!.creatorId != null &&
              _bookingData!.creatorId!.isNotEmpty &&
              _bookingData!.creatorId != myIdStr) {
            effectiveReceiverId = _bookingData!.creatorId!;
          }
        }
      }

      // Final safety: never send to yourself or to an invalid ID
      if ((effectiveReceiverId == _myId || effectiveReceiverId == "0") &&
          _bookingData != null) {
        String dId = _bookingData!.driverId.toString();
        String cId = _bookingData!.creatorId ?? "";
        String aId = _bookingData!.assignDriverId?.toString() ?? "";

        if (aId != "0" && aId != _myId && aId.isNotEmpty) {
          effectiveReceiverId = aId;
        } else if (dId != "0" && dId != _myId) {
          effectiveReceiverId = dId;
        } else if (cId.isNotEmpty && cId != _myId) {
          effectiveReceiverId = cId;
        }
      }

      String? socketId;
      try {
        socketId = await _pusher.getSocketId();
      } catch (e) {
        debugPrint("❌ Get Socket ID Error: $e");
      }

      setState(() {
        _messages.insert(
            0,
            ChatMessage(
              id: null,
              text: content,
              isMe: isMe,
              time: "Just now",
              type: type,
              images: images,
              apiType: apiType,
              metaData: metaData,
              isPayment: apiType == 2,
              isPaymentRequest: isPaymentRequest,
            ));
      });
      // No need to scroll to bottom with reverse: true, it's already there

      final dynamic response = await _chatRepo.sendNewMessage(
        context: context,
        bookingId: widget.bookingId,
        receiverId: effectiveReceiverId,
        message: content,
        socketId: socketId,
        type: apiType ?? 0,
        metaData: metaData,
      );

      if (response != null &&
          response['status'] == true &&
          response['data'] != null) {
        final realId = response['data']['id'];
        int lastIdx =
            _messages.lastIndexWhere((m) => m.id == null && m.text == content);
        if (lastIdx != -1) {
          setState(() {
            _messages[lastIdx] = ChatMessage(
              id: realId,
              text: content,
              isMe: isMe,
              time: "Just now",
              type: type,
            );
          });
        }
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFB300)),
      ),
    );

    try {
      final verifyResponse = await _chatRepo.verifyPayment(
        orderId: response.orderId ?? "",
        paymentId: response.paymentId ?? "",
        signature: response.signature ?? "",
        amount: _pendingCommissionAmount,
        bookingId: widget.bookingId,
      );

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      if (verifyResponse != null && verifyResponse['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Payment Successful! Commission paid."),
            backgroundColor: Colors.green,
          ),
        );

        _sendMessage(
          text: "payment confirmation commission is paid",
          type: MessageType.info,
          isMe: true,
          apiType: 2,
          metaData: verifyResponse,
        );

        _fetchBookingDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                verifyResponse?['message'] ?? "Payment verification failed."),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification Error: $e")),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed: ${response.message}"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  void _openRazorpay([num? overrideAmount]) async {
    if (_bookingData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking data not loaded.")),
      );
      return;
    }

    final num commission = overrideAmount ?? _bookingData!.driverCommission;
    if (commission <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No commission amount to pay.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFB300)),
      ),
    );

    try {
      _pendingCommissionAmount = commission;
      final orderResponse = await _chatRepo.createRazorpayOrder(
        amount: commission,
      );

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      if (orderResponse == null || orderResponse['id'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Failed to create payment order. Please try again.")),
        );
        return;
      }

      final String razorpayOrderId = orderResponse['id'];
      final int amountInPaise =
          orderResponse['amount'] ?? (commission * 100).toInt();

      var options = {
        'key': ApiConstants.razorpayKey,
        'amount': amountInPaise,
        'order_id': razorpayOrderId,
        'name': 'Cab Yatra',
        'description': 'Booking Commission: ${_bookingData!.orderId}',
        'image': 'assets/images/finalLogooo.png',
        'prefill': {
          'contact': _userProfile?.phone ?? '9999999999',
          'email': _userProfile?.email ?? 'user@cabyatra.com'
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint("Razorpay Error: $e");
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating order: $e")),
      );
    }
  }

  void _handlePaymentWithDetails({num? overrideAmount}) {
    if (_hasSharedDetails) {
      _openRazorpay(overrideAmount);
    } else {
      _showShareDetailsDialog(
          payAfterShare: true, overrideAmount: overrideAmount);
    }
  }

  void _showShareDetailsDialog(
      {bool payAfterShare = false, num? overrideAmount}) {
    if (_subDrivers.isEmpty && _vehicles.isEmpty) {
      Fluttertoast.showToast(
          msg: "No drivers or vehicles found. Please add them first.");
      return;
    }

    SubDriver? selectedDriver =
        _subDrivers.isNotEmpty ? _subDrivers.first : null;
    VehicleItem? selectedVehicle =
        _vehicles.isNotEmpty ? _vehicles.first : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF8F9FA),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Select car and driver",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text("Driver",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                          fontFamily: 'Poppins')),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color(0xFFFFB300), width: 1.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<SubDriver>(
                        value: selectedDriver,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        hint: const Text("Select Driver"),
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFFFFB300)),
                        style: const TextStyle(
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Poppins'),
                        items: _subDrivers.map((SubDriver driver) {
                          return DropdownMenuItem<SubDriver>(
                            value: driver,
                            child: Text(driver.name),
                          );
                        }).toList(),
                        onChanged: (SubDriver? newValue) {
                          setDialogState(() {
                            selectedDriver = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Vehicle",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                          fontFamily: 'Poppins')),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color(0xFFFFB300), width: 1.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<VehicleItem>(
                        value: selectedVehicle,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        hint: const Text("Select Vehicle"),
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFFFFB300)),
                        style: const TextStyle(
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: 'Poppins'),
                        items: _vehicles.map((VehicleItem vehicle) {
                          return DropdownMenuItem<VehicleItem>(
                            value: vehicle,
                            child: Text(
                                "${vehicle.vehicleNumber} (${vehicle.vehicleType})"),
                          );
                        }).toList(),
                        onChanged: (VehicleItem? newValue) {
                          setDialogState(() {
                            selectedVehicle = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB300),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 2,
                        ),
                        onPressed: () {
                          if (selectedDriver == null ||
                              selectedVehicle == null) {
                            Fluttertoast.showToast(
                                msg:
                                    "Please select both a driver and a vehicle.");
                            return;
                          }
                          Navigator.pop(context);
                          final List<String> images = [];
                          if (selectedDriver!.image != null)
                            images.add(selectedDriver!.image!);
                          if (selectedVehicle!.allImages.isNotEmpty) {
                            images.addAll(selectedVehicle!.allImages);
                          } else if (selectedVehicle!.image != null) {
                            images.add(selectedVehicle!.image!);
                          } // First Message: Normal text details (no photos)
                          _sendMessage(
                            text:
                                "Driver Name: ${selectedDriver!.name}\nContact Number: ${selectedDriver!.phone}\nVehicle Registration: ${selectedVehicle!.vehicleNumber}\nVehicle Type: ${selectedVehicle!.vehicleType}",
                            type: MessageType.info,
                            isMe: true,
                            apiType: 1,
                            metaData: {
                              "driver_id": selectedDriver!.id,
                              "vehicle_id": selectedVehicle!.id,
                            },
                          );
                          // Second Message: Clickable photo link (photos in metaData)
                          _sendMessage(
                            text: "Click to see Vehicle and Car Photo",
                            type: MessageType.info,
                            isMe: true,
                            apiType: 3,
                            images: images,
                            metaData: {
                              "images": images,
                            },
                          );

                          // Instantly reveal the Pay Commission button
                          setState(() {
                            _hasSharedDetails = true;
                          });

                          if (payAfterShare) {
                            _openRazorpay(overrideAmount);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("SUBMIT",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Poppins')),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String dynamicTitle = widget.userName;
    if (dynamicTitle.isEmpty || dynamicTitle.toLowerCase() == "user") {
      dynamicTitle = "Chat";
    }

    if (_bookingData != null && _myId != null) {
      final String myIdStr = _myId!;
      final String dIdStr = _bookingData!.driverId.toString();
      final String cIdStr = _bookingData!.creatorId?.toString() ?? "";
      final bool isCreator = (myIdStr == dIdStr || myIdStr == cIdStr);

      if (isCreator) {
        // I am the Creator/Agency — show the Driver's name from API driverDetails
        if (_otherDriverDetails != null &&
            _otherDriverDetails!.name.isNotEmpty) {
          dynamicTitle = _otherDriverDetails!.name;
        } else if (dynamicTitle == "Chat" &&
            _bookingData!.vehicleType.isNotEmpty) {
          dynamicTitle = _bookingData!.vehicleType;
        }
      } else {
        // I am the Driver — show the Creator/Agency's name from booking data
        if (_bookingData!.creatorName.isNotEmpty) {
          dynamicTitle = _bookingData!.creatorName;
        } else {
          dynamicTitle = "Agent";
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(
        showLeading: true,
        title: dynamicTitle,
        onTitleTap: () {
          // Partner ID from roomDetails (creator_id / driver_id)
          final effectiveId = _chatPartnerId ?? widget.receiverId;
          if (effectiveId == "0" || effectiveId.isEmpty) return;

          Nav.push(context, Routes.reviewScreen, extra: effectiveId);
        },
        showAction: true,
        actionWidget: () {
          if (_bookingData == null || _myId == null) return null;

          final data = _bookingData!;
          final String mid = _myId ?? "";
          final String dId = data.driverId.toString();
          final String cId = data.creatorId?.toString() ?? "";

          final bool isCreator = (mid.isNotEmpty && (mid == dId || mid == cId));

          bool showCall = false;
          String? targetPhone;

          if (isCreator) {
            // I am the Creator (Agency), I see the Driver's number ALWAYS.
            targetPhone = data.driverPhone;
            if (targetPhone == null || targetPhone.isEmpty) {
              targetPhone = _otherDriverDetails?.phoneNumber;
            }
            showCall = targetPhone != null && targetPhone.isNotEmpty;
          } else {
            // I am the Driver, I see the Creator's number ONLY BY CONDITION.
            // User: "driver side check this variable 1 mean show ... otherwise not show"
            final bool isShowPhone = data.isShowPhoneNumber == '1';
            final bool isAssignedOrStarted = data.status == '1' || data.status == '4' || data.status == '2';
            if (isShowPhone || isAssignedOrStarted) {
              targetPhone = data.creatorPhone;
              if (targetPhone == null || targetPhone.isEmpty) {
                targetPhone = _otherDriverDetails?.phoneNumber;
              }
              showCall = targetPhone != null && targetPhone.isNotEmpty;
            } else {
              showCall = false;
            }
          }

          if (showCall && targetPhone != null && targetPhone.isNotEmpty) {
            return GestureDetector(
              onTap: () => HelperFunctions.makePhoneCall(context, targetPhone!),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone_in_talk,
                        color: Color(0xFFFFB300), size: 18),
                  ],
                ),
              ),
            );
          }
          return null;
        }(),
      ),
      body: Column(
        children: [
          _buildBookingCard(),
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              padding: EdgeInsets.zero,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildChatBubble(message),
                );
              },
            ),
          ),
          // Status Banner (Cancelled OR Commission Paid)
          if (_bookingData != null && _bookingData!.status == '3')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  const Text(
                    "Booking is Cancelled ❌",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFFF45858),
                        fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "This booking was cancelled by ${_bookingData!.id == _myId ? 'you' : 'the other party'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
            )
          else if (_isCommissionPaid ||
              (_bookingData != null &&
                  ['1', '4', '2'].contains(_bookingData!.status)))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  Text(
                    "This booking is assigned to ${widget.userName} ✅",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF2C3E50),
                        fontFamily: 'Poppins'),
                  ),
                  if (_bookingData != null &&
                      _myId != null &&
                      _myId == _bookingData!.creatorId) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          if (_bookingData!.status == '1') ...[
                            Row(
                              children: [
                                Expanded(
                                  child: _buildChatActionButton(
                                    text: "Pickup Booking",
                                    color: const Color(0xffFCB117),
                                    onPressed: () async {
                                      final success =
                                          await _chatRepo.updateBookingStatus(
                                        context: context,
                                        bookingId: widget.bookingId,
                                        status: "4",
                                      );
                                      if (success) {
                                        _sendMessage(
                                          text:
                                              "This booking is picked by agent",
                                          type: MessageType.info,
                                          apiType: 3,
                                        );
                                        _fetchBookingDetails();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildChatActionButton(
                              text: "Cancel Booking",
                              color: const Color(0xFFEFEFEF),
                              textColor: const Color(0xFFF45858),
                              onPressed: () async {
                                final success =
                                    await _chatRepo.updateBookingStatus(
                                  context: context,
                                  bookingId: widget.bookingId,
                                  status: "3",
                                );
                                if (success) {
                                  _fetchBookingDetails();
                                }
                              },
                            ),
                          ] else if (_bookingData!.status == '4') ...[
                            if (() {
                              final pdt = _bookingData!.pickupDateTime;
                              if (pdt == null) return true;
                              return DateTime.now()
                                  .isAfter(pdt.add(const Duration(hours: 2)));
                            }())
                              _buildChatActionButton(
                                text: "End Booking",
                                color: const Color(0xFF2C3E50),
                                onPressed: () async {
                                  final success =
                                      await _chatRepo.updateBookingStatus(
                                    context: context,
                                    bookingId: widget.bookingId,
                                    status: "2",
                                  );
                                  if (success) {
                                    _sendMessage(
                                      text: "This booking is completed",
                                      type: MessageType.info,
                                      apiType: 3,
                                    );
                                    _fetchBookingDetails();
                                  }
                                },
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          _buildInputBar(),
        ],
      ),
    );
  }

  String _getStatusText(String? status) {
    switch (status) {
      case '0':
        return 'Open';
      case '1':
        return 'Assigned';
      case '2':
        return 'Completed';
      case '3':
        return 'Cancelled';
      case '4':
        return 'Picked Up';
      case '5':
        return 'Expired';
      default:
        return status ?? '';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case '0':
        return const Color(0xff45B129);
      case '1':
        return const Color(0xffFCB117);
      case '2':
        return const Color(0xff45B129);
      case '3':
        return const Color(0xffF45858);
      case '4':
        return Colors.blue;
      case '5':
        return Colors.grey;
      default:
        return const Color(0xff45B129);
    }
  }

  Widget _buildBookingCard() {
    if (_bookingData == null) return const SizedBox.shrink();
    final data = _bookingData!;

    return GestureDetector(
      onTap: () {
        if (widget.isFromDetails) {
          Navigator.pop(context);
          return;
        }

        final bId = (widget.bookingId != "N/A" && widget.bookingId.isNotEmpty)
            ? widget.bookingId
            : data.id.toString();
        debugPrint("Navigate to Booking Details with ID: $bId");
        if (bId != "0" && bId != "N/A") {
          Nav.push(context, Routes.bookingDetails, extra: {
            'bookingId': bId,
            'hideChat': true,
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "ID : ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            fontFamily: 'Poppins'),
                      ),
                      TextSpan(
                        text: data.orderId,
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Poppins'),
                      ),
                      const TextSpan(text: " "),
                      TextSpan(
                        text: _getStatusText(data.status),
                        style: TextStyle(
                            color: _getStatusColor(data.status),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${HelperFunctions.formatDate(data.pickupDate)} @${HelperFunctions.formatTo12Hour(data.pickupTime)} ${data.noOfDays.isNotEmpty ? '(for ${data.noOfDays} Days)' : ''}",
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2C3E50),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins'),
                ),
                Text(
                  data.subTypeLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF2C3E50),
                      fontFamily: 'Poppins'),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icons Column
                    Column(
                      children: [
                        const Icon(Icons.circle,
                            color: Colors.orange, size: 16),
                        Expanded(
                          child: CustomPaint(
                            size: const Size(1.5, double.infinity),
                            painter: DashLinePainter(),
                          ),
                        ),
                        const Icon(Icons.circle, color: Colors.red, size: 16),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Texts Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (data.pickUpCity ?? "").isNotEmpty
                                ? data.pickUpCity!
                                : data.pickupLocation,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                                fontFamily: 'Poppins'),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            data.subTypeLabel == "Round Trip"
                                ? "Round Trip..."
                                : ((data.destinationCity ?? "").isNotEmpty
                                    ? data.destinationCity!
                                    : data.dropLocation),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F2F5),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "₹${data.totalAmount.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontFamily: 'Poppins')),
                                  const Text("Total Amount",
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins')),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFB300),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "₹${data.driverCommission.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontFamily: 'Poppins')),
                                  const Text("Commission",
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins')),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.arrow_forward_ios,
                            size: 18, color: Color(0xFF2C3E50)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                () {
                  final String? img = data.carImage;
                  if (img == null || img.isEmpty) {
                    return Image.asset("assets/images/carMO.png", width: 75);
                  }
                  final String fullUrl = img.startsWith('http')
                      ? img
                      : "${ApiConstants.baseUrl}$img";
                  return Image.network(
                    fullUrl,
                    width: 75,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset("assets/images/carMO.png", width: 75),
                  );
                }(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data.vehicleType,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2C3E50),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActionButtons(data.status),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(String status) {
    if (_bookingData == null) return const SizedBox.shrink();

    final String driverIdStr = _bookingData!.driverId.toString();
    final String creatorIdStr = _bookingData!.creatorId?.toString() ?? "";
    final bool isCreator = (_myId != null && _myId == driverIdStr) ||
        (_myId != null && _myId == creatorIdStr);

    if (isCreator) {
      // 🟢 CREATOR SIDE LOGIC (Based on driver_id)
      if (status == '0') {
        if (_bookingData?.assignType == '1') {
          return SizedBox(
            width: double.infinity,
            child:
                _cardButton("Request Commission", const Color(0xFFFFB300), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RequestCommissionScreen(
                    bookingData: _bookingData!,
                    agencyName: widget.userName,
                    onSubmit: (editedCommission) async {
                      Navigator.pop(context); // close form
                      if (editedCommission > 0) {
                        // Update the commission in the database via Edit API
                        try {
                          final editRepo = EditBookingRepo();

                          // Map subType from label if not directly available
                          final String effectiveSubType = _bookingData!
                                  .subTypeLabel
                                  .toLowerCase()
                                  .contains("one way")
                              ? "1"
                              : "2";

                          await editRepo.editBookingApi(
                            id: _bookingData!.id.toString(),
                            subType: effectiveSubType,
                            carCategoryId: int.tryParse(
                                    _bookingData!.carCategoryId?.toString() ??
                                        "0") ??
                                0,
                            pickUp_date: _bookingData!.pickupDate,
                            pickUp_time: _bookingData!.pickupTime,
                            pickUpLoc: [_bookingData!.pickupLocation],
                            destinationLoc: [_bookingData!.dropLocation],
                            total_faire: _bookingData!.totalAmount,
                            driverCommission: editedCommission.toDouble(),
                            is_show_phoneNumber: int.tryParse(_bookingData!
                                        .isShowPhoneNumber
                                        ?.toString() ??
                                    "0") ??
                                0,
                            remarks: _bookingData!.remark,
                            extra: (_bookingData!.extra != null &&
                                    _bookingData!.extra!.isNotEmpty)
                                ? _bookingData!.extra!
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList()
                                : [],
                            noOfDays: _bookingData!.noOfDays,
                            tripNotes: _bookingData!.tripNotes,
                            context: context,
                          );
                          _fetchBookingDetails(); // Refresh chat summary
                        } catch (e) {
                          debugPrint("❌ Error updating commission API: $e");
                        }

                        _sendMessage(
                          text:
                              "__pay_request:${editedCommission.toInt()}:Please pay the commission of ₹${editedCommission.toInt()} to assign this booking",
                          type: MessageType.info,
                          isMe: true,
                          apiType: 0,
                          isPaymentRequest: true,
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "Commission must be greater than 0.");
                      }
                    },
                  ),
                ),
              );
            }),
          );
        }

        // Before assign: show Edit
        return SizedBox(
          width: double.infinity,
          child: _cardButton("Edit Booking", const Color(0xFFFFB300), () {
            final seeData = SeeBookingData(
              id: _bookingData!.id,
              orderId: _bookingData!.orderId,
              driverId: _bookingData!.driverId,
              pickUpDate: _bookingData!.pickupDate,
              pickUpTime: _bookingData!.pickupTime,
              pickUpLoc: _bookingData!.pickupLocation,
              destinationLoc: _bookingData!.dropLocation,
              totalFaire: _bookingData!.totalAmount.toStringAsFixed(0),
              driverCommission:
                  _bookingData!.driverCommission.toStringAsFixed(0),
              remark: _bookingData!.remark,
              subTypeLabel: _bookingData!.subTypeLabel,
              noOfDays: _bookingData!.noOfDays,
              tripNotes: _bookingData!.tripNotes,
              status: _bookingData!.status,
              carCategoryId: _bookingData!.carCategoryId,
              extra: _bookingData!.extra,
              isShowPhoneNumber: _bookingData!.isShowPhoneNumber,
            );
            Nav.push(context, Routes.editBooking, extra: seeData);
          }),
        );
      } else if (status == '1') {
        // After assign: show Cancel
        final bool isAfterPickup = _bookingData?.pickupDateTime != null &&
            DateTime.now().isAfter(_bookingData!.pickupDateTime!);

        return Row(
          children: [
            Expanded(
              child: _cardButton("Cancel Booking", const Color(0xFFF45858),
                  () async {
                final success = await _chatRepo.updateBookingStatus(
                  context: context,
                  bookingId: widget.bookingId,
                  status: "3", // Cancel
                );
                if (success) _fetchBookingDetails();
              }),
            ),
            if (isAfterPickup) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _cardButton("Pickup Booking", Colors.orange, () async {
                  final success = await _chatRepo.updateBookingStatus(
                    context: context,
                    bookingId: widget.bookingId,
                    status: "4", // Pickup
                  );
                  if (success) {
                    _sendMessage(
                      text: "This booking is picked by agent",
                      type: MessageType.info,
                      isMe: true,
                    );
                    _fetchBookingDetails();
                  }
                }),
              ),
            ],
          ],
        );
      }
    } else {
      // 🔵 DRIVER SIDE LOGIC
      if (status == '0') {
        // Open
        return Row(
          children: [
            Expanded(
              child: _cardButton(
                  "Share Details",
                  _isCommissionPaid ? Colors.grey : Colors.red,
                  _isCommissionPaid ? null : () => _showShareDetailsDialog()),
            ),
            const SizedBox(width: 12),
            if (!_isCommissionPaid && _bookingData?.assignType != '1')
              Expanded(
                child: _cardButton(
                  "Pay Commission",
                  const Color(0xFF4CAF50),
                  () => _handlePaymentWithDetails(),
                ),
              )
            else if (_isCommissionPaid)
              Expanded(
                child: _cardButton(
                  "Commission Paid",
                  Colors.grey,
                  null,
                ),
              ),
          ],
        );
      } else if (status == '1') {
        // Assigned
        final bool isAfterPickup = _bookingData?.pickupDateTime != null &&
            DateTime.now().isAfter(_bookingData!.pickupDateTime!);

        return Row(
          children: [
            Expanded(
              child: _cardButton("Cancel Booking", const Color(0xFFF45858),
                  () async {
                final success = await _chatRepo.updateBookingStatus(
                  context: context,
                  bookingId: widget.bookingId,
                  status: "3", // Cancel
                );
                if (success) _fetchBookingDetails();
              }),
            ),
            if (isAfterPickup) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _cardButton("Pickup Booking", Colors.orange, () async {
                  final success = await _chatRepo.updateBookingStatus(
                    context: context,
                    bookingId: widget.bookingId,
                    status: "4", // Pickup
                  );
                  if (success) {
                    _sendMessage(
                      text: "This booking is picked by driver",
                      type: MessageType.info,
                      isMe: true,
                    );
                    _fetchBookingDetails();
                  }
                }),
              ),
            ],
          ],
        );
      } else if (status == '4') {
        // After pickup: show End Button
        return SizedBox(
          width: double.infinity,
          child: _cardButton("End Booking", const Color(0xFF2C3E50), () async {
            final success = await _chatRepo.updateBookingStatus(
              context: context,
              bookingId: widget.bookingId,
              status: "2", // End/Complete
            );
            if (success) {
              _sendMessage(
                text:
                    "This booking is completed by ${_userProfile?.name ?? "driver"}",
                type: MessageType.info,
                isMe: true,
              );
              _fetchBookingDetails();
              if (mounted) {
                Nav.push(context, Routes.writeReview, extra: {
                  'bookingId': widget.bookingId,
                  'driverId': (_bookingData?.assignSubDriverId != null &&
                          _bookingData?.assignSubDriverId != 0)
                      ? _bookingData?.assignSubDriverId
                      : _bookingData?.driverId,
                  'driverName': widget.userName,
                  'driverImage': null,
                });
              }
            }
          }),
        );
      }
    }

    return const SizedBox.shrink();
  }

  Widget _cardButton(String text, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: (onPressed == null) ? Colors.grey.shade400 : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontFamily: 'Poppins')),
    );
  }

  void _showImagesDialog(List<String> images) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(
              height: 400,
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(images[index]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (images.length > 1)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("Swipe to see more",
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    // ✨ Payment initiated — Dynamic side based on isMe
    if (message.isPaymentRequest) {
      final parts = message.text.split(':');
      final String displayText =
          parts.length >= 3 ? parts.sublist(2).join(':') : message.text;
      final String amountStr = parts.length >= 2 ? parts[1] : '';
      final bool isMe = message.isMe;

      return Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // 1️⃣ Text bubble
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                  left: isMe ? 60 : 0, right: isMe ? 0 : 60, top: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFE8E8E8) : const Color(0xFFFFB300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                displayText,
                style: TextStyle(
                  color: isMe ? Colors.black87 : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          // 2️⃣ Interative chat bubble action button
          Builder(builder: (context) {
            if (_bookingData == null || _myId == null)
              return const SizedBox.shrink();

            final bool isDriverSide =
                _myId != _bookingData!.driverId.toString();
            final bool isAlreadyPaid = _isCommissionPaid ||
                (_bookingData != null &&
                    ['1', '4', '2'].contains(_bookingData!.status));

            if (isDriverSide) {
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: GestureDetector(
                  onTap: isAlreadyPaid
                      ? null
                      : () {
                          final num parsedAmount =
                              num.tryParse(amountStr.replaceAll(",", "")) ??
                                  _bookingData!.driverCommission;
                          _handlePaymentWithDetails(
                              overrideAmount: parsedAmount);
                        },
                  child: Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 11),
                    decoration: BoxDecoration(
                      color:
                          isAlreadyPaid ? Colors.grey : const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            isAlreadyPaid
                                ? "Commission Paid"
                                : "Pay Commission ₹$amountStr",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'Poppins')),
                        const SizedBox(width: 8),
                        Icon(
                            isAlreadyPaid
                                ? Icons.check_circle_outline
                                : Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 14),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          // Timestamp
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              message.time,
              style: const TextStyle(
                  fontSize: 10, color: Colors.grey, fontFamily: 'Poppins'),
            ),
          ),
        ],
      );
    }

    // Reverted hide — type=2 messages are now shown in list again
    // if (message.isPayment) {
    //   return const SizedBox.shrink();
    // }

    if (message.type == MessageType.system) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.text,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
          ),
        ),
      );
    }

    final bool isMe = message.isMe;
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Transform.rotate(
                  angle: -0.5,
                  child: const Icon(Icons.send, color: Colors.orange, size: 20),
                ),
              ),
            // Added share icon for sent messages (shows on left of bubble)
            if (isMe && message.apiType == 1)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: IconButton(
                  onPressed: () => Share.share(message.text),
                  icon: const Icon(Icons.share, 
                    size: 20, 
                    color: Color(0xFFFFB300)
                  ),
                ),
              ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color(0xFFE8E8E8)
                      : (message.type == MessageType.received
                          ? const Color(0xFFFFB300)
                          : const Color(0xFFF2F2F2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Builder(builder: (context) {
                  String displayText = message.text;
                  List<String> images = message.images ?? [];

                  // If standard list is empty, try to extract from raw metaData for instant sync resilience
                  if (images.isEmpty &&
                      message.metaData != null &&
                      message.metaData!['images'] is List) {
                    images = List<String>.from(message.metaData!['images']);
                  }

                  // Backward compatibility AND fallback parsing for old or malformed messages
                  if (displayText
                      .contains("Click to see Vehicle and Car Photo")) {
                    if (displayText.contains("[") &&
                        displayText.endsWith("]")) {
                      final int startIndex = displayText.lastIndexOf("[");
                      final String imgsPart = displayText.substring(
                          startIndex + 1, displayText.length - 1);
                      if (imgsPart.isNotEmpty && images.isEmpty) {
                        images =
                            imgsPart.split(",").map((e) => e.trim()).toList();
                      }
                      displayText = displayText.substring(0, startIndex).trim();
                    }
                  }

                  final bool hasImages = images.isNotEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: hasImages ? () => _showImagesDialog(images) : null,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          displayText,
                          style: TextStyle(
                            color: (message.type == MessageType.received ||
                                    message.type == MessageType.system ||
                                    (message.type == MessageType.info && !isMe))
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14,
                            fontWeight: isMe ? FontWeight.w500 : FontWeight.w400,
                            decoration: hasImages ? TextDecoration.underline : null,
                            height: 1.4,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            // Added share icon for received messages (shows on right of bubble)
            if (!isMe && message.apiType == 1)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: IconButton(
                  onPressed: () => Share.share(message.text),
                  icon: const Icon(Icons.share, 
                    size: 20, 
                    color: Color(0xFFFFB300)
                  ),
                ),
              ),
          ],
        ),
        Text(
          message.time,
          style: const TextStyle(
              fontSize: 10, color: Colors.grey, fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _messageController,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: "Say Someting...",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Poppins'),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _sendMessage(),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchDriversAndVehicles() async {
    try {
      final driverRes = await _driverRepo.getDrivers(isApprove: 1);
      final vehicleRes = await _driverRepo.getVehicles(isApprove: 1);

      setState(() {
        _subDrivers = driverRes.drivers;
        _vehicles = vehicleRes.vehicles;
      });
    } catch (e) {
      debugPrint("Error fetching drivers/vehicles: $e");
    }
  }

  Future<void> _fetchMessages() async {
    try {
      _myId = await SecureStorageService.getUserId();
      final String myIdStr = _myId ?? "";

      // Determine effective driver ID for API call
      String effectiveDriverId = widget.receiverId;

      if (_bookingData != null) {
        final String dIdStr = _bookingData!.driverId.toString();
        final String aIdStr = _bookingData!.assignDriverId?.toString() ?? "";
        final String cIdStr = _bookingData!.creatorId ?? "";

        final bool isMeCreator = myIdStr == dIdStr;

        if (isMeCreator) {
          effectiveDriverId =
              (aIdStr != "0" && aIdStr.isNotEmpty) ? aIdStr : widget.receiverId;
        } else {
          effectiveDriverId = dIdStr != "0"
              ? dIdStr
              : (cIdStr.isNotEmpty ? cIdStr : widget.receiverId);
        }
      }

      final response = await _chatRepo.getChatMessages(
        context: context,
        bookingId: widget.bookingId,
        driverId: effectiveDriverId,
      );

      final List messagesData = response['messages'] ?? [];
      final messagesList =
          messagesData.map((e) => MessageListModel.fromJson(e)).toList();

      if (response['roomDetails'] != null) {
        final room = response['roomDetails'];
        final newRoomId = room['id']?.toString();
        if (newRoomId != null && newRoomId != _roomId) {
          if (_roomId != null) {
            _pusher.unsubscribe(channelName: "private-chat.booking.$_roomId");
          }
          _roomId = newRoomId;
          debugPrint("📡 Room ID found: $_roomId");
        }
        // Determine chat partner: if I am creator_id, partner is driver_id and vice versa
        final String roomCreatorId = room['creator_id']?.toString() ?? "";
        final String roomDriverId = room['driver_id']?.toString() ?? "";
        final String myIdStr = _myId ?? "";
        _chatPartnerId = (myIdStr == roomCreatorId) ? roomDriverId : roomCreatorId;
        debugPrint("👤 Chat partner ID: $_chatPartnerId (me: $myIdStr)");
      }

      if (response['driverDetails'] != null) {
        setState(() {
          _otherDriverDetails =
              BookingSubDriverDetail.fromJson(response['driverDetails']);
        });
      }

      if (mounted) {
        setState(() {
          _messages = messagesList
              .map((m) => ChatMessage(
                    id: m.id,
                    text: m.text,
                    isMe: m.senderId.toString() == myIdStr,
                    time: HelperFunctions.formatTimeAgo(m.timestamp),
                    type: m.senderId.toString() == myIdStr
                        ? MessageType.sent
                        : MessageType.received,
                    isPayment: m.type == 2,
                    apiType: m.type,
                    metaData: m.metaData,
                    isPaymentRequest:
                        m.type == 0 && m.text.startsWith("__pay_request:"),
                    images: (m.type == 1 || m.type == 3)
                        ? (m.metaData?['images'] is List
                            ? List<String>.from(m.metaData?['images'])
                            : [])
                        : null,
                  ))
              .toList()
              .reversed
              .toList();
          _isCommissionPaid = messagesList.any((m) =>
              m.type == 2 &&
              m.text.contains("payment confirmation commission is paid"));
          _hasSharedDetails = messagesList
              .any((m) => m.type == 1 && m.senderId.toString() == myIdStr);
        });

        // Extract shared driver ID from messages sent by the other person
        final otherSideDetails = messagesList
            .where((m) =>
                m.type == 1 && m.senderId.toString() == widget.receiverId)
            .toList();
        if (otherSideDetails.isNotEmpty) {
          _sharedDriverId =
              otherSideDetails.last.metaData?['driver_id']?.toString();
        }
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    }
  }

  bool _isPusherInitialized = false;

  /// Connect Pusher first, then fetch messages to get room ID, then subscribe.
  void _initPusherAndFetch() async {
    try {
      _myId = await SecureStorageService.getUserId();
      final token = await SecureStorageService.getToken();

      if (token == null) {
        debugPrint("❌ Pusher: Auth Token is null. Skipping init.");
        return;
      }

      await _pusher.init(
          apiKey: "8a3c4b441150f546090a",
          cluster: "ap2",
          onConnectionStateChange: (previousState, currentState) {
            debugPrint("🟢 Pusher State: $currentState");
          },
          onError: (String message, int? code, dynamic e) {
            debugPrint("❌ Pusher Error: $message (code: $code)");
          },
          onAuthorizer: (channelName, socketId, options) async {
            try {
              debugPrint("🔐 Authorizing: $channelName");
              final response = await _chatRepo.authorizeChannel(
                channelName: channelName,
                socketId: socketId,
                token: token,
              );
              if (response == null) {
                debugPrint("❌ Auth returned null for $channelName");
                return null;
              }
              // Unwrap if backend wraps in {"data": {"auth": "..."}}
              if (response.containsKey('data') && response['data'] is Map) {
                return Map<String, dynamic>.from(response['data']);
              }
              return response;
            } catch (e) {
              debugPrint("❌ Auth Error: $e");
              return null;
            }
          },
          onEvent: (event) async {
            debugPrint("📡 Event: ${event.eventName} on ${event.channelName}");
            if (event.data == null) return;
            _handleSocketEvent(event);
          });

      // Step 1: Connect WITHOUT subscribing to any private channels yet
      await _pusher.connect();
      _isPusherInitialized = true;
      debugPrint("📡 Pusher connected. Waiting for room ID from API...");

      // Step 2: Fetch messages to get the room ID
      await _fetchMessages();

      // Step 3: Now subscribe using the ROOM ID
      if (_roomId != null) {
        await _pusher.subscribe(channelName: "private-chat.booking.$_roomId");
        debugPrint("📡 Subscribed to room: $_roomId");
      } else {
        debugPrint("⚠️ No room ID found, cannot subscribe to chat channel");
      }

      if (_myId != null) {
        await _pusher.subscribe(
            channelName: "private-App.Models.Driver.$_myId");
      }
    } catch (e) {
      debugPrint("❌ Pusher Init Error: $e");
      _isPusherInitialized = false;
    }
  }

  void _handleSocketEvent(dynamic event) async {
    try {
      dynamic data = event.data;
      if (data is String) data = jsonDecode(data);

      Map<String, dynamic> messageData;
      if (data is Map &&
          data.containsKey('message') &&
          data['message'] is Map) {
        messageData = Map<String, dynamic>.from(data['message']);
      } else if (data is Map &&
          data.containsKey('data') &&
          data['data'] is Map) {
        messageData = Map<String, dynamic>.from(data['data']);
      } else if (data is Map) {
        messageData = Map<String, dynamic>.from(data);
      } else {
        return;
      }

      if (!messageData.containsKey('message') &&
          messageData.containsKey('text')) {
        messageData['message'] = messageData['text'];
      }

      final newMessage = MessageListModel.fromJson(messageData);
      final String myIdStr = _myId?.toString() ?? "";
      final String sId = newMessage.senderId.toString();
      final String rId = newMessage.receiverId.toString();

      // Trust messages from the room channel
      final String activeId = _roomId ?? widget.bookingId;
      final bool isRoomChannel =
          event.channelName.contains("chat.booking.$activeId");
      bool belongsToThisChat =
          isRoomChannel && (sId == myIdStr || rId == myIdStr);

      if (!belongsToThisChat) {
        final String dId = _bookingData?.driverId.toString() ?? "";
        final String aId = _bookingData?.assignDriverId?.toString() ?? "";
        final String cId = _bookingData?.creatorId?.toString() ?? "";
        final bool iAmAgency = (myIdStr == dId || myIdStr == cId);
        final String partnerId = iAmAgency
            ? (aId != "0" && aId.isNotEmpty ? aId : widget.receiverId)
            : (dId != "0" ? dId : (cId.isNotEmpty ? cId : widget.receiverId));
        belongsToThisChat = (sId == myIdStr && rId == partnerId) ||
            (sId == partnerId && rId == myIdStr);
      }

      if (!belongsToThisChat) {
        debugPrint("📥 Filtered out (S:$sId R:$rId Me:$myIdStr)");
        return;
      }

      final isMeM = sId == myIdStr;

      if (_messages.any((m) => m.id != null && m.id == newMessage.id)) return;

      int pIdx = _messages.indexWhere((m) =>
          m.id == null &&
          m.text.trim() == newMessage.text.trim() &&
          m.isMe == isMeM);

      if (pIdx != -1) {
        final localMsg = _messages[pIdx];
        setState(() {
          _messages[pIdx] = ChatMessage(
            id: newMessage.id,
            text: newMessage.text,
            isMe: isMeM,
            time: HelperFunctions.formatTimeAgo(newMessage.timestamp),
            type: isMeM ? MessageType.sent : MessageType.received,
            isPayment: newMessage.type == 2,
            apiType: newMessage.type,
            metaData: newMessage.metaData ?? localMsg.metaData,
            isPaymentRequest: newMessage.type == 0 &&
                newMessage.text.startsWith("__pay_request:"),
            images: (newMessage.type == 1 || newMessage.type == 3)
                ? (newMessage.metaData?['images'] is List
                    ? List<String>.from(newMessage.metaData?['images'])
                    : (localMsg.images ?? []))
                : localMsg.images,
          );
          if (newMessage.type == 2) _isCommissionPaid = true;
        });
      } else {
        final newMsgObj = ChatMessage(
          id: newMessage.id,
          text: newMessage.text,
          isMe: isMeM,
          time: HelperFunctions.formatTimeAgo(newMessage.timestamp),
          type: isMeM ? MessageType.sent : MessageType.received,
          isPayment: newMessage.type == 2,
          apiType: newMessage.type,
          metaData: newMessage.metaData,
          isPaymentRequest: newMessage.type == 0 &&
              newMessage.text.startsWith("__pay_request:"),
          images: (newMessage.type == 1 || newMessage.type == 3)
              ? (newMessage.metaData?['images'] is List
                  ? List<String>.from(newMessage.metaData?['images'])
                  : [])
              : null,
        );
        setState(() {
          _messages.insert(0, newMsgObj);
          if (newMessage.type == 2) _isCommissionPaid = true;
          if (newMessage.type == 1) {
            _hasSharedDetails = true;
            if (!isMeM) {
              _sharedDriverId = newMessage.metaData?['driver_id']?.toString();
            }
          }
        });
      }
    } catch (e) {
      debugPrint("❌ Socket Parse Error: $e");
    }
  }

  Widget _buildChatActionButton({
    required String text,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _pusher.unsubscribe(
        channelName: "private-chat.booking.${_roomId ?? widget.bookingId}");
    if (_myId != null) {
      _pusher.unsubscribe(channelName: "private-App.Models.Driver.$_myId");
    }
    _pusher.unsubscribe(channelName: "my-channel");
    _pusher.disconnect();
    _razorpay.clear();
    super.dispose();
  }
}

enum MessageType { sent, received, info, system }

class ChatMessage {
  final int? id;
  final String text;
  final bool isMe;
  final String time;
  final MessageType type;
  final bool isAction;
  final bool isPayment; // type == 2  → Commission is Paid card (Image 2)
  final bool
      isPaymentRequest; // type == 0 with special text → orange bubble (Image 1)
  final int? apiType;
  final List<String>? images;
  final Map<String, dynamic>? metaData;

  ChatMessage({
    this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.type = MessageType.sent,
    this.isAction = false,
    this.isPayment = false,
    this.isPaymentRequest = false,
    this.apiType,
    this.images,
    this.metaData,
  });
}

class DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 4, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1.5;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
