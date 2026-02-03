import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';
import 'homepage.dart';
class ActiveBookingSection extends StatefulWidget {
  const ActiveBookingSection({super.key});

  @override
  State<ActiveBookingSection> createState() => _ActiveBookingSectionState();
}

class _ActiveBookingSectionState extends State<ActiveBookingSection> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        // await controller.getHomeData();
      },
      child:  BlocBuilder<DashboardBloc,DashboardState>(
          builder: (context,state) {
            if(state.isLoading){
              return const CircularProgressIndicator();

            }
            if(state.homeDataResponseModel==null){
              return const CircularProgressIndicator();

            }

            final activeBooking=state.homeDataResponseModel!.activeBooking.data;


            return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // alignment:Alignment.centerRight,
                    //itemCount: activeBooking.length,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      // var newBookingData = controller
                      //     .homeData.value.newBooking!.data![index];
                      return GestureDetector(
                        // onTap: () async {
                        //   bool? bankInfoStatus = await NetworkService().checkBankInfo();
                        //   if (bankInfoStatus == true) {
                        //     NewBookingData?data;
                        //     // Get.to(() => DetailPage(
                        //     //   data: data!,
                        //     //   // totalDistance: totalDistance.toStringAsFixed(2),
                        //     // ));
                        //   } else {
                        //     Fluttertoast.showToast(
                        //       msg: 'Please add the Account Details!',
                        //       gravity: ToastGravity.CENTER,
                        //       backgroundColor: Colors.red,
                        //       textColor: Colors.white,
                        //     );
                        //   }
                        // },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 2,
                                      offset: Offset(0, 0),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                                      child: Row(
                                        children: [
                                          Text(
                                            "ID:334",
                                              //'ID : ${activeBooking[index].bookingId}',
                                              style: const TextStyle(
                                                  fontSize: 12, fontWeight: FontWeight.w500)),
                                          // Text('654',
                                          //     style: const TextStyle(
                                          //         fontSize: 12, fontWeight: FontWeight.w500,color: Color(0xffFCB117))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.005),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 7, right: 7),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  "12/56",
                                                 // activeBooking[index].pickupDate,
                                                  style: const TextStyle(
                                                      fontSize: 12, fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "@ ",
                                                style: const TextStyle(
                                                    fontSize: 12, fontWeight: FontWeight.w500),
                                              ),
                                              InkWell(
                                                // onTap: () => _selectTime(context), // Pick the time
                                                child: Text(
                                                  "yggh",
                                                 // activeBooking[index].pickupTime,
                                                  //data.pickUpTime.toString(),
                                                  // selectedTime != null
                                                  //     ? selectedTime!.format(context)
                                                  //     : TimeOfDay.now().format(context),
                                                  style: const TextStyle(
                                                      fontSize: 12, fontWeight: FontWeight.w500,color: Color(0xffF45858)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Text(
                                            //data.subTypeLabel.toString(),
                                              'One Way Trip',
                                              style: const TextStyle(
                                                  fontSize: 14, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                        thickness: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 7, right: 7),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.87,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [

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
                                                            "hggg",
                                                            //activeBooking[index].pickupLocation,
                                                            style: TextStyle(
                                                              fontSize: size.width * 0.035,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
// Container(
                                                    //   // height: (pickCities.length * 30).toDouble(),
                                                    //   width: size.width * 0.7,
                                                    //   child: ListView.builder(
                                                    //     shrinkWrap: true,
                                                    //     itemCount: 3,
                                                    //     physics: NeverScrollableScrollPhysics(),
                                                    //     itemBuilder: (context, index) {
                                                    //       return Column(
                                                    //         mainAxisAlignment:
                                                    //         MainAxisAlignment.start,
                                                    //         crossAxisAlignment:
                                                    //         CrossAxisAlignment.start,
                                                    //         children: [
                                                    //           Row(
                                                    //             mainAxisSize: MainAxisSize.min,
                                                    //             children: [
                                                    //               Container(
                                                    //                 width: size.width * 0.035,
                                                    //                 height: size.height * 0.017,
                                                    //                 decoration: BoxDecoration(
                                                    //                   color: index == 0
                                                    //                       ? const Color
                                                    //                       .fromRGBO(
                                                    //                       212, 119, 22, 1)
                                                    //                       : Colors.green,
                                                    //                   borderRadius:
                                                    //                   BorderRadius.circular(
                                                    //                       30),
                                                    //                 ),
                                                    //               ),
                                                    //               SizedBox(
                                                    //                   width: size.width * 0.02),
                                                    //               SizedBox(
                                                    //                 width: size.width * 0.55,
                                                    //                 child: Text(
                                                    //                   "Merath",
                                                    //                   style: TextStyle(
                                                    //                     fontSize:
                                                    //                     size.width * 0.035,
                                                    //                     fontFamily: 'Poppins',
                                                    //                     fontWeight:
                                                    //                     FontWeight.w600,
                                                    //                   ),
                                                    //                 ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //
                                                    //
                                                    //           SizedBox(
                                                    //               height: size.height * 0.01),
                                                    //         ],
                                                    //       );
                                                    //     },
                                                    //   ),
                                                    // ),
                                                    const Spacer(),
                                                    Icon(Icons.arrow_forward_ios_sharp)


                                                  ],
                                                ),
                                              ),

                                              //  if (data.typeLabel != 'Local')
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  //  if (dropCities.length == 1)
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: size.width * 0.035,
                                                        height: size.height * 0.017,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFC51C1C),
                                                          borderRadius:
                                                          BorderRadius.circular(30),
                                                        ),
                                                      ),
                                                      SizedBox(width: size.width * 0.02),
                                                      SizedBox(
                                                        width: size.width * 0.6,
                                                        child: Text(
                                                          "jhhg",
                                                         // activeBooking[index].destinationLocation ?? "N/A",
                                                          style: TextStyle(
                                                            fontSize: size.width * 0.035,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),


                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    //  if (data.destination_date!.isNotEmpty)

                                    // SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                                      child: Row(
                                        children: [
                                          // Image.network(activeBooking[index].carImage,scale: 4,errorBuilder: (context, error, stackTrace) {
                                          //   return Image.asset("assets/images/carMO.png",scale: 4,);
                                          // },),
                                          //  Image.asset("assets/images/carMO.png",scale: 4,),
                                          SizedBox(width: 5,),
                                          Text(
                                            "dsf",
                                         //   activeBooking[index].carCategoryName ?? "N/A",
                                            style: TextStyle(
                                              color: Colors.black.withValues(alpha: 0.50),
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),

                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Extra Requirement : ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "dsfsdnfnsdhn",
                                         //   activeBooking[index].remark??"N/A",
                                            style: TextStyle(
                                              color: const Color(0xFFF45858),
                                              fontSize: 11,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: Container(
                                        width: size.width *
                                            0.9, // Adjust the container width as needed
                                        height: size.height *
                                            0.08, // Adjust the container height as needed
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                              color: Colors.white,
                                              width: 2), // Outer border for entire container
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch, // Ensure equal height
                                          children: [
                                            // First part
                                            Expanded(
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: const Color(0xADEFEFEF),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Rs 43",
                                                    //  "₹${activeBooking[index].totalFare}",
                                                      style: TextStyle(
                                                          fontSize: size.width * 0.035,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    SizedBox(height: size.height * 0.01),
                                                    Text(
                                                      // data.carCategory?.parking ?? "",
                                                      "Total Amount",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),  SizedBox(width: 5,),
                                            // Second part
                                            Expanded(
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: const Color(0xADEFEFEF),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Rs 43",
                                                   //   "₹${activeBooking[index].driverCommission??""}",
                                                      style: TextStyle(
                                                          fontSize: size.width * 0.035,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    SizedBox(height: size.height * 0.01),
                                                    Text(
                                                      "Driver’s Earning",
                                                      //data.toll ?? "",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            // Third part
                                            Expanded(
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: const Color(0xADEFEFEF),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "RS 89",
                                                      //"₹${activeBooking[index].driverCommission??""}",
                                                      style: TextStyle(
                                                          fontSize: size.width * 0.035,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    SizedBox(height: size.height * 0.01),
                                                    Text(
                                                      "Commission",
                                                      //data.tax ?? "",
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
                                    // Padding(
                                    //   padding: const EdgeInsets.all(7),
                                    //   child: Row(
                                    //     children: [
                                    //       // Container(
                                    //       //   width: size.width * 0.008,
                                    //       //   height: size.height * 0.004,
                                    //       //   decoration: BoxDecoration(
                                    //       //       color: const Color.fromRGBO(255, 0, 0, 1),
                                    //       //       borderRadius: BorderRadius.circular(35)),
                                    //       // ),
                                    //       // SizedBox(width: size.width * 0.02),
                                    //       // Expanded(
                                    //       //   child: Text(
                                    //       //     (parseAddOnService(data.addOnService!).isNotEmpty
                                    //       //             ? "There Should be carrier | "
                                    //       //             : "") +
                                    //       //         (data.remark ?? ''),
                                    //       //     style: TextStyle(
                                    //       //       fontSize: 14,
                                    //       //       fontWeight: FontWeight.w500,
                                    //       //       color: Color.fromRGBO(255, 0, 0, 1),
                                    //       //     ),
                                    //       //   ),
                                    //       // )
                                    //     ],
                                    //   ),
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    //   children: [
                                    //     if (data.typeLabel != 'Local')
                                    //       Column(
                                    //         children: [
                                    //           Text(
                                    //             data.include_km != null
                                    //                 ? (data.include_km!.endsWith('km')
                                    //                     ? data.include_km!
                                    //                     : '${data.include_km} km')
                                    //                 : 'N/A',
                                    //             style: const TextStyle(
                                    //               fontSize: 17,
                                    //               fontWeight: FontWeight.w500,
                                    //               color: Color.fromRGBO(46, 46, 46, 0.6),
                                    //             ),
                                    //           ),
                                    //           const Text(
                                    //             "Total KM",
                                    //             style: TextStyle(
                                    //               fontSize: 10,
                                    //               fontWeight: FontWeight.w500,
                                    //               color: Colors.black,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     if (data.typeLabel == 'Local')
                                    //       Column(
                                    //         children: [
                                    //           Text(
                                    //               // totalDistanceRe.toString(),
                                    //               //   data.include_km??'N/A',
                                    //
                                    //               data.timeScheduleData?.time ?? 'N/A',
                                    //               style: const TextStyle(
                                    //                   fontSize: 17,
                                    //                   fontWeight: FontWeight.w500,
                                    //                   color: Color.fromRGBO(46, 46, 46, 0.6))),
                                    //           const Text("Total KM",
                                    //               style: TextStyle(
                                    //                   fontSize: 10,
                                    //                   fontWeight: FontWeight.w500,
                                    //                   color: Colors.black)),
                                    //         ],
                                    //       ),
                                    //     Column(
                                    //       children: [
                                    //         Text('₹${data.extra_fair_perKm ?? 'N/A'}/km',
                                    //             style: const TextStyle(
                                    //                 fontSize: 17,
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: Color.fromRGBO(46, 46, 46, 0.6))),
                                    //         const Text("Extra Per KM",
                                    //             style: TextStyle(
                                    //                 fontSize: 10,
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: Colors.black)),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(7.0),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.start,
                                    //     children: [
                                    //       Container(
                                    //         width: size.width * 0.18,
                                    //         height: size.height * 0.037,
                                    //         decoration: ShapeDecoration(
                                    //           shape: RoundedRectangleBorder(
                                    //             side: BorderSide(
                                    //               width: 1,
                                    //               color: const Color(0xFF45B129),
                                    //             ),
                                    //             borderRadius: BorderRadius.circular(8),
                                    //           ),
                                    //         ),
                                    //         child: Center(
                                    //           child: Text(
                                    //             'CAB',
                                    //             textAlign: TextAlign.center,
                                    //             style: TextStyle(
                                    //               color: const Color(0xFF45B129),
                                    //               fontSize: 10,
                                    //               fontFamily: 'Poppins',
                                    //               fontWeight: FontWeight.w600,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       SizedBox(
                                    //         width: 10,
                                    //       ),
                                    //       Text("${data.carCategory?.name ?? ""}",
                                    //           style: TextStyle(
                                    //               fontSize: size.width * 0.035,
                                    //               fontWeight: FontWeight.w400,
                                    //               color: Color.fromRGBO(0, 0, 0, 0.5))),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Column(
                                    //   crossAxisAlignment: CrossAxisAlignment.stretch,
                                    //   children: [
                                    //     Center(
                                    //       child: RichText(
                                    //         text: TextSpan(
                                    //           style: const TextStyle(
                                    //               fontSize: 13, color: Colors.black),
                                    //           children: <TextSpan>[
                                    //             const TextSpan(
                                    //                 text: 'Total Amount:   ',
                                    //                 style:
                                    //                     TextStyle(fontWeight: FontWeight.bold)),
                                    //             TextSpan(
                                    //                 // text: '₹ ${data.totalFaire ?? "0"}',
                                    //                 // text: '₹ ${((data.onlinePayment ?? 0) + (data.offlinePayment ?? 0)).toString()}',
                                    //                 text:
                                    //                     '₹ ${((double.tryParse(data.driverComission ?? '0') ?? 0.0) + (double.tryParse(data.offlinePayment ?? '0') ?? 0.0)).toString()}',
                                    //                 style: const TextStyle(
                                    //                     fontSize: 16,
                                    //                     fontWeight: FontWeight.bold,
                                    //                     color: Color.fromRGBO(69, 177, 41, 1))),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     SizedBox(height: size.height * 0.01),
                                    //     Center(
                                    //       child: RichText(
                                    //         text: TextSpan(
                                    //           style: const TextStyle(
                                    //               fontSize: 13, color: Colors.black),
                                    //           children: <TextSpan>[
                                    //             const TextSpan(
                                    //                 text: 'Driver Earning:   ',
                                    //                 style:
                                    //                     TextStyle(fontWeight: FontWeight.bold)),
                                    //             TextSpan(
                                    //                 text: '₹ ${data.offlinePayment ?? "0"}',
                                    //                 style: const TextStyle(
                                    //                     fontSize: 16,
                                    //                     fontWeight: FontWeight.bold,
                                    //                     color: Color.fromRGBO(69, 177, 41, 1))),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(height: size.height * 0.02),
                                    // TextButton(
                                    //   style: TextButton.styleFrom(
                                    //     backgroundColor: Color(0xFFFFB900),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.only(
                                    //         topLeft: Radius.circular(0),
                                    //         topRight: Radius.circular(0),
                                    //         bottomLeft: Radius.circular(6),
                                    //         bottomRight: Radius.circular(6),
                                    //       ),
                                    //     ),
                                    //     minimumSize: Size(double.infinity, 45),
                                    //   ),
                                    //   onPressed: () async {
                                    //     bool? bankInfoStatus =
                                    //         await NetworkService().checkBankInfo();
                                    //     if (bankInfoStatus == true) {
                                    //       Get.to(() => DetailPage(
                                    //             data: data,
                                    //             // totalDistance: totalDistance.toStringAsFixed(2),
                                    //           ));
                                    //     } else {
                                    //       Fluttertoast.showToast(
                                    //         msg: 'Please add the Account Details!',
                                    //         gravity: ToastGravity.CENTER,
                                    //         backgroundColor: Colors.red,
                                    //         textColor: Colors.white,
                                    //       );
                                    //     }
                                    //   },
                                    //   child: Center(
                                    //     child: Row(
                                    //       mainAxisSize: MainAxisSize.min,
                                    //       children: [
                                    //         Text(
                                    //           'Continue to Payment',
                                    //           style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 16,
                                    //             fontFamily: 'Poppins',
                                    //             fontWeight: FontWeight.w600,
                                    //           ),
                                    //         ),
                                    //         Icon(
                                    //           Icons.arrow_forward,
                                    //           color: Colors.white,
                                    //           size: 24,
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount:
                  //     4,
                  //     itemBuilder: (context, index) {
                  //
                  //       return Padding(
                  //         padding: const EdgeInsets.all(15),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             // Container with Date and Time Pickers
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                   color: const Color.fromRGBO(242, 242, 242, 1),
                  //                   borderRadius: BorderRadius.circular(6)),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
                  //                     child: Row(
                  //                       children: [
                  //                         Image.asset('assets/images/calender.png', scale: 5),
                  //                         SizedBox(width: size.width * 0.02),
                  //                         InkWell(
                  //                           // onTap: () => _selectDate(cont ext), // Pick the date
                  //                           child: Text(
                  //                             "12/23/33",
                  //                             style: const TextStyle(
                  //                                 fontSize: 12, fontWeight: FontWeight.w500),
                  //                           ),
                  //                         ),
                  //                         const Spacer(),
                  //                         // SizedBox(width: size.width * 0.350),
                  //                         Text('ID : 3432',
                  //                             style: const TextStyle(
                  //                                 fontSize: 12, fontWeight: FontWeight.w500)),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: size.height * 0.005),
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(left: 7, right: 7),
                  //                     child: Row(
                  //                       children: [
                  //                         Image.asset('assets/images/clock.png', scale: 5),
                  //                         SizedBox(width: size.width * 0.02),
                  //                         InkWell(
                  //                           // onTap: () => _selectTime(context), // Pick the time
                  //                           child: Text(
                  //                             "324",
                  //                             //   data.pickUpTime.toString(),
                  //                             style: const TextStyle(
                  //                                 fontSize: 12, fontWeight: FontWeight.w500),
                  //                           ),
                  //                         ),
                  //                         const Spacer(),
                  //                         Text("tttt",
                  //                             //data.subTypeLabel.toString(),
                  //                             style: const TextStyle(
                  //                                 fontSize: 14, fontWeight: FontWeight.bold)),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   const Divider(
                  //                       thickness: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(left: 7, right: 7),
                  //                     child: Row(
                  //                       mainAxisAlignment: MainAxisAlignment.start,
                  //                       children: [
                  //                         Expanded(
                  //                           child: Column(
                  //                             crossAxisAlignment: CrossAxisAlignment.start,
                  //                             children: [
                  //                               SizedBox(
                  //                                 width: size.width * 0.87,
                  //                                 child: Row(
                  //                                   mainAxisSize: MainAxisSize.min,
                  //                                   children: [
                  //                                     // if (pickCities.length == 1)
                  //                                     Row(
                  //                                       mainAxisSize: MainAxisSize.min,
                  //                                       children: [
                  //                                         Container(
                  //                                           width: size.width * 0.035,
                  //                                           height: size.height * 0.017,
                  //                                           decoration: BoxDecoration(
                  //                                             color: const Color.fromRGBO(
                  //                                                 212, 119, 22, 1),
                  //                                             borderRadius:
                  //                                             BorderRadius.circular(30),
                  //                                           ),
                  //                                         ),
                  //                                         SizedBox(width: size.width * 0.02),
                  //                                         SizedBox(
                  //                                           width: size.width * 0.6,
                  //                                           child: Text(
                  //                                             "ttt22",
                  //                                             //  pickCities.first,
                  //                                             style: TextStyle(
                  //                                               fontSize: size.width * 0.035,
                  //                                               fontFamily: 'Poppins',
                  //                                               fontWeight: FontWeight.w600,
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                       ],
                  //                                     ),
                  //
                  //                                     Container(
                  //                                       // height: (pickCities.length * 30).toDouble(),
                  //                                       width: size.width * 0.7,
                  //                                       child: ListView.builder(
                  //                                         shrinkWrap: true,
                  //                                         itemCount: 2,
                  //                                         physics: NeverScrollableScrollPhysics(),
                  //                                         itemBuilder: (context, index) {
                  //                                           return Column(
                  //                                             mainAxisAlignment:
                  //                                             MainAxisAlignment.start,
                  //                                             crossAxisAlignment:
                  //                                             CrossAxisAlignment.start,
                  //                                             children: [
                  //                                               Row(
                  //                                                 mainAxisSize: MainAxisSize.min,
                  //                                                 children: [
                  //                                                   Container(
                  //                                                     width: size.width * 0.035,
                  //                                                     height: size.height * 0.017,
                  //                                                     decoration: BoxDecoration(
                  //                                                       color: index == 0
                  //                                                           ? const Color
                  //                                                           .fromRGBO(
                  //                                                           212, 119, 22, 1)
                  //                                                           : Colors.green,
                  //                                                       borderRadius:
                  //                                                       BorderRadius.circular(
                  //                                                           30),
                  //                                                     ),
                  //                                                   ),
                  //                                                   SizedBox(
                  //                                                       width: size.width * 0.02),
                  //                                                   SizedBox(
                  //                                                     width: size.width * 0.55,
                  //                                                     child: Text(
                  //                                                       "delha",
                  //                                                       //   pickCities[index],
                  //                                                       style: TextStyle(
                  //                                                         fontSize:
                  //                                                         size.width * 0.035,
                  //                                                         fontFamily: 'Poppins',
                  //                                                         fontWeight:
                  //                                                         FontWeight.w600,
                  //                                                       ),
                  //                                                     ),
                  //                                                   ),
                  //                                                 ],
                  //                                               ),
                  //                                               SizedBox(
                  //                                                   height: size.height * 0.01),
                  //                                             ],
                  //                                           );
                  //                                         },
                  //                                       ),
                  //                                     ),
                  //                                     const Spacer(),
                  //                                     Column(
                  //                                       children: [
                  //                                         // if (data.status == '3')
                  //                                         Text("Cancelled",
                  //                                             style: TextStyle(
                  //                                                 fontSize: size.width * 0.04,
                  //                                                 fontWeight: FontWeight.w500,
                  //                                                 color: Colors.red)),
                  //                                         // if (data.status == '2')
                  //                                         Text("Completed",
                  //                                             style: TextStyle(
                  //                                                 fontSize: size.width * 0.03,
                  //                                                 fontWeight: FontWeight.w500,
                  //                                                 color: Colors.green)),
                  //                                         Row(
                  //                                           children: [
                  //                                             // if (data.driver_number!.isNotEmpty && data.driver_number != null)
                  //                                             GestureDetector(
                  //                                                 onTap: () {
                  //                                                   print('tapped');
                  //                                                   // HelperFunctions.makePhoneCall(
                  //                                                   //     context,
                  //                                                   //     data.driver_number ?? '');
                  //                                                 },
                  //                                                 child: Image.asset(
                  //                                                     'assets/images/call_1.png',
                  //                                                     scale: 3)),
                  //                                             SizedBox(width: size.width * 0.03),
                  //                                             GestureDetector(
                  //                                               onTap: () async {
                  //                                                 // await HelperFunctions
                  //                                                 //     .shareMessage(
                  //                                                 //   data.orderId ?? 'N/A',
                  //                                                 //   data.pickUpDate ?? 'N/A',
                  //                                                 //   pickCities.isNotEmpty
                  //                                                 //       ? pickCities.toString()
                  //                                                 //       : 'N/A',
                  //                                                 //   dropCities.isNotEmpty
                  //                                                 //       ? dropCities.toString()
                  //                                                 //       : 'N/A',
                  //                                                 //   data.car?.name ?? 'N/A',
                  //                                                 //   // Vehicle
                  //                                                 //   data.subTypeLabel ?? 'N/A',
                  //                                                 //   data.offlinePayment ?? 'N/A',
                  //                                                 //   data.driverComission ?? 'N/A',
                  //                                                 //   (data.addOnService != null &&
                  //                                                 //           data.addOnService!
                  //                                                 //               .isNotEmpty)
                  //                                                 //       ? "With carrier"
                  //                                                 //       : "N/A",
                  //                                                 //   // Extra Requirements
                  //                                                 //   // 'N/A',
                  //                                                 //   data.driver_number ?? 'N/A',
                  //                                                 // );
                  //                                               },
                  //                                               child: Image.asset(
                  //                                                   'assets/images/share.png',
                  //                                                   scale: 3),
                  //                                             ),
                  //                                           ],
                  //                                         ),
                  //                                       ],
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                               // SizedBox(height: size.height * 0.005),
                  //                               // Container(
                  //                               //   padding:
                  //                               //   EdgeInsets.only(left: size.width * 0.015),
                  //                               //   height: size.height * 0.03,
                  //                               //   child:
                  //                               //   CustomPaint(painter: DashedLinePainter()),
                  //                               // ),
                  //                               // SizedBox(height: size.height * 0.005),
                  //                               //  if (data.typeLabel != 'Local')
                  //                               Row(
                  //                                 mainAxisAlignment: MainAxisAlignment.start,
                  //                                 children: [
                  //                                   //  if (dropCities.length == 1)
                  //                                   Row(
                  //                                     mainAxisSize: MainAxisSize.min,
                  //                                     children: [
                  //                                       Container(
                  //                                         width: size.width * 0.035,
                  //                                         height: size.height * 0.017,
                  //                                         decoration: BoxDecoration(
                  //                                           color: Color(0xFFC51C1C),
                  //                                           borderRadius:
                  //                                           BorderRadius.circular(30),
                  //                                         ),
                  //                                       ),
                  //                                       SizedBox(width: size.width * 0.02),
                  //                                       SizedBox(
                  //                                         width: size.width * 0.6,
                  //                                         child: Text(
                  //                                           "noida vv",
                  //                                           // dropCities.first,
                  //                                           style: TextStyle(
                  //                                             fontSize: size.width * 0.035,
                  //                                             fontFamily: 'Poppins',
                  //                                             fontWeight: FontWeight.w600,
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     ],
                  //                                   ),
                  //                                   //   else
                  //                                   Container(
                  //                                     // height: (dropCities.length * 25).toDouble(),
                  //                                     width: size.width * 0.7,
                  //                                     child: ListView.builder(
                  //                                       shrinkWrap: true,
                  //                                       physics: NeverScrollableScrollPhysics(),
                  //                                       itemCount: 2,
                  //                                       itemBuilder: (context, index) {
                  //                                         return Column(
                  //                                           mainAxisAlignment:
                  //                                           MainAxisAlignment.start,
                  //                                           crossAxisAlignment:
                  //                                           CrossAxisAlignment.start,
                  //                                           children: [
                  //                                             Row(
                  //                                               mainAxisSize: MainAxisSize.min,
                  //                                               children: [
                  //                                                 Container(
                  //                                                   width: size.width * 0.035,
                  //                                                   height: size.height * 0.017,
                  //                                                   decoration: BoxDecoration(
                  //                                                     color: Colors.green,
                  //                                                     // color: index ==
                  //                                                     //         dropCities
                  //                                                     //                 .length -
                  //                                                     //             1
                  //                                                     //     ? Color(0xFFC51C1C)
                  //                                                     //     : Colors.green,
                  //                                                     borderRadius:
                  //                                                     BorderRadius.circular(
                  //                                                         30),
                  //                                                   ),
                  //                                                 ),
                  //                                                 SizedBox(
                  //                                                     width: size.width * 0.02),
                  //                                                 SizedBox(
                  //                                                   width: size.width * 0.55,
                  //                                                   child: Text(
                  //                                                     "mubai",
                  //                                                     //   dropCities[index],
                  //                                                     style: TextStyle(
                  //                                                       fontSize:
                  //                                                       size.width * 0.035,
                  //                                                       fontFamily: 'Poppins',
                  //                                                       fontWeight:
                  //                                                       FontWeight.w600,
                  //                                                     ),
                  //                                                   ),
                  //                                                 ),
                  //                                               ],
                  //                                             ),
                  //                                             SizedBox(
                  //                                                 height: size.height * 0.01),
                  //                                           ],
                  //                                         );
                  //                                       },
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               )
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   //   if (data.destination_date!.isNotEmpty)
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(top: 5, left: 7, right: 7),
                  //                     child: Column(
                  //                       children: [
                  //                         Row(
                  //                           children: [
                  //                             Text(
                  //                               'End Date: ',
                  //                               style: const TextStyle(
                  //                                   fontSize: 12, fontWeight: FontWeight.w500),
                  //                             ),
                  //                             Image.asset('assets/images/calender.png', scale: 5),
                  //                             SizedBox(width: size.width * 0.02),
                  //                             Text(
                  //                               "00/99",
                  //                               // '${destD ?? ''}',
                  //                               style: const TextStyle(
                  //                                   fontSize: 12, fontWeight: FontWeight.w500),
                  //                             ),
                  //                             SizedBox(width: size.width * 0.02),
                  //                             Image.asset('assets/images/clock.png', scale: 5),
                  //                             SizedBox(width: size.width * 0.01),
                  //                             Text(
                  //                               '11:59 PM',
                  //                               style: const TextStyle(
                  //                                   fontSize: 12, fontWeight: FontWeight.w500),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: const EdgeInsets.all(7),
                  //                     child: Container(
                  //                       width: size.width *
                  //                           0.9, // Adjust the container width as needed
                  //                       height: size.height *
                  //                           0.08, // Adjust the container height as needed
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(6),
                  //                         border: Border.all(
                  //                             color: Colors.white,
                  //                             width: 2), // Outer border for entire container
                  //                       ),
                  //                       child: Row(
                  //                         crossAxisAlignment:
                  //                         CrossAxisAlignment.stretch, // Ensure equal height
                  //                         children: [
                  //                           // First part
                  //                           Expanded(
                  //                             child: Container(
                  //                               decoration: BoxDecoration(
                  //                                 borderRadius: const BorderRadius.only(
                  //                                     topLeft: Radius.circular(6),
                  //                                     bottomLeft: Radius.circular(6)),
                  //                                 color: const Color.fromRGBO(225, 242, 255, 1),
                  //                                 border:
                  //                                 Border.all(color: Colors.white, width: 1.5),
                  //                               ),
                  //                               child: Column(
                  //                                 mainAxisAlignment: MainAxisAlignment.center,
                  //                                 children: [
                  //                                   Text(
                  //                                     "Parking",
                  //                                     style: TextStyle(
                  //                                         fontSize: size.width * 0.035,
                  //                                         fontWeight: FontWeight.w500),
                  //                                   ),
                  //                                   SizedBox(height: size.height * 0.01),
                  //                                   Text(
                  //                                     // data.carCategory?.parking ?? "",
                  //                                     "Extra",
                  //                                     style: const TextStyle(
                  //                                         fontSize: 10,
                  //                                         fontWeight: FontWeight.w400),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //                           // Second part
                  //                           Expanded(
                  //                             child: Container(
                  //                               decoration: BoxDecoration(
                  //                                 color: const Color.fromRGBO(225, 242, 255, 1),
                  //                                 border: Border.all(
                  //                                     color: Colors.white,
                  //                                     width: 1.5), // Border for the second part
                  //                               ),
                  //                               child: Column(
                  //                                 mainAxisAlignment: MainAxisAlignment.center,
                  //                                 children: [
                  //                                   Text(
                  //                                     "Toll",
                  //                                     style: TextStyle(
                  //                                         fontSize: size.width * 0.035,
                  //                                         fontWeight: FontWeight.w500),
                  //                                   ),
                  //                                   SizedBox(height: size.height * 0.01),
                  //                                   Text(
                  //                                     //data.toll ?? "",
                  //                                     "Included",
                  //                                     style: const TextStyle(
                  //                                         fontSize: 10,
                  //                                         fontWeight: FontWeight.w400),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //                           // Third part
                  //                           Expanded(
                  //                             child: Container(
                  //                               decoration: BoxDecoration(
                  //                                 borderRadius: const BorderRadius.only(
                  //                                     topRight: Radius.circular(6),
                  //                                     bottomRight: Radius.circular(6)),
                  //                                 color: const Color.fromRGBO(225, 242, 255, 1),
                  //                                 border: Border.all(
                  //                                     color: Colors.white,
                  //                                     width: 1.5), // Border for the third part
                  //                               ),
                  //                               child: Column(
                  //                                 mainAxisAlignment: MainAxisAlignment.center,
                  //                                 children: [
                  //                                   Text(
                  //                                     "Tax",
                  //                                     style: TextStyle(
                  //                                         fontSize: size.width * 0.035,
                  //                                         fontWeight: FontWeight.w500),
                  //                                   ),
                  //                                   SizedBox(height: size.height * 0.01),
                  //                                   Text(
                  //                                     "6767",
                  //                                     //data.tax ?? "",
                  //                                     // "Included",
                  //                                     style: const TextStyle(
                  //                                         fontSize: 10,
                  //                                         fontWeight: FontWeight.w400),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: const EdgeInsets.all(7),
                  //                     child: Row(
                  //                       children: [
                  //                         Container(
                  //                           width: size.width * 0.008,
                  //                           height: size.height * 0.004,
                  //                           decoration: BoxDecoration(
                  //                               color: const Color.fromRGBO(255, 0, 0, 1),
                  //                               borderRadius: BorderRadius.circular(35)),
                  //                         ),
                  //                         SizedBox(width: size.width * 0.02),
                  //                         Expanded(
                  //                           child: Text(
                  //                             "766 mm",
                  //                             // (parseAddOnService(data.addOnService!).isNotEmpty
                  //                             //         ? "There Should be carrier | "
                  //                             //         : "") +
                  //                             //     (data.remark ?? ''),
                  //                             style: TextStyle(
                  //                               fontSize: 14,
                  //                               fontWeight: FontWeight.w500,
                  //                               color: Color.fromRGBO(255, 0, 0, 1),
                  //                             ),
                  //                           ),
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //                     children: [
                  //                       //   if (data.typeLabel != 'Local')
                  //                       Column(
                  //                         children: [
                  //                           Text(
                  //                             "7676",
                  //                             // data.include_km != null
                  //                             //     ? (data.include_km!.endsWith('km')
                  //                             //         ? data.include_km!
                  //                             //         : '${data.include_km} km')
                  //                             //     : 'N/A',
                  //                             style: const TextStyle(
                  //                               fontSize: 17,
                  //                               fontWeight: FontWeight.w500,
                  //                               color: Color.fromRGBO(46, 46, 46, 0.6),
                  //                             ),
                  //                           ),
                  //                           const Text(
                  //                             "Total KM",
                  //                             style: TextStyle(
                  //                               fontSize: 10,
                  //                               fontWeight: FontWeight.w500,
                  //                               color: Colors.black,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       //if (data.typeLabel == 'Local')
                  //                       Column(
                  //                         children: [
                  //                           Text(
                  //                             // totalDistanceRe.toString(),
                  //                             //   data.include_km??'N/A',
                  //                               "34/44",
                  //
                  //                               //   data.timeScheduleData?.time ?? 'N/A',
                  //                               style: const TextStyle(
                  //                                   fontSize: 17,
                  //                                   fontWeight: FontWeight.w500,
                  //                                   color: Color.fromRGBO(46, 46, 46, 0.6))),
                  //                           const Text("Total KM",
                  //                               style: TextStyle(
                  //                                   fontSize: 10,
                  //                                   fontWeight: FontWeight.w500,
                  //                                   color: Colors.black)),
                  //                         ],
                  //                       ),
                  //                       Column(
                  //                         children: [
                  //                           Text("55km",
                  //                               //'₹${data.extra_fair_perKm ?? 'N/A'}/km',
                  //                               style: const TextStyle(
                  //                                   fontSize: 17,
                  //                                   fontWeight: FontWeight.w500,
                  //                                   color: Color.fromRGBO(46, 46, 46, 0.6))),
                  //                           const Text("Extra Per KM",
                  //                               style: TextStyle(
                  //                                   fontSize: 10,
                  //                                   fontWeight: FontWeight.w500,
                  //                                   color: Colors.black)),
                  //                         ],
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   SizedBox(
                  //                     height: size.width * 0.02,
                  //                   ),
                  //                   Padding(
                  //                     padding: const EdgeInsets.all(7.0),
                  //                     child: Row(
                  //                       mainAxisAlignment: MainAxisAlignment.start,
                  //                       children: [
                  //                         // Container(
                  //                         //   width: size.width * 0.18,
                  //                         //   height: size.height * 0.037,
                  //                         //   decoration: ShapeDecoration(
                  //                         //     shape: RoundedRectangleBorder(
                  //                         //       side: BorderSide(
                  //                         //         width: 1,
                  //                         //         color: data.fuel_type == "0"
                  //                         //             ? Color(0xFFC51C1C) // Red for "0"
                  //                         //             : data.fuel_type == "1"
                  //                         //                 ? Color(0xFF45B129) // Green for "1"
                  //                         //                 : Colors
                  //                         //                     .yellow, // Yellow for any other value
                  //                         //       ),
                  //                         //       borderRadius: BorderRadius.circular(8),
                  //                         //     ),
                  //                         //   ),
                  //                         //   child: Center(
                  //                         //     child: Text(
                  //                         //       data.fuel_type == "0"
                  //                         //           ? 'Diesel'
                  //                         //           : data.fuel_type == "CNG"
                  //                         //               ? 'CNG'
                  //                         //               : 'None',
                  //                         //       textAlign: TextAlign.center,
                  //                         //       style: TextStyle(
                  //                         //         color: data.fuel_type == "0"
                  //                         //             ? Color(0xFFC51C1C) // Red for "0"
                  //                         //             : data.fuel_type == "1"
                  //                         //                 ? Color(0xFF45B129) // Green for "1"
                  //                         //                 : Colors.yellow,
                  //                         //         // Yellow for any other value
                  //                         //         fontSize: 10,
                  //                         //         fontFamily: 'Poppins',
                  //                         //         fontWeight: FontWeight.w600,
                  //                         //       ),
                  //                         //     ),
                  //                         //   ),
                  //                         // ),
                  //                         Container(
                  //                           width: size.width * 0.18,
                  //                           height: size.height * 0.037,
                  //                           decoration: ShapeDecoration(
                  //                             shape: RoundedRectangleBorder(
                  //                               side: BorderSide(
                  //                                 width: 1,
                  //                                 color: const Color(0xFF45B129),
                  //                               ),
                  //                               borderRadius: BorderRadius.circular(8),
                  //                             ),
                  //                           ),
                  //                           child: Center(
                  //                             child: Text(
                  //                               'CAB',
                  //                               textAlign: TextAlign.center,
                  //                               style: TextStyle(
                  //                                 color: const Color(0xFF45B129),
                  //                                 fontSize: 10,
                  //                                 fontFamily: 'Poppins',
                  //                                 fontWeight: FontWeight.w600,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           width: 10,
                  //                         ),
                  //                         Text("motorala",
                  //                             //"${data.carCategory?.name ?? "N/A"}",
                  //                             style: TextStyle(
                  //                                 fontSize: size.width * 0.03,
                  //                                 fontWeight: FontWeight.w400,
                  //                                 color: Color.fromRGBO(0, 0, 0, 0.5))),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.stretch,
                  //                     children: [
                  //                       Center(
                  //                         child: RichText(
                  //                           text: TextSpan(
                  //                             style: const TextStyle(
                  //                                 fontSize: 13, color: Colors.black),
                  //                             children: <TextSpan>[
                  //                               const TextSpan(
                  //                                   text: 'Total Amount:   ',
                  //                                   style: TextStyle(fontWeight: FontWeight.bold)),
                  //                               TextSpan(
                  //                                   text:
                  //                                   '₹ 44',
                  //                                   //todo made the value round figure
                  //                                   // text: '₹ ${data.totalFaire ?? "0"}',
                  //                                   style: const TextStyle(
                  //                                       fontSize: 16,
                  //                                       fontWeight: FontWeight.bold,
                  //                                       color: Color.fromRGBO(69, 177, 41, 1))),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       // SizedBox(height: size.height * 0.01),
                  //                       // Center(
                  //                       //   child: RichText(
                  //                       //     text: TextSpan(
                  //                       //       style: const TextStyle(
                  //                       //           fontSize: 13, color: Colors.black),
                  //                       //       children: <TextSpan>[
                  //                       //         const TextSpan(
                  //                       //             text: 'Already Paid:   ',
                  //                       //             style: TextStyle(
                  //                       //                 fontWeight: FontWeight.bold)),
                  //                       //         TextSpan(
                  //                       //             text: '₹ ${data.onlinePayment ?? "0"}',
                  //                       //             style: const TextStyle(
                  //                       //                 fontWeight: FontWeight.normal,
                  //                       //                 color:
                  //                       //                     Color.fromRGBO(69, 177, 41, 1))),
                  //                       //       ],
                  //                       //     ),
                  //                       //   ),
                  //                       // ),
                  //                       SizedBox(height: size.height * 0.01),
                  //                       Center(
                  //                         child: RichText(
                  //                           text: TextSpan(
                  //                             style: const TextStyle(
                  //                                 fontSize: 13, color: Colors.black),
                  //                             children: <TextSpan>[
                  //                               const TextSpan(
                  //                                   text: 'Driver Earning:   ',
                  //                                   style: TextStyle(fontWeight: FontWeight.bold)),
                  //                               TextSpan(
                  //                                   text: '₹  0',
                  //                                   style: const TextStyle(
                  //                                       fontSize: 16,
                  //                                       fontWeight: FontWeight.bold,
                  //                                       color: Color.fromRGBO(69, 177, 41, 1))),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   SizedBox(height: size.height * 0.04),
                  //                   Center(
                  //                     child: Row(
                  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                       children: [
                  //                         //if (data.status == '1')
                  //                         Expanded(
                  //                           child: Padding(
                  //                             padding: const EdgeInsets.symmetric(
                  //                                 horizontal: 4.0, vertical: 4.0),
                  //                             child: GestureDetector(
                  //                               onTap: () {
                  //                                 showDialog(
                  //                                   context: context,
                  //                                   builder: (BuildContext context) {
                  //                                     return CancelBookingDialog(
                  //                                       bookingId: "7876",
                  //                                     );
                  //                                   },
                  //                                 );
                  //                               },
                  //                               child: Container(
                  //                                 height: size.height * 0.06,
                  //                                 decoration: BoxDecoration(
                  //                                     color: const Color.fromRGBO(255, 0, 0, 1),
                  //                                     borderRadius: BorderRadius.circular(6)),
                  //                                 child: Center(
                  //                                   child: Text("Cancel",
                  //                                       style: TextStyle(
                  //                                           fontSize: size.width * 0.04,
                  //                                           fontWeight: FontWeight.w500,
                  //                                           color: Colors.white)),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Expanded(
                  //                           child: Padding(
                  //                             padding: const EdgeInsets.symmetric(
                  //                                 horizontal: 4.0, vertical: 4.0),
                  //                             child: GestureDetector(
                  //                               onTap: () {
                  //                                 //   Get.to(() => const ChatListingScreen());
                  //                                 // Get.to(() => ChatDeatils(
                  //                                 //   data: data,
                  //                                 // ));todo use this for Edit Commision chat screen
                  //                               },
                  //                               child: Container(
                  //                                 height: size.height * 0.06,
                  //                                 decoration: BoxDecoration(
                  //                                     color: const Color.fromRGBO(69, 177, 41, 1),
                  //                                     borderRadius: BorderRadius.circular(6)),
                  //                                 child: Center(
                  //                                   child: Text("Chat",
                  //                                       style: TextStyle(
                  //                                           fontSize: size.width * 0.04,
                  //                                           fontWeight: FontWeight.w500,
                  //                                           color: Colors.white)),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         // if (HelperFunctions.isPickupTime(
                  //                         //         data.pickUpDate, data.pickUpTime) &&
                  //                         //     data.assign_booking_status == '0')
                  //                         Expanded(
                  //                           child: Padding(
                  //                             padding: const EdgeInsets.symmetric(
                  //                                 horizontal: 4.0, vertical: 4.0),
                  //                             child: GestureDetector(
                  //                               // onTap: () async {
                  //                               //   print("212113");
                  //                               //   print(data.driver_number);
                  //                               //   if (data.driver_number != null &&
                  //                               //       data.driver_number!.isNotEmpty) {
                  //                               //     await controller.pickUpBookingOrder(
                  //                               //       bookingId: data.id,
                  //                               //       onDialogShow: (context, bookingId) {
                  //                               //         if (mounted) {
                  //                               //           _showOtpDialog(context, bookingId);
                  //                               //         }
                  //                               //       },
                  //                               //     );
                  //                               //     print(controller
                  //                               //         .pickUpBookingModel.value.status);
                  //                               //   } else {
                  //                               //     final result =
                  //                               //         await NetworkService().verifyStartRideOtp(
                  //                               //       bookingId: data.id.toString(),
                  //                               //     );
                  //                               //     print(result);
                  //                               //     print('fdhdh getHomeData();');
                  //                               //     await controller.getHomeData();
                  //                               //     if (result != null &&
                  //                               //         result['status'] == true) {
                  //                               //       ScaffoldMessenger.of(context).showSnackBar(
                  //                               //         SnackBar(
                  //                               //           content: Text(result['message']),
                  //                               //           duration: Duration(seconds: 2),
                  //                               //         ),
                  //                               //       );
                  //                               //     } else {
                  //                               //       ScaffoldMessenger.of(context).showSnackBar(
                  //                               //         SnackBar(
                  //                               //           content: Text(result?['message'] ??
                  //                               //               'An error occurred'),
                  //                               //           duration: Duration(seconds: 2),
                  //                               //         ),
                  //                               //       );
                  //                               //     }
                  //                               //   }
                  //                               // },
                  //                               child: Container(
                  //                                 height: size.height * 0.06,
                  //                                 decoration: BoxDecoration(
                  //                                     color: const Color.fromRGBO(255, 185, 0, 1),
                  //                                     borderRadius: BorderRadius.circular(6)),
                  //                                 child: Center(
                  //                                   child: Text("Pickup",
                  //                                       style: TextStyle(
                  //                                           fontSize: size.width * 0.04,
                  //                                           fontWeight: FontWeight.w500,
                  //                                           color: Colors.white)),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         //   if (data.assign_booking_status == '1') //started
                  //                         Expanded(
                  //                           child: Padding(
                  //                             padding: const EdgeInsets.symmetric(
                  //                                 horizontal: 4.0, vertical: 4.0),
                  //                             child: GestureDetector(
                  //                               // onTap: () async {
                  //                               //   bool? confirm =
                  //                               //       await _showConfirmationDialog(context);
                  //                               //   if (confirm == true) {
                  //                               //     final result = await NetworkService()
                  //                               //         .endRide(bookingId: data.id.toString());
                  //                               //     if (result != null &&
                  //                               //         result['status'] == true) {
                  //                               //       Fluttertoast.showToast(
                  //                               //           msg: "Ride Completed Successfully!");
                  //                               //       if (data.driver_number != null &&
                  //                               //           data.driver_number!.isNotEmpty) {
                  //                               //         final customerName = result['name'];
                  //                               //         Get.to(() => ReviewPage(
                  //                               //               // driverId: data.dr,
                  //                               //               bookingId: data.id.toString(),
                  //                               //             ));
                  //                               //       } else {
                  //                               //         await controller.getHomeData();
                  //                               //       }
                  //                               //     }
                  //                               //   } else {
                  //                               //     print("User  canceled the booking.");
                  //                               //   }
                  //                               // },
                  //                               child: Container(
                  //                                 height: size.height * 0.06,
                  //                                 decoration: BoxDecoration(
                  //                                   color: const Color(0xFF2D75CA),
                  //                                   borderRadius: BorderRadius.circular(6),
                  //                                 ),
                  //                                 child: Center(
                  //                                   child: Text(
                  //                                     "Complete Booking",
                  //                                     textAlign: TextAlign.center,
                  //                                     style: TextStyle(
                  //                                       fontSize: size.width * 0.04,
                  //                                       fontWeight: FontWeight.w500,
                  //                                       color: Colors.white,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         )
                  //                       ],
                  //                     ),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

}
