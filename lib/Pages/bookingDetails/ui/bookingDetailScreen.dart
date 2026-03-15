
import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';

import 'package:cab_taxi_app/Pages/bookingDetails/bloc/bookingDetailsEvent.dart';
import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:cab_taxi_app/app/router/navigation/routes.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import '../bloc/bookingDetailsBloc.dart';
import 'driverInfoCard.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingID;


  const BookingDetailScreen(
      {super.key, required this.bookingID});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  // late PaymentService _paymentService;

  @override
  void initState() {
    // _paymentService = PaymentService();
    super.initState();
    context.read<BookingDetailBloc>().add(GetBookingDetailEvent(context: context,bookingId: widget.bookingID));
  }

  @override
  void dispose() {
    // _paymentService.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final size = MediaQuery.of(context).size;



    String? destD = '';

    String pickUpDateStr = "1970-01-01 00:00:00";
    DateTime pickUpDate = DateFormat('yyyy-MM-dd').parse(pickUpDateStr);
    String formattedDate = DateFormat('d MMM yyyy').format(pickUpDate);
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
          children: [
            AppBAR(title: "Details"),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Column(
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
                                      Text('ID : 56',
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
                                              '12/2/2027',
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
                                              '10:30 AM',
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
                                                        "suriyawan",
                                                       // newBooking[index].pickupLocation,
                                                        maxLines: 1,
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
                                              Image.asset("assets/images/navLocation.png",scale: 2.5,),
                                              //  Icon(Icons.send,color: Colors.blue,)


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
                                                      "bhadohi",
                                                     // newBooking[index].destinationLocation,
                                                      maxLines: 1,
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
                                      // Image.network(newBooking[index].carImage,scale: 4,errorBuilder: (context, error, stackTrace) {
                                      //   return Image.asset("assets/images/carMO.png",scale: 4,);
                                      // },),
                                        Image.asset("assets/images/carMO.png",scale: 4,),
                                      SizedBox(width: 5,),
                                      Text(
                                        "category name",
                                       // newBooking[index].carCategoryName,
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
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'remark',
                                       // newBooking[index].remark??"N/A",
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
                                                  "899",
                                                  //"₹${newBooking[index].totalFare}",
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
                                        ),   SizedBox(width: 5,),
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
                                                  "899",
                                                 // "₹${newBooking[index].driverCommission}",
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
                                                  "89",
                                                 // "₹${newBooking[index].driverCommission}",
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      DriverInfoCard(
                        imagePath: 'https://img.freepik.com/premium-vector/blue-car-flat-style-illustration-isolated-white-background_108231-795.jpg?semt=ais_hybrid&w=740&q=80',
                        name: 'Sundar',
                        subtitle: 'Jaipur tour and travels',
                        rating: 5,
                        reviewCount: 1,
                      ),

                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                     Column(
                          children: [
                            // TextButton(
                            //   style: TextButton.styleFrom(
                            //     backgroundColor: Colors.green,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(6),
                            //     ),
                            //     minimumSize: Size(double.infinity, 50),
                            //   ),
                            //   onPressed: () async {
                            //     // await controller.createOrder(
                            //     //     amount: widget.data.driverComission
                            //     //         .toString());
                            //     //
                            //     // _startPayment(
                            //     //     price: widget.data.driverComission
                            //     //         .toString(),
                            //     //     orderId: controller
                            //     //         .orderCreateData.value.data
                            //     //         .toString(),
                            //     //     context: context);
                            //   },
                            //   child: Center(
                            //     child: Row(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         Text(
                            //           'Pay ₹ 32 Commission',
                            //           style: const TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 18,
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
                            // ),
                            SizedBox(height: 10,),


                          ],
                        )

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      bottomSheet:      Padding(
        padding: const EdgeInsets.all(15.0),
        child: CommonAppButton(text: "Chat", onPressed: (){
          Nav.push(context, Routes.chatListing);
       //   Get.to(() => const ChatListingScreen());
        }),
      ),


    );
  }


}
