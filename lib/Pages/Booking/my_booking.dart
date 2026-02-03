import 'dart:convert';
import 'package:cab_taxi_app/Pages/Add%20New%20Booking/add_new_booking.dart';
import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/ui/homepage.dart';
import 'package:cab_taxi_app/Pages/Mohnish_Sir/chat_listing.dart';
import 'package:cab_taxi_app/models/my_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/my_booking_controller.dart';
import '../../core/network_service.dart';
import '../../core/utils/helperFunctions.dart';
import '../Custom_Widgets/custom_text_button.dart';
import '../Custom_Widgets/CustomShimmer_widget.dart';
import '../Review/write_review.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final MyBookingController controller = Get.put(MyBookingController());
  final HomeController homeController = Get.put(HomeController());


  @override
  void initState() {
    super.initState();
    controller.getMyBookingData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    controller.getMyBookingData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(title: "My Booking"),
      body: RefreshIndicator(
        onRefresh: ()async {
          await controller.getMyBookingData();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<MyBookingController>(
                init: MyBookingController(),
                builder: (controller) {
                if(controller.myBookingData.value.myBooking == null){
                  return Center(
                      heightFactor: size.height*0.02,
                      child: const CircularProgressIndicator()
                  );

                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.myBookingData.value.myBooking == null

                          ? Center(
                          heightFactor: size.height*0.02,
                          child: CircularProgressIndicator()
                      )
                          :controller.myBookingData.value.myBooking!.data!.isEmpty?const Text("No Booking Found"): ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.myBookingData.value.myBooking!.data!.length,
                          itemBuilder: (context, index) {
                            var newBookingData = controller.myBookingData.value.myBooking!.data![index];
                            return controller.myBookingData.value.myBooking!.data!.isEmpty
                                ? const Center(
                              child: Text('No active booking'),
                            )
                                : customCards(context, newBookingData,);
                          }),
                    ],
                  ),
                );
              },),

            ],
          ),
        ),
      ),
    );
  }


  Widget customCards(BuildContext context, MyBookingData data) {
    final size = MediaQuery.of(context).size;
    String? destinationAddress = data.destinationLoc!.isEmpty ? 'Not Available' : data.destinationLoc;
    List<String> dropCities = [];
    print(data.status);
    if (destinationAddress!.isNotEmpty) {
      var parsedDestination = json.decode(destinationAddress);
      dropCities = List<String>.from(
          parsedDestination.map((city) => city.replaceAll('"', '')));
    }
    List<dynamic> parseAddOnService(String addOnService) {
      if (addOnService.isNotEmpty && addOnService != "[]") {
        return jsonDecode(addOnService);
      }
      return [];
    }
    List<String> pickCities = [];
    if (data.pickUpLoc != null && data.pickUpLoc!.isNotEmpty) {
      for (String loc in data.pickUpLoc!) {
        if (loc.isNotEmpty) {
          try {
            var parsedPickup = json.decode(loc);
            if (parsedPickup is List) {
              pickCities.addAll(List<String>.from(
                  parsedPickup.map((city) => city.replaceAll('"', ''))));
            } else {
              pickCities.add(loc.replaceAll('"', ''));
            }
          } catch (e) {
            pickCities.add(loc.replaceAll('"', ''));
          }
        } else {
          pickCities.add('Not Available');
        }
      }
    } else {
      pickCities.add('Not Available');
    }
    String? initialTotal = '0';
    if (data.offlinePayment!.isNotEmpty && data.driverComission!.isNotEmpty) {
      final double offlinePaymentValue = double.tryParse(data.offlinePayment!) ?? 0;
      final double driverCommissionValue = double.tryParse(data.driverComission!) ?? 0;
      final double totalValue = offlinePaymentValue + driverCommissionValue;
      initialTotal = totalValue.toString();
    }
    String pickUpDateStr = data.pickUpDate.toString();
    DateTime pickUpDate = DateFormat('yyyy-MM-dd').parse(pickUpDateStr);////
    String formattedDate = DateFormat('d MMM yyyy').format(pickUpDate);
    String? destD = '';
    if(data.destination_date!.isNotEmpty && data.destination_date != null){
      String d = data.destination_date.toString();
      DateTime dd = DateFormat('yyyy-MM-dd').parse(d);
      String destDate = DateFormat('d MMM yyyy').format(dd);
      destD = destDate;
    }
    return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 7, left: 7, right: 7),
                            child: Row(
                              children: [
                                Image.asset('assets/images/calender.png', scale: 5),
                                SizedBox(width: size.width * 0.02),
                                InkWell(
                                  child: Text(
                                    formattedDate,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Spacer(),
                                Text('ID : ${data.orderId.toString()}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, right: 7),
                            child: Row(
                              children: [
                                Image.asset(
                                    'assets/images/clock.png', scale: 5),
                                SizedBox(width: size.width * 0.02),
                                InkWell(
                                  child: Text(
                                    data.pickUpTime.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Spacer(),
                                Text(data.subTypeLabel.toString(),
                                    // 'One Way Trip',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Divider(
                              thickness: 1, color: Color.fromRGBO(
                              0, 0, 0, 0.2)),
                          Padding(
                            padding: const EdgeInsets.only(left: 7, right: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.85,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (pickCities.length == 1)
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: size.width * 0.035,
                                                    height: size.height * 0.017,
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromRGBO(
                                                          212, 119, 22, 1),
                                                      borderRadius:
                                                      BorderRadius.circular(30),
                                                    ),
                                                  ),
                                                  SizedBox(width: size.width * 0.02),
                                                  SizedBox(
                                                    width: size.width * 0.6,
                                                    child: Text(
                                                      pickCities.first,
                                                      style: TextStyle(
                                                        fontSize: size.width * 0.035,
                                                        fontFamily: 'Poppins',
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            else
                                              Container(
                                                // height: (pickCities.length * 30).toDouble(),
                                                width: size.width * 0.7,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: pickCities.length,
                                                  itemBuilder: (context, index) {
                                                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> i dont  know why3");
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: size.width * 0.035,
                                                              height: size.height * 0.017,
                                                              decoration: BoxDecoration(
                                                                color: index == 0
                                                                    ? const Color
                                                                    .fromRGBO(
                                                                    212, 119, 22, 1)
                                                                    : Colors.green,
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    30),
                                                              ),
                                                            ),
                                                            SizedBox(width: size.width * 0.02),
                                                            SizedBox(
                                                              width: size.width * 0.55,
                                                              child: Text(
                                                                pickCities[index],
                                                                style: TextStyle(
                                                                  fontSize:
                                                                  size.width * 0.035,
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight:
                                                                  FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: size.height*0.01),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            const Spacer(),
                                            Column(
                                              children: [
                                                if(data.status == '3')
                                                  Text(
                                                      "Cancelled",
                                                      style: TextStyle(
                                                          fontSize: size.width * 0.04,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.red)),
                                                  if(data.status == '2')//completed ride
                                                    Text(
                                                        "Completed",
                                                        style: TextStyle(
                                                            fontSize: size.width * 0.035,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.green)),
                                                Row(
                                                  children: [
                                                    // if (data.driver_number!.isNotEmpty && data.driver_number != null)
                                                    GestureDetector(
                                                        onTap: () {
                                                          print('tapped');
                                                          HelperFunctions.makePhoneCall(context,data.driver_number??'');
                                                        },
                                                        child: Image.asset(
                                                            'assets/images/call_1.png',
                                                            scale: 4)),
                                                    SizedBox(width: size.width * 0.03),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await HelperFunctions.shareMessage(
                                                          data.orderId ?? 'N/A',
                                                          data.pickUpDate ?? 'N/A',
                                                          pickCities.isNotEmpty ? pickCities.toString() : 'N/A',
                                                          dropCities.isNotEmpty ? dropCities.toString() : 'N/A',
                                                          data.car?.name??'N/A', // Vehicle
                                                          data.subTypeLabel ?? 'N/A',
                                                          data.offlinePayment ?? 'N/A',
                                                          data.driverComission ?? 'N/A',
                                                          (data.addOnService != null && data.addOnService!.isNotEmpty) ? "With carrier" : "N/A", // Extra Requirements
                                                          // 'N/A',
                                                          data.driver_number??'N/A',
                                                        );                                  },
                                                      child: Image.asset('assets/images/share.png', scale: 4),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      // SizedBox(height: size.height * 0.005),
                                      // Container(
                                      //   padding: EdgeInsets.only(
                                      //       left: size.width * 0.015),
                                      //   height: size.height * 0.03,
                                      //   child: CustomPaint(
                                      //       painter: DashedLinePainter()),
                                      // ),
                                      // SizedBox(height: size.height * 0.005),
                                      if(data.typeLabel != 'Local')
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [
                                            if (dropCities.length == 1)
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: size.width * 0.035,
                                                  height: size.height * 0.017,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFC51C1C),
                                                    borderRadius: BorderRadius
                                                        .circular(30),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: size.width * 0.02),
                                                SizedBox(
                                                  width: size.width * 0.6,
                                                  child: Text(
                                                    dropCities.first,
                                                    style: TextStyle(
                                                      fontSize: size.width *
                                                          0.035,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                            else
                                              Container(
                                                // height: (dropCities.length * 25).toDouble(),
                                                width: size.width * 0.7,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: dropCities.length,
                                                  itemBuilder: (context, index) {
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: size.width * 0.035,
                                                              height: size.height * 0.017,
                                                              decoration: BoxDecoration(
                                                                color: index == dropCities.length - 1
                                                                    ?  Color(0xFFC51C1C)
                                                                    : Colors.green,
                                                                borderRadius: BorderRadius.circular(30),
                                                              ),
                                                            ),
                                                            SizedBox(width: size.width * 0.02),
                                                            SizedBox(
                                                              width: size.width * 0.55,
                                                              child: Text(
                                                                dropCities[index],
                                                                style: TextStyle(
                                                                  fontSize: size.width * 0.035,
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: size.height*0.01),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if(data.destination_date!.isNotEmpty)
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 5, left: 7, right: 7),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'End Date: ',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Image.asset('assets/images/calender.png',
                                          scale: 5),
                                      SizedBox(width: size.width * 0.02),
                                      Text(
                                        '${destD ?? ''}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(width: size.width * 0.02),
                                      Image.asset(
                                          'assets/images/clock.png', scale: 5),
                                      SizedBox(width: size.width * 0.01),
                                      Text(
                                        '11:59 PM',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: Container(
                              width: size.width * 0.9,
                              height: size.height * 0.08,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            bottomLeft: Radius.circular(6)),
                                        color: const Color.fromRGBO(
                                            225, 242, 255, 1),
                                        border: Border.all(
                                            color: Colors.white, width: 1.5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Parking",
                                            style: TextStyle(
                                                fontSize: size.width * 0.035,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Text(
                                            "Extra",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            225, 242, 255, 1),
                                        border: Border.all(
                                            color: Colors.white, width: 1.5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Toll",
                                            style: TextStyle(
                                                fontSize: size.width * 0.035,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Text(
                                            data.toll ?? "",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(6),
                                            bottomRight: Radius.circular(6)),
                                        color: const Color.fromRGBO(
                                            225, 242, 255, 1),
                                        border: Border.all(
                                            color: Colors.white, width: 1.5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Tax",
                                            style: TextStyle(
                                                fontSize: size.width * 0.035,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Text(
                                            data.tax ?? "",
                                            // "Included",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.008,
                                  height: size.height * 0.004,
                                  decoration: BoxDecoration(
                                      color:
                                      const Color.fromRGBO(255, 0, 0, 1),
                                      borderRadius:
                                      BorderRadius.circular(35)),
                                ),
                                SizedBox(width: size.width * 0.02),
                                Expanded(
                                  child: Text(
                                    (parseAddOnService(data.addOnService!)
                                        .isNotEmpty
                                        ? "There Should be carrier | "
                                        : "") +
                                        (data.remark ?? ''),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (data.typeLabel != 'Local')
                                Column(
                                  children: [
                                    Text(
                                      data.include_km != null
                                          ? (data.include_km!.endsWith('km')
                                          ? data.include_km!
                                          : '${data.include_km} km')
                                          : 'N/A',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(46, 46, 46, 0.6),
                                      ),
                                    ),
                                    const Text(
                                      "Total KM",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              if (data.typeLabel == 'Local')
                                Column(
                                  children: [
                                    Text(
                                        data.timeScheduleData?.time ?? 'N/A',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color:
                                            Color.fromRGBO(46, 46, 46, 0.6))),
                                    const Text("Total KM",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ],
                                ),
                              Column(
                                children: [
                                  Text('₹${data.extra_fair_perKm??'N/A'}/km',
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(46, 46, 46, 0.6))),
                                  const Text("Extra Per KM",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.18,
                                  height: size.height * 0.037,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: const Color(0xFF45B129),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'CAB',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:const Color(0xFF45B129),
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("${data.carCategory?.name ?? "N/A"}",
                                    style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(0, 0, 0, 0.5))),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black),
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: 'Total Amount:   ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                          '₹ ${((double.tryParse(
                                              data.driverComission ?? '0') ??
                                              0.0) + (double.tryParse(
                                              data.offlinePayment ?? '0') ??
                                              0.0)).toString()}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  69, 177, 41, 1))),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.black),
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: 'Driver Earning:   ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: '₹ ${data.offlinePayment ??
                                              "0"}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  69, 177, 41, 1))),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.04),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (data.status == '0')
                                  Expanded(
                                    child: CustomTextButton(
                                      title: "Delete",
                                      color: Colors.red,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteBookingDialog(
                                              bookingId: data.id,
                                              controller: controller,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                if (data.status == '0')
                                  Expanded(
                                    child: CustomTextButton(
                                      title: "Edit",
                                      color: Colors.black,
                                      textColor: Colors.white,
                                      onPressed: () {

                                      },
                                    ),
                                  ),
                                if (data.status == '1')
                                  Expanded(
                                    child: CustomTextButton(
                                      title: "Cancel",
                                      color: const Color.fromRGBO(255, 0, 0, 1),
                                      textColor: Colors.white,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CancelBookingDialog(
                                              bookingId: data.id.toString(),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                if (data.status != '3')
                                  Expanded(
                                    child: CustomTextButton(
                                      title: "Chat",
                                      color: const Color(0xFF45B129),
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Get.to(() => const ChatListingScreen());
                                      },
                                    ),
                                  ),
                                if (HelperFunctions.isPickupTime(data.pickUpDate, data.pickUpTime) && data.status == '1')
                                  Expanded(
                                    child: CustomTextButton(
                                      title: "Pickup",
                                      color: const Color.fromRGBO(255, 185, 0, 1),
                                      textColor: Colors.white,
                                      onPressed: () async {
                                        final result = await NetworkService().verifyStartRideOtp(
                                          bookingId: data.id.toString(),
                                        );
                                        print(result);
                                        controller.getMyBookingData();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(result?['message'] ?? 'An error occurred'),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (data.status == '4')
                            SizedBox(
                              width: double.infinity,
                              child: CustomTextButton(
                                title: "Complete Booking",
                                color: const Color(0xFFB15A29),
                                textColor: Colors.white,
                                onPressed: () async {
                                  bool? confirm = await _showConfirmationDialog(context);
                                  if (confirm == true) {
                                    final result = await NetworkService().endRide(bookingId: data.id.toString());
                                    if (result != null && result['status'] == true) {
                                      Fluttertoast.showToast(msg: "Ride Completed Successfully!");
                                      if (data.driver_number != null && data.driver_number!.isNotEmpty) {
                                        Get.to(() => ReviewPage(
                                          driverId: data.driver_id,
                                          bookingId: data.id.toString(),
                                        ));
                                      } else {
                                        await homeController.getHomeData();
                                      }
                                    }
                                  } else {
                                    print("User canceled the booking.");
                                  }
                                },
                              ),
                            ),
                          if (data.status == '4' || data.status == '2')
                          SizedBox(
                            width: double.infinity,
                            child: CustomTextButton(
                              title: "Write your Review",
                              color:  Colors.blueGrey,
                              textColor: Colors.white,
                              onPressed: () {
                                        Get.to(() => ReviewPage(
                                          bookingId: data.id.toString(),
                                          driverId: data.driver_id,
                                        ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );


  }
  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Are you sure?'),
          content: Text('Do you want to complete the booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFFFB900),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Confirm'),
            )
          ],
        );
      },
    );
  }
}
//////
class DeleteBookingDialog extends StatelessWidget {
  var bookingId;
  MyBookingController controller;



  DeleteBookingDialog({super.key, required this.bookingId,required this.controller});

 // final controller = Get.put(MyBookingController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: GetBuilder<MyBookingController>(
        init: MyBookingController(),
        builder: (controller) {
       if  ( controller.myBookingLoading.value){
         return             Center(
               child: CustomShimmerContainer(
                 width: screenWidth * 0.8,
                 height: screenHeight * 0.05,
               ),
           );
       }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want to Delete Booking',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFF0000),
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.deleteBooking(
                          bookingId: bookingId);
                    },
                    child: Container(
                      width: screenWidth * 0.27,
                      height: screenHeight * 0.05,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFF0000),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const Center(
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: screenWidth * 0.27,
                      height: screenHeight * 0.05,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },),
      // child: Obx(() {
      //   return controller.myBookingLoading.value
      //       ?  Center(
      //       child: CustomShimmerContainer(
      //         width: screenWidth * 0.8,
      //         height: screenHeight * 0.05,
      //       ),
      //   )
      //       : Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         const Text(
      //           'Are you sure you want to Delete Booking',
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //             color: Color(0xFFFF0000),
      //             fontSize: 22,
      //             fontFamily: 'Poppins',
      //             fontWeight: FontWeight.w500,
      //           ),
      //           softWrap: true,
      //         ),
      //         SizedBox(
      //           height: screenHeight * 0.02,
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             GestureDetector(
      //               onTap: () {
      //                 controller.deleteBooking(
      //                     bookingId: bookingId);
      //               },
      //               child: Container(
      //                 width: screenWidth * 0.27,
      //                 height: screenHeight * 0.05,
      //                 decoration: ShapeDecoration(
      //                   color: const Color(0xFFFF0000),
      //                   shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(5)),
      //                 ),
      //                 child: const Center(
      //                   child: Text(
      //                     'Yes',
      //                     style: TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 16,
      //                       fontFamily: 'Poppins',
      //                       fontWeight: FontWeight.w500,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             GestureDetector(
      //               onTap: () {
      //                 Navigator.of(context).pop();
      //               },
      //               child: Container(
      //                 width: screenWidth * 0.27,
      //                 height: screenHeight * 0.05,
      //                 decoration: ShapeDecoration(
      //                   shape: RoundedRectangleBorder(
      //                     side: BorderSide(
      //                       width: 2,
      //                       color: Colors.black.withOpacity(0.5),
      //                     ),
      //                     borderRadius: BorderRadius.circular(5),
      //                   ),
      //                 ),
      //                 child: Center(
      //                   child: Text(
      //                     'No',
      //                     style: TextStyle(
      //                       color: Colors.black.withOpacity(0.5),
      //                       fontSize: 16,
      //                       fontFamily: 'Poppins',
      //                       fontWeight: FontWeight.w600,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   );
      // }),
    );
  }
}