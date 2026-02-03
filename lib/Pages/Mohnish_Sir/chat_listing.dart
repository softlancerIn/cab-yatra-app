import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Add New Booking/add_new_booking.dart';
import '../Booking/my_booking.dart';
import '../Custom_Widgets/bottom_nav_bar.dart';
import '../HomePageFlow/dashboard/ui/homepage.dart';
import '../Profile/profile.dart';
import 'chat_deatils.dart';

class ChatListingScreen extends StatefulWidget {
  const ChatListingScreen({super.key});

  @override
  State<ChatListingScreen> createState() => _ChatListingScreenState();
}

class _ChatListingScreenState extends State<ChatListingScreen> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Coming Soon!!!',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leading: GestureDetector(
        //     child: Icon(Icons.arrow_back_ios_new),
        //     onTap: () {
        //       Get.back();
        //     },
        //   ),
        //   title: Text(
        //     'Trust Travels',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: 16,
        //       fontFamily: 'Poppins',
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        //   centerTitle: true,
        //   actions: [Image.asset("assets/images/car_icon_n.png")],
        // ),
        //body:
        // ListView.builder(
        //   itemCount: 7,
        //   shrinkWrap: true,
        //   itemBuilder: (context, index) {
        //     return InkWell(
        //       onTap: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => ChatDeatils(),
        //             ));
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Row(
        //               children: [
        //                 ClipOval(
        //                     child: Image.network(
        //                   "https://picsum.photos/200/300",
        //                   height: 65,
        //                   width: 65,
        //                   fit: BoxFit.fill,
        //                 )),
        //                 SizedBox(
        //                   width: 10,
        //                 ),
        //                 Column(
        //                   mainAxisAlignment: MainAxisAlignment.start,
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       'Trust Travels',
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 14,
        //                         fontFamily: 'Poppins',
        //                         fontWeight: FontWeight.w500,
        //                       ),
        //                     ),
        //                     Text(
        //                       'This booking Is completed',
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 12,
        //                         fontFamily: 'Poppins',
        //                         fontWeight: FontWeight.w400,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.end,
        //               children: [
        //                 SizedBox(
        //                   height: 5,
        //                 ),
        //                 Text(
        //                   'ID : A001256',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                     color: Colors.black,
        //                     fontSize: 10,
        //                     fontFamily: 'Poppins',
        //                     fontWeight: FontWeight.w400,
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   height: 5,
        //                 ),
        //                 Container(
        //                   width: 12,
        //                   height: 12,
        //                   decoration: ShapeDecoration(
        //                     color: Color(0xFF1BADEB),
        //                     shape: OvalBorder(),
        //                   ),
        //                 ),
        //                 Text(
        //                   'Yesterday',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                     color: Colors.black.withOpacity(0.5),
        //                     fontSize: 10,
        //                     fontFamily: 'Poppins',
        //                     fontWeight: FontWeight.w400,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // )
    );
  }
}
