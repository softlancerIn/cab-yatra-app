import 'dart:convert';

import 'package:cab_taxi_app/models/home_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/home_controller.dart';
import '../HomePageFlow/dashboard/ui/homepage.dart';

class ChatDeatils extends StatefulWidget {
  final NewBookingData data;

  const ChatDeatils({super.key, required this.data});

  @override
  State<ChatDeatils> createState() => _ChatDeatilsState();
}

class _ChatDeatilsState extends State<ChatDeatils> {
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: const Text(
          'Trust Travels',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.call),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            cardSection(context, widget.data),
            const SizedBox(
              height: 10,
            ),
            // msgSection(context)//todo enable chatting
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: const Color(0xFFEBEAEA),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Type a message",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  "assets/images/Compose new btn.png",
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  width: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardSection(BuildContext context, NewBookingData data) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    String? destinationAddress =
        data.destinationLoc!.isEmpty ? 'Not Available' : data.destinationLoc;
    print(destinationAddress);
    List<String> dropCities = [];
    if (destinationAddress!.isNotEmpty) {
      var parsedDestination = json.decode(destinationAddress);
      dropCities = List<String>.from(
          parsedDestination.map((city) => city.replaceAll('"', '')));
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
    String? destD = '';
    if (data.destination_date!.isNotEmpty && data.destination_date != null) {
      String d = data.pickUpDate.toString();
      DateTime dd = DateFormat('yyyy-MM-dd').parse(d);
      String destDate = DateFormat('d MMM yyyy').format(dd);
      destD = destDate;
    }
    List<dynamic> parseAddOnService(String addOnService) {
      if (addOnService.isNotEmpty && addOnService != "[]") {
        return jsonDecode(addOnService);
      }
      return [];
    }

    String pickUpDateStr = data.pickUpDate.toString();
    DateTime pickUpDate = DateFormat('yyyy-MM-dd').parse(pickUpDateStr);
    String formattedDate = DateFormat('d MMM yyyy').format(pickUpDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7, left: 7, right: 7),
          child: Row(
            children: [
              Image.asset('assets/images/calender.png', scale: 5),
              SizedBox(width: size.width * 0.02),
              InkWell(
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              Text('ID : ${data.orderId.toString()}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.005),
        Padding(
          padding: const EdgeInsets.only(left: 7, right: 7),
          child: Row(
            children: [
              Image.asset('assets/images/clock.png', scale: 5),
              SizedBox(width: size.width * 0.02),
              InkWell(
                child: Text(
                  data.pickUpTime.toString(),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              Text(data.subTypeLabel.toString(),
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        const Divider(thickness: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
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
                        if (pickCities.length == 1)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: size.width * 0.035,
                                height: size.height * 0.017,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(212, 119, 22, 1),
                                  borderRadius: BorderRadius.circular(30),
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
                          SizedBox(
                            width: size.width * 0.7,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pickCities.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: size.width * 0.035,
                                      height: size.height * 0.017,
                                      decoration: BoxDecoration(
                                        color: index == 0
                                            ? const Color.fromRGBO(
                                                212, 119, 22, 1)
                                            : Colors.green,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    SizedBox(
                                      width: size.width * 0.55,
                                      child: Text(
                                        pickCities[index],
                                        style: TextStyle(
                                          fontSize: size.width * 0.035,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.005),
                  Container(
                    padding: EdgeInsets.only(left: size.width * 0.015),
                    height: size.height * 0.03,
                    child: CustomPaint(painter: DashedLinePainter()),
                  ),
                  if (data.typeLabel != 'Local')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (dropCities.length == 1)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: size.width * 0.035,
                                height: size.height * 0.017,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC51C1C),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              SizedBox(
                                width: size.width * 0.6,
                                child: Text(
                                  dropCities.first,
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
                          SizedBox(
                            width: size.width * 0.7,
                            child: ListView.builder(
                              shrinkWrap: true,
                              // Prevents overflow
                              physics: const NeverScrollableScrollPhysics(),
                              // Disable scrolling for the ListView
                              itemCount: dropCities.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: size.width * 0.035,
                                      height: size.height * 0.017,
                                      decoration: BoxDecoration(
                                        color: index == dropCities.length - 1
                                            ? const Color(0xFFC51C1C)
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
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        if (data.typeLabel == 'Local')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(data.timeScheduleData?.time ?? 'N/A',
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(46, 46, 46, 0.6))),
                const Text("Total Duration",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ],
            ),
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
                      color: data.fuel_type == "0"
                          ? const Color(0xFFC51C1C)
                          : data.fuel_type == "1"
                              ? const Color(0xFF45B129)
                              : Colors.yellow,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    data.fuel_type == "0"
                        ? 'DIESEL CAB'
                        : data.fuel_type == "1"
                            ? 'CNG CAB'
                            : 'None',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: data.fuel_type == "0"
                          ? const Color(0xFFC51C1C)
                          : data.fuel_type == "1"
                              ? const Color(0xFF45B129)
                              : Colors.yellow,
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text("${data.car?.name ?? ""} or Similar",
                  // "Dzire, Etios, Aura, Glanza Similar [AC] 4+1 [ Included\n4-Pax 2 Trolly+2 Hand Bags]",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 0, 0, 0.5))),
            ],
          ),
        ),
      ],
    );
  }

  Widget msgSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'What do you mean?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 300,
              decoration: const ShapeDecoration(
                color: Color(0xFFEAE9E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'I think the idea that things are chaning isnt good',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
