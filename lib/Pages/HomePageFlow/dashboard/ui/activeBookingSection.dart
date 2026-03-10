import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bookingDetails/ui/bookingDetailScreen.dart';
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
                      itemCount:4,
                      itemBuilder: (context, index) {
                       // var newBookingData = newBooking[index];
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailScreen(bookingID: "676",),));

                            // Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailScreen(bookingID: newBooking[index].id,),));


                            //Fluttertoast.showToast(
                            //   msg: 'Please add the Account Details!',
                            //   gravity: ToastGravity.CENTER,
                            //   backgroundColor: Colors.red,
                            //   textColor: Colors.white,
                            // );
                          },
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
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'ID : 55',
                                                    // text: 'ID : ${newBookingData.orderId}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const TextSpan(
                                                    text: ' (Open)',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff45B129),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

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
                                                    "2026-02-19",
                                                   // newBookingData.pickUpDate.toString(),
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
                                                  child: Text("08:34",
                                                    // newBookingData.pickUpTime.toString(),

                                                    style: const TextStyle(
                                                        fontSize: 12, fontWeight: FontWeight.w500,color: Color(0xffF45858)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(
                                              "Round Trip",
                                               // ' ${newBookingData.subTypeLabel}',
                                                style: const TextStyle(
                                                    fontSize: 12, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                          thickness: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                                      SizedBox(
                                        width: size.width ,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
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
                                                      width: size.width * 0.4,
                                                      child: Text(
                                                        "Noida",
                                                       // newBookingData.pickUpLoc.toString(),
                                                        //     newBooking[index].pickupLocation,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),

                                                Container(
                                                  width: 165,
                                                  height: 30,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(),
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: 84,
                                                        top: 1,
                                                        child: Container(
                                                          width: 82,
                                                          height: 27,
                                                          clipBehavior: Clip.antiAlias,
                                                          decoration: ShapeDecoration(
                                                            color: const Color(0xFFFCB117),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topRight: Radius.circular(2000),
                                                                bottomRight: Radius.circular(2000),
                                                              ),
                                                            ),
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                left: 22,
                                                                top: 3,
                                                                child: Text(
                                                                  '₹ 20',
                                                                //  '₹ ${newBookingData.driverCommission}',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                left: 23,
                                                                top: 16,
                                                                child: Text(
                                                                  'Commission',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 5.50,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 1,
                                                        top: 1,
                                                        child: Container(
                                                          width: 82,
                                                          height: 27,
                                                          clipBehavior: Clip.antiAlias,
                                                          decoration: ShapeDecoration(
                                                            color: const Color(0xFFEFEFEF),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(2000),
                                                                bottomLeft: Radius.circular(2000),
                                                              ),
                                                            ),
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                left: 18,
                                                                top: 3,
                                                                child: Text(
                                                                  '₹ 100',
                                                                  //'₹ ${newBookingData.totalFaire}',
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 12,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                left: 22,
                                                                top: 16,
                                                                child: Text(
                                                                  'Total Amount',
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 5.50,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )



                                                // Icon(Icons.arrow_forward_ios_sharp)


                                              ],
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
                                                      child: Text("Delhi",
                                                        //newBookingData.destinationLoc.toString(),

                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize:12,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),


                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      //  if (data.destination_date!.isNotEmpty)

                                      // SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                                        child: Row(
                                          children: [
                                            Image.network("car image",scale: 4,errorBuilder: (context, error, stackTrace) {
                                              return Image.asset("assets/images/carMO.png",scale: 4,);
                                            },),
                                            //  Image.asset("assets/images/carMO.png",scale: 4,),
                                            SizedBox(width: 5,),
                                            SizedBox(
                                              width: size.width * 0.7,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Maruti Suzuki",
                                                   // newBookingData.carCategory!.name.toString(),
                                                    //newBooking[index].carCategoryName,
                                                    style: TextStyle(
                                                      color: Colors.black.withValues(alpha: 0.50),
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w500,
                                                    ),

                                                  ),

                                                  Icon(Icons.arrow_forward_ios_sharp,size: 22,color: Colors.black54,)
                                                ],
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
                                            SizedBox(
                                              width: 200,
                                              child: Text("I have not cash",
                                                //newBookingData.remark.toString(),

                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: const Color(0xFFF45858),
                                                  fontSize: 11,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 3,),

                                      ///Chat wala section with Icons
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        height: 45,
                                        margin: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xADEFEFEF),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/chatNew.png",scale: 3,),
                                            SizedBox(width: 10),   Text(
                                              "Chat",
                                              //"₹${newBooking[index].totalFare}",
                                              style: TextStyle(
                                                  fontSize: size.width * 0.035,
                                                  fontWeight: FontWeight.w500,color: Color(0xffFCB117)),
                                            ),


                                          ],
                                        ),
                                      ), Container(
                                        clipBehavior: Clip.antiAlias,
                                        height: 45,
                                        margin: EdgeInsets.symmetric(horizontal: 12,),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xADEFEFEF),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Image.asset("assets/images/chatNew.png",scale: 3,),
                                          Text(
                                              "Cancel Booking",
                                              //"₹${newBooking[index].totalFare}",
                                              style: TextStyle(
                                                  fontSize: size.width * 0.035,
                                                  fontWeight: FontWeight.w500,color: Color(0xffF45858)),
                                            ),


                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      ///Share with section with Icons


                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
//                 ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     // alignment:Alignment.centerRight,
//                     //itemCount: activeBooking.length,
//                     itemCount: 3,
//                     itemBuilder: (context, index) {
//                       // var newBookingData = controller
//                       //     .homeData.value.newBooking!.data![index];
//                       return GestureDetector(
//                         onTap: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailScreen(bookingID: "5",),));
//                         },
//
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 clipBehavior: Clip.antiAlias,
//                                 decoration: ShapeDecoration(
//                                   color: Colors.white,
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                                   shadows: [
//                                     BoxShadow(
//                                       color: Color(0x3F000000),
//                                       blurRadius: 2,
//                                       offset: Offset(0, 0),
//                                       spreadRadius: 0,
//                                     )
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
//                                       child: Row(
//                                         children: [
//                                           Text(
//                                             "ID:334",
//                                               //'ID : ${activeBooking[index].bookingId}',
//                                               style: const TextStyle(
//                                                   fontSize: 12, fontWeight: FontWeight.w500)),
//                                           // Text('654',
//                                           //     style: const TextStyle(
//                                           //         fontSize: 12, fontWeight: FontWeight.w500,color: Color(0xffFCB117))),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: size.height * 0.005),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 7, right: 7),
//                                       child: Row(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               InkWell(
//                                                 child: Text(
//                                                   "12/56",
//                                                  // activeBooking[index].pickupDate,
//                                                   style: const TextStyle(
//                                                       fontSize: 12, fontWeight: FontWeight.w500),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 5,
//                                               ),
//                                               Text(
//                                                 "@ ",
//                                                 style: const TextStyle(
//                                                     fontSize: 12, fontWeight: FontWeight.w500),
//                                               ),
//                                               InkWell(
//                                                 // onTap: () => _selectTime(context), // Pick the time
//                                                 child: Text(
//                                                   "yggh",
//                                                  // activeBooking[index].pickupTime,
//                                                   //data.pickUpTime.toString(),
//                                                   // selectedTime != null
//                                                   //     ? selectedTime!.format(context)
//                                                   //     : TimeOfDay.now().format(context),
//                                                   style: const TextStyle(
//                                                       fontSize: 12, fontWeight: FontWeight.w500,color: Color(0xffF45858)),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           const Spacer(),
//                                           Text(
//                                             //data.subTypeLabel.toString(),
//                                               'One Way Trip',
//                                               style: const TextStyle(
//                                                   fontSize: 14, fontWeight: FontWeight.bold)),
//                                         ],
//                                       ),
//                                     ),
//                                     const Divider(
//                                         thickness: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 7, right: 7),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: [
//                                           Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               SizedBox(
//                                                 width: size.width * 0.87,
//                                                 child: Row(
//                                                   mainAxisSize: MainAxisSize.min,
//                                                   children: [
//
//                                                     Row(
//                                                       mainAxisSize: MainAxisSize.min,
//                                                       children: [
//                                                         Container(
//                                                           width: size.width * 0.035,
//                                                           height: size.height * 0.017,
//                                                           decoration: BoxDecoration(
//                                                             color: const Color.fromRGBO(
//                                                                 212, 119, 22, 1),
//                                                             borderRadius:
//                                                             BorderRadius.circular(30),
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: size.width * 0.02),
//                                                         SizedBox(
//                                                           width: size.width * 0.6,
//                                                           child: Text(
//                                                             "hggg",
//                                                             //activeBooking[index].pickupLocation,
//                                                             style: TextStyle(
//                                                               fontSize: size.width * 0.035,
//                                                               fontFamily: 'Poppins',
//                                                               fontWeight: FontWeight.w600,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
// // Container(
//                                                     //   // height: (pickCities.length * 30).toDouble(),
//                                                     //   width: size.width * 0.7,
//                                                     //   child: ListView.builder(
//                                                     //     shrinkWrap: true,
//                                                     //     itemCount: 3,
//                                                     //     physics: NeverScrollableScrollPhysics(),
//                                                     //     itemBuilder: (context, index) {
//                                                     //       return Column(
//                                                     //         mainAxisAlignment:
//                                                     //         MainAxisAlignment.start,
//                                                     //         crossAxisAlignment:
//                                                     //         CrossAxisAlignment.start,
//                                                     //         children: [
//                                                     //           Row(
//                                                     //             mainAxisSize: MainAxisSize.min,
//                                                     //             children: [
//                                                     //               Container(
//                                                     //                 width: size.width * 0.035,
//                                                     //                 height: size.height * 0.017,
//                                                     //                 decoration: BoxDecoration(
//                                                     //                   color: index == 0
//                                                     //                       ? const Color
//                                                     //                       .fromRGBO(
//                                                     //                       212, 119, 22, 1)
//                                                     //                       : Colors.green,
//                                                     //                   borderRadius:
//                                                     //                   BorderRadius.circular(
//                                                     //                       30),
//                                                     //                 ),
//                                                     //               ),
//                                                     //               SizedBox(
//                                                     //                   width: size.width * 0.02),
//                                                     //               SizedBox(
//                                                     //                 width: size.width * 0.55,
//                                                     //                 child: Text(
//                                                     //                   "Merath",
//                                                     //                   style: TextStyle(
//                                                     //                     fontSize:
//                                                     //                     size.width * 0.035,
//                                                     //                     fontFamily: 'Poppins',
//                                                     //                     fontWeight:
//                                                     //                     FontWeight.w600,
//                                                     //                   ),
//                                                     //                 ),
//                                                     //               ),
//                                                     //             ],
//                                                     //           ),
//                                                     //
//                                                     //
//                                                     //           SizedBox(
//                                                     //               height: size.height * 0.01),
//                                                     //         ],
//                                                     //       );
//                                                     //     },
//                                                     //   ),
//                                                     // ),
//                                                     const Spacer(),
//                                                     Icon(Icons.arrow_forward_ios_sharp)
//
//
//                                                   ],
//                                                 ),
//                                               ),
//
//                                               //  if (data.typeLabel != 'Local')
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                 children: [
//                                                   //  if (dropCities.length == 1)
//                                                   Row(
//                                                     mainAxisSize: MainAxisSize.min,
//                                                     children: [
//                                                       Container(
//                                                         width: size.width * 0.035,
//                                                         height: size.height * 0.017,
//                                                         decoration: BoxDecoration(
//                                                           color: Color(0xFFC51C1C),
//                                                           borderRadius:
//                                                           BorderRadius.circular(30),
//                                                         ),
//                                                       ),
//                                                       SizedBox(width: size.width * 0.02),
//                                                       SizedBox(
//                                                         width: size.width * 0.6,
//                                                         child: Text(
//                                                           "jhhg",
//                                                          // activeBooking[index].destinationLocation ?? "N/A",
//                                                           style: TextStyle(
//                                                             fontSize: size.width * 0.035,
//                                                             fontFamily: 'Poppins',
//                                                             fontWeight: FontWeight.w600,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//
//
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     //  if (data.destination_date!.isNotEmpty)
//
//                                     // SizedBox(height: 10,),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 7.0),
//                                       child: Row(
//                                         children: [
//                                           // Image.network(activeBooking[index].carImage,scale: 4,errorBuilder: (context, error, stackTrace) {
//                                           //   return Image.asset("assets/images/carMO.png",scale: 4,);
//                                           // },),
//                                           //  Image.asset("assets/images/carMO.png",scale: 4,),
//                                           SizedBox(width: 5,),
//                                           Text(
//                                             "dsf",
//                                          //   activeBooking[index].carCategoryName ?? "N/A",
//                                             style: TextStyle(
//                                               color: Colors.black.withValues(alpha: 0.50),
//                                               fontSize: 12,
//                                               fontFamily: 'Poppins',
//                                               fontWeight: FontWeight.w500,
//                                             ),
//
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 7.0),
//                                       child: Row(
//                                         children: [
//                                           Text(
//                                             'Extra Requirement : ',
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 11,
//                                               fontFamily: 'Poppins',
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           Text(
//                                             "dsfsdnfnsdhn",
//                                             overflow: TextOverflow.ellipsis,
//                                          //   activeBooking[index].remark??"N/A",
//                                             style: TextStyle(
//                                               color: const Color(0xFFF45858),
//                                               fontSize: 11,
//                                               fontFamily: 'Poppins',
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 3,),
//                                     Padding(
//                                       padding: const EdgeInsets.all(7),
//                                       child: Container(
//                                         width: size.width *
//                                             0.9, // Adjust the container width as needed
//                                         height: size.height *
//                                             0.08, // Adjust the container height as needed
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(6),
//                                           border: Border.all(
//                                               color: Colors.white,
//                                               width: 2), // Outer border for entire container
//                                         ),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.stretch, // Ensure equal height
//                                           children: [
//                                             // First part
//                                             Expanded(
//                                               child: Container(
//                                                 clipBehavior: Clip.antiAlias,
//                                                 decoration: ShapeDecoration(
//                                                   color: const Color(0xADEFEFEF),
//                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                                                 ),
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       "Rs 43",
//                                                     //  "₹${activeBooking[index].totalFare}",
//                                                       style: TextStyle(
//                                                           fontSize: size.width * 0.035,
//                                                           fontWeight: FontWeight.w500),
//                                                     ),
//                                                     SizedBox(height: size.height * 0.01),
//                                                     Text(
//                                                       // data.carCategory?.parking ?? "",
//                                                       "Total Amount",
//                                                       style: const TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight: FontWeight.w400),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),  SizedBox(width: 5,),
//                                             // Second part
//                                             Expanded(
//                                               child: Container(
//                                                 clipBehavior: Clip.antiAlias,
//                                                 decoration: ShapeDecoration(
//                                                   color: const Color(0xADEFEFEF),
//                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                                                 ),
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       "Rs 43",
//                                                    //   "₹${activeBooking[index].driverCommission??""}",
//                                                       style: TextStyle(
//                                                           fontSize: size.width * 0.035,
//                                                           fontWeight: FontWeight.w500),
//                                                     ),
//                                                     SizedBox(height: size.height * 0.01),
//                                                     Text(
//                                                       "Driver’s Earning",
//                                                       //data.toll ?? "",
//                                                       style: const TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight: FontWeight.w400),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: 5,),
//                                             // Third part
//                                             Expanded(
//                                               child: Container(
//                                                 clipBehavior: Clip.antiAlias,
//                                                 decoration: ShapeDecoration(
//                                                   color: const Color(0xADEFEFEF),
//                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                                                 ),
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       "RS 89",
//                                                       //"₹${activeBooking[index].driverCommission??""}",
//                                                       style: TextStyle(
//                                                           fontSize: size.width * 0.035,
//                                                           fontWeight: FontWeight.w500),
//                                                     ),
//                                                     SizedBox(height: size.height * 0.01),
//                                                     Text(
//                                                       "Commission",
//                                                       //data.tax ?? "",
//                                                       style: const TextStyle(
//                                                           fontSize: 10,
//                                                           fontWeight: FontWeight.w400),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     // Padding(
//                                     //   padding: const EdgeInsets.all(7),
//                                     //   child: Row(
//                                     //     children: [
//                                     //       // Container(
//                                     //       //   width: size.width * 0.008,
//                                     //       //   height: size.height * 0.004,
//                                     //       //   decoration: BoxDecoration(
//                                     //       //       color: const Color.fromRGBO(255, 0, 0, 1),
//                                     //       //       borderRadius: BorderRadius.circular(35)),
//                                     //       // ),
//                                     //       // SizedBox(width: size.width * 0.02),
//                                     //       // Expanded(
//                                     //       //   child: Text(
//                                     //       //     (parseAddOnService(data.addOnService!).isNotEmpty
//                                     //       //             ? "There Should be carrier | "
//                                     //       //             : "") +
//                                     //       //         (data.remark ?? ''),
//                                     //       //     style: TextStyle(
//                                     //       //       fontSize: 14,
//                                     //       //       fontWeight: FontWeight.w500,
//                                     //       //       color: Color.fromRGBO(255, 0, 0, 1),
//                                     //       //     ),
//                                     //       //   ),
//                                     //       // )
//                                     //     ],
//                                     //   ),
//                                     // ),
//                                     // Row(
//                                     //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                     //   children: [
//                                     //     if (data.typeLabel != 'Local')
//                                     //       Column(
//                                     //         children: [
//                                     //           Text(
//                                     //             data.include_km != null
//                                     //                 ? (data.include_km!.endsWith('km')
//                                     //                     ? data.include_km!
//                                     //                     : '${data.include_km} km')
//                                     //                 : 'N/A',
//                                     //             style: const TextStyle(
//                                     //               fontSize: 17,
//                                     //               fontWeight: FontWeight.w500,
//                                     //               color: Color.fromRGBO(46, 46, 46, 0.6),
//                                     //             ),
//                                     //           ),
//                                     //           const Text(
//                                     //             "Total KM",
//                                     //             style: TextStyle(
//                                     //               fontSize: 10,
//                                     //               fontWeight: FontWeight.w500,
//                                     //               color: Colors.black,
//                                     //             ),
//                                     //           ),
//                                     //         ],
//                                     //       ),
//                                     //     if (data.typeLabel == 'Local')
//                                     //       Column(
//                                     //         children: [
//                                     //           Text(
//                                     //               // totalDistanceRe.toString(),
//                                     //               //   data.include_km??'N/A',
//                                     //
//                                     //               data.timeScheduleData?.time ?? 'N/A',
//                                     //               style: const TextStyle(
//                                     //                   fontSize: 17,
//                                     //                   fontWeight: FontWeight.w500,
//                                     //                   color: Color.fromRGBO(46, 46, 46, 0.6))),
//                                     //           const Text("Total KM",
//                                     //               style: TextStyle(
//                                     //                   fontSize: 10,
//                                     //                   fontWeight: FontWeight.w500,
//                                     //                   color: Colors.black)),
//                                     //         ],
//                                     //       ),
//                                     //     Column(
//                                     //       children: [
//                                     //         Text('₹${data.extra_fair_perKm ?? 'N/A'}/km',
//                                     //             style: const TextStyle(
//                                     //                 fontSize: 17,
//                                     //                 fontWeight: FontWeight.w500,
//                                     //                 color: Color.fromRGBO(46, 46, 46, 0.6))),
//                                     //         const Text("Extra Per KM",
//                                     //             style: TextStyle(
//                                     //                 fontSize: 10,
//                                     //                 fontWeight: FontWeight.w500,
//                                     //                 color: Colors.black)),
//                                     //       ],
//                                     //     ),
//                                     //   ],
//                                     // ),
//                                     // Padding(
//                                     //   padding: const EdgeInsets.all(7.0),
//                                     //   child: Row(
//                                     //     mainAxisAlignment: MainAxisAlignment.start,
//                                     //     children: [
//                                     //       Container(
//                                     //         width: size.width * 0.18,
//                                     //         height: size.height * 0.037,
//                                     //         decoration: ShapeDecoration(
//                                     //           shape: RoundedRectangleBorder(
//                                     //             side: BorderSide(
//                                     //               width: 1,
//                                     //               color: const Color(0xFF45B129),
//                                     //             ),
//                                     //             borderRadius: BorderRadius.circular(8),
//                                     //           ),
//                                     //         ),
//                                     //         child: Center(
//                                     //           child: Text(
//                                     //             'CAB',
//                                     //             textAlign: TextAlign.center,
//                                     //             style: TextStyle(
//                                     //               color: const Color(0xFF45B129),
//                                     //               fontSize: 10,
//                                     //               fontFamily: 'Poppins',
//                                     //               fontWeight: FontWeight.w600,
//                                     //             ),
//                                     //           ),
//                                     //         ),
//                                     //       ),
//                                     //       SizedBox(
//                                     //         width: 10,
//                                     //       ),
//                                     //       Text("${data.carCategory?.name ?? ""}",
//                                     //           style: TextStyle(
//                                     //               fontSize: size.width * 0.035,
//                                     //               fontWeight: FontWeight.w400,
//                                     //               color: Color.fromRGBO(0, 0, 0, 0.5))),
//                                     //     ],
//                                     //   ),
//                                     // ),
//                                     // Column(
//                                     //   crossAxisAlignment: CrossAxisAlignment.stretch,
//                                     //   children: [
//                                     //     Center(
//                                     //       child: RichText(
//                                     //         text: TextSpan(
//                                     //           style: const TextStyle(
//                                     //               fontSize: 13, color: Colors.black),
//                                     //           children: <TextSpan>[
//                                     //             const TextSpan(
//                                     //                 text: 'Total Amount:   ',
//                                     //                 style:
//                                     //                     TextStyle(fontWeight: FontWeight.bold)),
//                                     //             TextSpan(
//                                     //                 // text: '₹ ${data.totalFaire ?? "0"}',
//                                     //                 // text: '₹ ${((data.onlinePayment ?? 0) + (data.offlinePayment ?? 0)).toString()}',
//                                     //                 text:
//                                     //                     '₹ ${((double.tryParse(data.driverComission ?? '0') ?? 0.0) + (double.tryParse(data.offlinePayment ?? '0') ?? 0.0)).toString()}',
//                                     //                 style: const TextStyle(
//                                     //                     fontSize: 16,
//                                     //                     fontWeight: FontWeight.bold,
//                                     //                     color: Color.fromRGBO(69, 177, 41, 1))),
//                                     //           ],
//                                     //         ),
//                                     //       ),
//                                     //     ),
//                                     //     SizedBox(height: size.height * 0.01),
//                                     //     Center(
//                                     //       child: RichText(
//                                     //         text: TextSpan(
//                                     //           style: const TextStyle(
//                                     //               fontSize: 13, color: Colors.black),
//                                     //           children: <TextSpan>[
//                                     //             const TextSpan(
//                                     //                 text: 'Driver Earning:   ',
//                                     //                 style:
//                                     //                     TextStyle(fontWeight: FontWeight.bold)),
//                                     //             TextSpan(
//                                     //                 text: '₹ ${data.offlinePayment ?? "0"}',
//                                     //                 style: const TextStyle(
//                                     //                     fontSize: 16,
//                                     //                     fontWeight: FontWeight.bold,
//                                     //                     color: Color.fromRGBO(69, 177, 41, 1))),
//                                     //           ],
//                                     //         ),
//                                     //       ),
//                                     //     ),
//                                     //   ],
//                                     // ),
//                                     // SizedBox(height: size.height * 0.02),
//                                     // TextButton(
//                                     //   style: TextButton.styleFrom(
//                                     //     backgroundColor: Color(0xFFFFB900),
//                                     //     shape: RoundedRectangleBorder(
//                                     //       borderRadius: BorderRadius.only(
//                                     //         topLeft: Radius.circular(0),
//                                     //         topRight: Radius.circular(0),
//                                     //         bottomLeft: Radius.circular(6),
//                                     //         bottomRight: Radius.circular(6),
//                                     //       ),
//                                     //     ),
//                                     //     minimumSize: Size(double.infinity, 45),
//                                     //   ),
//                                     //   onPressed: () async {
//                                     //     bool? bankInfoStatus =
//                                     //         await NetworkService().checkBankInfo();
//                                     //     if (bankInfoStatus == true) {
//                                     //       Get.to(() => DetailPage(
//                                     //             data: data,
//                                     //             // totalDistance: totalDistance.toStringAsFixed(2),
//                                     //           ));
//                                     //     } else {
//                                     //       Fluttertoast.showToast(
//                                     //         msg: 'Please add the Account Details!',
//                                     //         gravity: ToastGravity.CENTER,
//                                     //         backgroundColor: Colors.red,
//                                     //         textColor: Colors.white,
//                                     //       );
//                                     //     }
//                                     //   },
//                                     //   child: Center(
//                                     //     child: Row(
//                                     //       mainAxisSize: MainAxisSize.min,
//                                     //       children: [
//                                     //         Text(
//                                     //           'Continue to Payment',
//                                     //           style: TextStyle(
//                                     //             color: Colors.white,
//                                     //             fontSize: 16,
//                                     //             fontFamily: 'Poppins',
//                                     //             fontWeight: FontWeight.w600,
//                                     //           ),
//                                     //         ),
//                                     //         Icon(
//                                     //           Icons.arrow_forward,
//                                     //           color: Colors.white,
//                                     //           size: 24,
//                                     //         ),
//                                     //       ],
//                                     //     ),
//                                     //   ),
//                                     // )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),

                ],
              ),
            ),
          );
        }
      ),
    );
  }

}
