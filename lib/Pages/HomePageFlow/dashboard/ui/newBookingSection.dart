import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app/router/navigation/nav.dart';
import '../../../../app/router/navigation/routes.dart';
import '../../../../core/network_service.dart';
import '../../../../models/home_model.dart';
import '../../../bookingDetails/ui/bookingDetailScreen.dart';
import '../../custom/customSearchBar.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';
import 'sliderWidget.dart';
class NewBookingSection extends StatefulWidget {
  const NewBookingSection({super.key});

  @override
  State<NewBookingSection> createState() => _NewBookingSectionState();
}

class _NewBookingSectionState extends State<NewBookingSection> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        //await controller.getHomeData();
      },
      child: BlocBuilder<DashboardBloc,DashboardState>(
          builder: (context,state) {
            if(state.isLoading){
              return SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Center(child: const CircularProgressIndicator()));

            }
            if(state.homeDataResponseModel==null){
              return SizedBox(
                height: size.height,
                  width: size.width,
                  child: Center(child: const CircularProgressIndicator()));

            }

            final newBooking=state.homeDataResponseModel!.newBooking.data;


            return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            // child: controller.homeLoading.value
            //     ? CircularProgressIndicator()
            //     : Column(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomSearchBar(
                            controller: searchController,
                            onSearch: () {},
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          Nav.push(context,Routes.applyFilter);
                        },
                        child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(12),
                            clipBehavior: Clip.antiAlias,
                            //     clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.50),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Image.asset(
                              "assets/images/seetingFilter.png",
                              scale: 3,
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SliderWidget(),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // alignment:Alignment.centerRight,
                    itemCount: newBooking.length,
                    itemBuilder: (context, index) {
                      // var newBookingData = controller
                      //     .homeData.value.newBooking!.data![index];
                      return GestureDetector(
                        onTap: () async {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailScreen(bookingID: newBooking[index].id,),));


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
                                          Text('ID : ${newBooking[index].bookingId}',
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
                                                  newBooking[index].pickupDate,
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
                                                  newBooking[index].pickupTime,
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
                                                            newBooking[index].pickupLocation,
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
                                                          newBooking[index].destinationLocation,
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
                                          Image.network(newBooking[index].carImage,scale: 4,errorBuilder: (context, error, stackTrace) {
                                            return Image.asset("assets/images/carMO.png",scale: 4,);
                                          },),
                                        //  Image.asset("assets/images/carMO.png",scale: 4,),
                                          SizedBox(width: 5,),
                                          Text(
                                            newBooking[index].carCategoryName,
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
                                            newBooking[index].remark??"N/A",
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
                                                      "₹${newBooking[index].totalFare}",
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
                                            ),
                                            SizedBox(width: 5,),

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
                                                      "₹${newBooking[index].driverCommission}",
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
                                                      "₹${newBooking[index].driverCommission}",
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
              ],
            ),
          );
        }
      ),
    );
  }


}
