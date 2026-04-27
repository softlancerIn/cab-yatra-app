import 'package:fluttertoast/fluttertoast.dart';

import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';

import 'package:cab_taxi_app/Pages/bookingDetails/bloc/bookingDetailsEvent.dart';
import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:cab_taxi_app/app/router/navigation/routes.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cab_taxi_app/cores/utils/helperFunctions.dart';
import '../bloc/bookingDetailsBloc.dart';
import '../bloc/bookingDetailsState.dart';
import 'driverInfoCard.dart';
import '../../HomePageFlow/dashboard/repo/dashboardRepo.dart';
import '../../chat/chat_listing.dart';
import '../../chat/repo/chat_repo.dart';
import '../../addDriver/repo/driverRepo.dart';
import '../../../cores/network/api_service.dart';
import '../../../cores/services/secure_storage_service.dart';
import '../../../cores/constants/api_constants.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingID;
  final bool isFromHome;
  final bool showShareIcon;
  final bool hideChat;

  const BookingDetailScreen({
    super.key,
    required this.bookingID,
    this.isFromHome = false,
    this.showShareIcon = false,
    this.hideChat = false,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  // late PaymentService _paymentService;

  @override
  void initState() {
    // _paymentService = PaymentService();
    super.initState();
    context.read<BookingDetailBloc>().add(
        GetBookingDetailEvent(context: context, bookingId: widget.bookingID));
  }

  @override
  void dispose() {
    // _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(
        title: "Booking Details",
        showLeading: true,
        actionWidget: widget.showShareIcon
            ? IconButton(
                onPressed: () {
                  final state = context.read<BookingDetailBloc>().state;
                  final data = state.bookingDetailModel?.data;
                  if (data != null) {
                    HelperFunctions.shareBookingDetail(
                      orderId: data.orderId,
                      subTypeLabel: data.subTypeLabel,
                      pickupLocation: data.pickupLocation,
                      dropLocation: data.dropLocation,
                      vehicleType: data.vehicleType,
                      driverEarning: data.totalAmount - data.driverCommission,
                      pickupDate: data.pickupDate,
                      pickupTime: data.pickupTime,
                      remark: data.remark,
                      tripNotes: data.tripNotes,
                      noOfDays: data.noOfDays,
                    );
                  }
                },
                icon: const Icon(Icons.share, color: Colors.black, size: 22),
              )
            : const SizedBox.shrink(),
      ),
      body: BlocBuilder<BookingDetailBloc, BookingDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Error: ${state.errorMessage}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final data = state.bookingDetailModel?.data;

          if (data == null) {
            return const Center(child: Text("No booking details found."));
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'Poppins'),
                              children: [
                                const TextSpan(
                                  text: 'ID : ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: '${data.orderId} ',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: 'Status : ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: _getStatusText(data.status),
                                  style: TextStyle(
                                      color: _getStatusColor(data.status),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 10, top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                HelperFunctions.formatBookingDate(
                                    data.pickupDate, data.pickupTime),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                data.subTypeLabel == 'Round Trip' &&
                                        (data.noOfDays.isNotEmpty &&
                                            data.noOfDays != '0')
                                    ? '${data.subTypeLabel} (${data.noOfDays} Days)'
                                    : data.subTypeLabel,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3E4959),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(
                            height: 1, thickness: 1, color: Color(0xFF2196F3)),

                        /// Route: Pickup & Drop (Refined Design)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Stack(
                            children: [
                              // Vertical Connector Line
                              Positioned(
                                left: 8.25,
                                top: 20,
                                bottom: 10,
                                child: CustomPaint(
                                  size: const Size(1.5, double.infinity),
                                  painter: DashLinePainter(),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 📍 Header: Pickup City
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 18, color: Colors.orange),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                data.pickupLocation,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Poppins'),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>
                                                  HelperFunctions.navigateToMap(
                                                      data.pickupLocation,
                                                      data.dropLocation),
                                              child: const Icon(Icons.near_me,
                                                  color: Color(0xFF2196F3),
                                                  size: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // ⏱️ Duration (For Round Trip)
                                  if (data.subTypeLabel == 'Round Trip')
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Duration: ${data.noOfDays.isNotEmpty ? data.noOfDays : '1'} DAYS",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87,
                                                fontFamily: 'Poppins'),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 75,
                                                child: Text(
                                                  "Details : ",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins'),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Pickup: ${data.pickupLocation}",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Color(0xFF1B5E20),
                                                          fontFamily:
                                                              'Poppins'),
                                                    ),
                                                    const SizedBox(height: 12),

                                                    // Dynamic Stops
                                                    ...() {
                                                      if (data
                                                          .dropLocation.isEmpty)
                                                        return <Widget>[];
                                                      List<String> stops = data
                                                          .dropLocation
                                                          .split(RegExp(
                                                              r'[,|\n]'));
                                                      if (stops.length <= 1) {
                                                        return [
                                                          Text(
                                                            "Drop: ${data.dropLocation}",
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFF1B5E20),
                                                                fontFamily:
                                                                    'Poppins'),
                                                          )
                                                        ];
                                                      }

                                                      List<Widget> stopWidgets =
                                                          [];
                                                      for (int i = 0;
                                                          i < stops.length - 1;
                                                          i++) {
                                                        if (stops[i]
                                                            .trim()
                                                            .isEmpty) continue;
                                                        stopWidgets.add(Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 12),
                                                          child: Text(
                                                            "stop: ${stops[i].trim()}",
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFF1B5E20),
                                                                fontFamily:
                                                                    'Poppins'),
                                                          ),
                                                        ));
                                                      }
                                                      stopWidgets.add(Text(
                                                        "Drop: ${stops.last.trim()}",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xFF1B5E20),
                                                            fontFamily:
                                                                'Poppins'),
                                                      ));
                                                      return stopWidgets;
                                                    }(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 75), // Exact match
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  "*Parking Extra Only",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF1B5E20),
                                                      fontFamily: 'Poppins'),
                                                ),
                                                Text(
                                                  "*All inclusive amount(tolls taxes)",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF1B5E20),
                                                      fontFamily: 'Poppins'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else ...[
                                    // 📍 ONE WAY Drop Location
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 18, color: Color(0xFFC51C1C)),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            data.dropLocation,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Poppins'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),

                              // icon in middle of line for round trip
                              if (data.subTypeLabel == 'Round Trip')
                                Positioned(
                                  left: 0,
                                  top: 100,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.sticky_note_2,
                                        size: 18, color: Color(0xFF4CAF50)),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        /// Vehicle/Category Info
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              () {
                                final String? img = data.carImage;
                                if (img == null || img.isEmpty) {
                                  return Image.asset("assets/images/carMO.png",
                                      height: 60);
                                }
                                final String fullUrl = img.startsWith('http')
                                    ? img
                                    : "${ApiConstants.baseUrl}$img";
                                return Image.network(
                                  fullUrl,
                                  height: 60,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset("assets/images/carMO.png",
                                          height: 60),
                                );
                              }(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  data.vehicleType,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Remark
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'Poppins'),
                              children: [
                                const TextSpan(
                                  text: 'Extra Requirement : ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text: () {
                                    List<String> combined = [];
                                    if (data.extra != null &&
                                        data.extra!.isNotEmpty) {
                                      combined.add(data.extra!);
                                    }
                                    if (data.remark.isNotEmpty) {
                                      combined.add(data.remark);
                                    }
                                    return combined.isNotEmpty
                                        ? combined.join(", ")
                                        : "No notes provided";
                                  }(),
                                  style: const TextStyle(
                                      color: Color(0xFFF45858),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// Fares/Statistics
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              _priceBox("₹${data.totalAmount}", "Total Amount"),
                              const SizedBox(width: 8),
                              _priceBox(
                                  "₹${data.totalAmount - data.driverCommission}",
                                  "Driver's Earning",
                                  isEarning: true),
                              const SizedBox(width: 8),
                              _priceBox(
                                  "₹${data.driverCommission}", "Commission"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    final driver = state.bookingDetailModel?.driverDetails;
                    
                    // Prioritize driverDetails, but allow data to provide context
                    final String name = driver?.name ?? data.creatorName ?? 'Agent';
                    final String phone = driver?.phoneNumber ?? data.creatorPhone ?? data.driverPhone ?? '';
                    final String cityName = driver?.cityName ?? data.pickUpCity ?? '';
                    
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Try driver id first, then internal driverId, then booking's driverId
                          final dId = (driver?.id != 0 ? driver?.id : null)?.toString() ?? 
                                     (driver?.driverId != 0 ? driver?.driverId : null)?.toString() ??
                                     (data.driverId != 0 ? data.driverId : null)?.toString();
                                     
                          if (dId == null || dId == "0") {
                            debugPrint("🚫 No valid driver ID found for review screen: driver=$driver, data.driverId=${data.driverId}");
                            return;
                          }
                          Nav.push(context, Routes.reviewScreen, extra: dId);
                        },
                        child: DriverInfoCard(
                          imagePath: (driver?.driverImage != null &&
                                  driver!.driverImage.isNotEmpty)
                              ? (driver.driverImage.startsWith('http')
                                  ? driver.driverImage
                                  : driver.driverImage.contains('photo')
                                      ? 'https://cabyatra.com/public/uploads/driver_photo/${driver.driverImage}'
                                      : 'https://cabyatra.com/public/uploads/sub_driver_docs/${driver.driverImage}')
                              : 'https://img.freepik.com/premium-vector/blue-car-flat-style-illustration-isolated-white-background_108231-795.jpg?semt=ais_hybrid&w=740&q=80',
                          name: name,
                          subtitle: driver != null
                              ? cityName
                              : 'Verification in progress',
                          rating: driver?.rating ?? 5.0,
                          reviewCount: driver?.reviewCount ?? 0,
                          showImage: true,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          );
        },
      ),
      bottomSheet: widget.hideChat
          ? const SizedBox.shrink()
          : BlocBuilder<BookingDetailBloc, BookingDetailState>(
              builder: (context, state) {
                final data = state.bookingDetailModel?.data;
                if (data == null) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  child: _buildChatAction(context, data, state),
                );
              },
            ),
    );
  }

  Widget _buildChatAction(BuildContext context, dynamic data, BookingDetailState state) {
    return CommonAppButton(
      text: "Chat",
      assetIcon: "assets/images/chatNew.png",
      backgroundColor: const Color(0xffFCB117),
      onPressed: () async {
        final myId = await SecureStorageService.getUserId();
        // Check both creatorId and driverId — for driver-posted bookings,
        // the API may not return user_id/creator_id, so driver_id IS the creator.
        final bool isMeCreator = myId == data.creatorId || 
            myId == data.driverId.toString();

        // --- NEW: AD-HOC AVAILABILITY CHECK FOR AGENTS ---
        if (!isMeCreator) {
          // Show a quick loader while checking
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xffFCB117))),
          );

          try {
            final driverRepo = DriverRepo();
            final driverRes = await driverRepo.getDrivers(isApprove: 1);
            final vehicleRes = await driverRepo.getVehicles(isApprove: 1);

            if (context.mounted) Navigator.pop(context); // Close loader

            if (driverRes.drivers.isEmpty || vehicleRes.vehicles.isEmpty) {
              String missing = "";
              if (driverRes.drivers.isEmpty && vehicleRes.vehicles.isEmpty) missing = "driver and vehicle";
              else if (driverRes.drivers.isEmpty) missing = "driver";
              else missing = "vehicle";

              Fluttertoast.showToast(
                msg: 'Please add an approved $missing to your profile first.',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: const Color(0xFFF45858),
                textColor: Colors.white,
              );
              return;
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Error checking profile details. Please try again.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: const Color(0xFFF45858),
                textColor: Colors.white,
              );
            }
            return;
          }
        }
        // ---------------------------------------------------

        // Existing availability check regarding the booking itself
        // Only enforce for non-creators (agents). Creators can always open chat.
        if (!isMeCreator) {
          final bool isVehicleAvailable = data.vehicleType != null && data.vehicleType.isNotEmpty;
          final bool isDriverAvailable = (data.status == '0') 
              ? true 
              : ((data.assignDriverId != null && data.assignDriverId != 0) || 
                 (data.assignSubDriverId != null && data.assignSubDriverId != 0) ||
                 (data.driverId != null && data.driverId != 0));

          if (!isVehicleAvailable || !isDriverAvailable) {
            Fluttertoast.showToast(
              msg: !isVehicleAvailable ? 'Vehicle details not available' : 'Driver details not available',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: const Color(0xFFF45858),
              textColor: Colors.white,
            );
            return;
          }
        }

        final bool isDirectChat = widget.isFromHome ||
            data.status == '1' ||
            data.status == '4' ||
            (data.assignDriverId != null && data.assignDriverId != 0) ||
            (data.assignSubDriverId != null && data.assignSubDriverId != 0);

        if (isDirectChat) {
          final myId = await SecureStorageService.getUserId();
          final isMeCreator = myId == data.creatorId;

          // Prefer assignDriverId, then assignSubDriverId, then driverId
          final String finalReceiverId = isMeCreator
              ? ((data.assignDriverId != null && data.assignDriverId != 0)
                  ? data.assignDriverId.toString()
                  : (data.assignSubDriverId != null && data.assignSubDriverId != 0)
                      ? data.assignSubDriverId.toString()
                      : data.driverId.toString())
              : (data.creatorId ?? data.driverId.toString());

          final String finalUserName = isMeCreator
              ? (state.bookingDetailModel?.driverDetails?.name ?? data.vehicleType)
              : (data.creatorName.isEmpty ? "Agent" : data.creatorName);

          Nav.push(context, Routes.chatScreen, extra: {
            'userName': finalUserName,
            'bookingId': widget.bookingID,
            'creatorName': data.creatorName.isEmpty ? 'Guddu' : data.creatorName,
            'driver_id': finalReceiverId, // 👈 Added driver_id
            'receiverId': finalReceiverId,
            'isFromDetails': true,
          });
        } else {
          ChatListingScreen.show(context, bookingId: widget.bookingID);
        }
      },
    );
  }

  Widget _priceBox(String amount, String label, {bool isEarning = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
                color: isEarning ? const Color(0xFFF45858) : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 8,
                color: Colors.black87,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String? status) {
    final s = status ?? '0';
    switch (s) {
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
        return 'Unknown ($s)';
    }
  }

  Color _getStatusColor(String? status) {
    final s = status ?? '0';
    switch (s) {
      case '0':
        return const Color(0xff45B129);
      case '1':
        return Colors.orange;
      case '2':
        return const Color(0xff45B129);
      case '3':
        return const Color(0xffF45858);
      case '4':
        return Colors.blue;
      case '5':
        return Colors.grey; // Grey for Expired
      default:
        return Colors.black;
    }
  }
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
