import 'dart:convert';
import 'package:cab_taxi_app/Pages/Add%20New%20Booking/add_new_booking.dart';
import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/ui/homepage.dart';
import 'package:cab_taxi_app/Pages/chat/chat_listing.dart';
import 'package:cab_taxi_app/app/router/app_router.dart';
import 'package:cab_taxi_app/app/router/navigation/nav.dart';
import 'package:cab_taxi_app/models/my_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Controllers/home_controller.dart';
import '../../Controllers/my_booking_controller.dart';
import '../../app/router/navigation/routes.dart';
import '../../core/network_service.dart';
import '../../core/utils/helperFunctions.dart';
import '../Custom_Widgets/custom_text_button.dart';
import '../Custom_Widgets/CustomShimmer_widget.dart';
import '../HomePageFlow/custom/customSearchBar.dart';
import '../Review/write_review.dart';
import 'bloc/booking_bloc.dart';
import 'bloc/booking_event.dart';
import 'bloc/booking_state.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController searchController = TextEditingController();
  // final MyBookingController controller = Get.put(MyBookingController());
  // final HomeController homeController = Get.put(HomeController());


  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(GetPostedBooingEvent(context: context));

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //controller.getMyBookingData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(title: "Posted Booking",showLeading: false,showAction: false,),
      body: RefreshIndicator(
        onRefresh: ()async {
          //await controller.getMyBookingData();
        },
        child: BlocBuilder<BookingBloc,BookingState>(
            builder: (context,state) {
              if(state.isLoading){
                return SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Center(child: const CircularProgressIndicator()));

              }
              if(state.postedBookingModel==null){
                return SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Center(child: const CircularProgressIndicator()));

              }

              final newBooking=state.postedBookingModel!.data;


              return SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                          //Nav.push(context,Routes.applyFilter);
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
                SizedBox(height: 10,),


                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:newBooking!.length,
                    itemBuilder: (context, index) {
                      var newBookingData = newBooking[index];
                      return GestureDetector(
                        onTap: () async {

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
                                                  text: 'ID : ${newBookingData.orderId}',
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
                                                  newBookingData.pickUpDate.toString(),
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
                                                child: Text( newBookingData.pickUpTime.toString(),
                                                  // newBooking[index].pickupTime,
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
                                              ' ${newBookingData.subTypeLabel}',
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
                                                      newBookingData.pickUpLoc.toString(),
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
                                                width: 168,
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
                                                                '₹ ${newBookingData.driverCommission}',
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
                                                                '₹ ${newBookingData.totalFaire}',
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
                                                    child: Text( newBookingData.destinationLoc.toString(),
                                                //      newBooking[index].destinationLocation,
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
                                          Text(
                                              newBookingData.carCategory!.name.toString(),
                                            //newBooking[index].carCategoryName,
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
                                          Text( newBookingData.remark.toString(),
                                            //newBooking[index].remark??"N/A",
                                            overflow: TextOverflow.ellipsis,
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
                                        height: 45, // Adjust the container height as needed
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
                                              ),
                                            ),
                                            SizedBox(width: 5,),

                                            // Second part
                                            GestureDetector(
                                              onTap: () {
                                                Nav.push(
                                                  context,
                                                  Routes.editBooking,
                                                  extra: newBookingData, // 👈 FULL OBJECT PASS
                                                );

                                                print("Booking Type 🙌 ${newBookingData.subTypeLabel}");
                                              },
                                              child: Expanded(
                                                child: Container(
                                                  width: 100,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: ShapeDecoration(
                                                    color: const Color(0xADEFEFEF),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset("assets/images/pencil 1.png",scale: 3,),
                                                      SizedBox(width: 10,),
                                                      Text("Edit",
                                                    //    "₹${newBooking[index].driverCommission}",
                                                        style: TextStyle(
                                                            fontSize: size.width * 0.035,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),

                                            // Third part
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: (){
                                                  print("delete CCOUNT");
                                                  showDialog(context: context, builder: (context) {
                                                    return    DeleteBookingDialog(bookingId: newBookingData.id.toString(),);
                                                  },);

                                                },
                                                child: Container(
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: ShapeDecoration(
                                                    color: const Color(0xADEFEFEF),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("Delete",
                                                       // "₹${newBooking[index].driverCommission}",
                                                        style: TextStyle(
                                                            fontSize: size.width * 0.035,
                                                            fontWeight: FontWeight.w500,color: Color(0xffF45858)),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                                    ),
                                    ///Share with section with Icons
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      height: 45,
                                      margin: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xffFCB117),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                        Text(
                                            "Chat",
                                            //"₹${newBooking[index].totalFare}",
                                            style: TextStyle(
                                                fontSize: size.width * 0.035,
                                                fontWeight: FontWeight.w500,color: Colors.white),
                                          ),   SizedBox(width: 10),  Image.asset("assets/images/paper-plane 1.png",scale: 3,),


                                        ],
                                      ),
                                    ),

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




  DeleteBookingDialog({super.key, required this.bookingId});

 // final controller = Get.put(MyBookingController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Booking ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF3E4959),
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Are you sure you want to delete this booking? ',
              style: TextStyle(
                color: const Color(0xFF3E4959),
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: screenWidth * 0.27,
                    height: screenHeight * 0.045,
                    decoration: ShapeDecoration(
                      color: Color(0xff3E4959),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2,
                          color: Color(0xff3E4959),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Go back',
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

                    context.read<BookingBloc>().add(
                      DeleteBooingEvent(
                        context: context,
                        bookingId: bookingId,

                      ),
                    );
                    Navigator.of(context).pop();
                    // controller.deleteBooking(
                    //     bookingId: bookingId);
                  },
                  child: Container(
                    width: screenWidth * 0.27,
                    height: screenHeight * 0.045,
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

              ],
            ),
          ],
        ),
      ),
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






