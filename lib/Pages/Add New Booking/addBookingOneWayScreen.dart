
import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/home_controller.dart';
import '../../Controllers/my_booking_controller.dart';
import '../../core/network_service.dart';
import '../../models/dropdown_models.dart';
import '../../models/post_booking_model.dart';
import '../../services/location_search.dart';
import '../Custom_Widgets/CustomShimmer_widget.dart';
import '../HomePageFlow/home_controller.dart';
import 'add_new_booking.dart';
class AddBookingOneWayScreen extends StatefulWidget {
  final bool? isUpdate;
  final List<String>? initialPickUpLocation;
  final int? bookingId;
  final List<String>? initialDropLocation;
  final String? initialStartDate;
  final String? initialStartTime;
  final String? initialEndDate;
  final String? initialTotalKM;
  final String? initialExtraPrice;
  final String? initialTotalAmount;
  final String? initialCommission;
  final String? initialVehicleType;
  final String? tripTypeValue;
  final String? isShowPhoneNumber;
  final String? specialRequirement;
  final int? vehicalsValue;
  const AddBookingOneWayScreen({
    Key? key,
    this.isUpdate,
    this.initialPickUpLocation,
    this.initialDropLocation,
    this.initialStartDate,
    this.initialStartTime,
    this.initialEndDate,
    this.initialTotalKM,
    this.initialExtraPrice,
    this.initialTotalAmount,
    this.initialCommission,
    this.initialVehicleType,
    this.tripTypeValue,
    this.vehicalsValue,
    this.isShowPhoneNumber,
    this.specialRequirement,
    this.bookingId,
  }) : super(key: key);


  @override
  State<AddBookingOneWayScreen> createState() => _AddBookingOneWayScreenState();
}

class _AddBookingOneWayScreenState extends State<AddBookingOneWayScreen> {
  final homeController = Get.put(HomeController());
  final myBookingController = Get.put(MyBookingController());
  final TextEditingController dummYcontroller = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController destcontroller = TextEditingController();
  final TextEditingController pickUpcontroller1 = TextEditingController();
  final TextEditingController Dropcontroller1 = TextEditingController();
  final TextEditingController extraPriceController = TextEditingController();
  final TextEditingController totalKMController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController commisionController = TextEditingController();
  final TextEditingController specialReqController = TextEditingController();
  List<TextEditingController> pickCityControllers = [];
  List<TextEditingController> dropCityControllers = [];
  List<Widget> dynamicPickUpFields = [];
  List<Widget> dynamicDropFields = [];
  List<String> pickUpcities = [];
  List<String> dropCities = [];
  int? vehicalsValue;
  List<CarModel> vehicals = [];
  List<TimeZone> localTime = [];
  String? vehicalTypeValue;
  String? tollAppplicableValue = 'Include';
  int? selectedTimeZone;
  String? selectedAirportType;
  String? taxAppplicablevalue = 'Include';
  String? add_on_serviceValue = 'Yes';
  String? is_show_phoneNumberValue = 'Yes';
  bool isLoadingCarData = true;
  bool isLoadingTimeZone = true;
  final List<String> vehicalType = [
    'Diesel cab',
    'CNG cab',
  ];
  final List<String> tollAppplicable = [
    'Extra',
    'Include',
  ];
  final List<String> taxAppplicable = [
    'Extra',
    'Include',
  ];
  final List<String> add_on_service = [
    'Yes',
    'No',
  ];
  final List<String> is_show_phoneNumber = [
    'Yes',
    'No',
  ];

  final List<String> airportType = [
    'From Airport',
    'To Airport',
  ];

  String? tripTypeValue;
  bool _isPostingData = false;

  @override
  void initState() {
    super.initState();
    fetchCarList();
    endTimeController.text = "11:59 PM";
    // tripTypeValue = widget.tripTypeValue ?? tripTypeValue ?? 'One Way';
    // if (widget.tripTypeValue != null) {
    //   tripTypeValue = widget.tripTypeValue;
    // }

    const tripTypeMap = {
      '1': 'One Way',
      '0': 'Round Trip',
      '2': 'Airport Transfer',
      '3': 'Local Trip',
    };

    totalKMController.text= '0';
    extraPriceController.text= '0'
        ''
        '';
    tripTypeValue = tripTypeMap[widget.tripTypeValue] ?? 'One Way';
    if (widget.vehicalsValue != null) {
      vehicalsValue = widget.vehicalsValue!;
    }
    // if( widget.initialPickUpLocation)
    if (widget.initialStartDate != null) {
      startDateController.text = widget.initialStartDate!;
    }
    if (widget.initialStartTime != null) {
      startTimeController.text = widget.initialStartTime!;
    }
    if (widget.initialEndDate != null) {
      endDateController.text = widget.initialEndDate!;
    }
    if (widget.initialTotalKM != null) {
      totalKMController.text = widget.initialTotalKM!;
    }
    if (widget.initialExtraPrice != null) {
      extraPriceController.text = widget.initialExtraPrice!;
    }
    if (widget.initialTotalAmount != null) {
      totalAmountController.text = widget.initialTotalAmount!;
    }
    if (widget.initialCommission != null) {
      commisionController.text = widget.initialCommission!;
    }
    if (widget.initialVehicleType != null) {
      vehicalTypeValue = widget.initialVehicleType == '0' ? 'Diesel cab' : (widget.initialVehicleType == '1' ? 'CNG cab' : null);
    }
    if (widget.isShowPhoneNumber != null) {
      is_show_phoneNumberValue = widget.isShowPhoneNumber!;
    }
    if (widget.specialRequirement != null) {
      specialReqController.text = widget.specialRequirement!;
    }


    if (widget.initialPickUpLocation != null && widget.initialPickUpLocation!.isNotEmpty) {
      String firstLocation = widget.initialPickUpLocation![0].trim();
      pickUpcontroller1.text = firstLocation;
      for (int i = 1; i < widget.initialPickUpLocation!.length; i++) {
        String location = widget.initialPickUpLocation![i].trim();
        TextEditingController controller = TextEditingController(text: location);
        pickCityControllers.add(controller);
        dynamicPickUpFields.add(
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    CustomLocationSearchField(
                      width: double.infinity,
                      controller: controller,
                      hintText: 'Enter More Cities',
                      iconButton: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            dynamicPickUpFields.removeLast();
                            pickCityControllers.removeLast();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
    if (widget.initialDropLocation != null && widget.initialDropLocation!.isNotEmpty) {
      String firstDropLocation = widget.initialDropLocation![0].trim();
      Dropcontroller1.text = firstDropLocation; // Assign the first drop location to Dropcontroller1
      for (int i = 1; i < widget.initialDropLocation!.length; i++) {
        String location = widget.initialDropLocation![i].trim();
        TextEditingController controller = TextEditingController(text: location);
        dropCityControllers.add(controller);
        dynamicDropFields.add(
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    CustomLocationSearchField(
                      width: double.infinity,
                      controller: controller,
                      hintText: 'Enter More Drop Locations',
                      iconButton: IconButton(
                        icon: Icon(Icons.cancel, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            dynamicDropFields.removeLast();
                            dropCityControllers.removeLast();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> fetchCarList() async {
    setState(() {
      isLoadingCarData = true;
    });

    NetworkService networkService = NetworkService();
    List<CarModel>? carList = await networkService.getCarList();

    if (carList != null && carList.isNotEmpty) {
      setState(() {
        vehicals = carList;
        isLoadingCarData = false;
      });
    } else {
      print('Failed to fetch car list or empty list');
      setState(() {
        isLoadingCarData = false;
      });
    }
  }

  Future<void> fetchTimeList() async {
    setState(() {
      isLoadingTimeZone = true;
    });

    NetworkService networkService = NetworkService();
    List<TimeZone>? timeList = await networkService.getLocalTime();

    if (timeList != null && timeList.isNotEmpty) {
      setState(() {
        localTime = timeList;
        isLoadingTimeZone = false;
      });
    } else {
      print('Failed to fetch list or empty list');
      setState(() {
        isLoadingTimeZone = false;
      });
    }
  }

  void addPickCityField() {
    TextEditingController PickUpcityController = TextEditingController();

    setState(() {
      dynamicPickUpFields.add(
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  CustomLocationSearchField(
                    width: double.infinity,
                    controller: PickUpcityController,
                    hintText: 'Enter More Cities',
                    iconButton: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          dynamicPickUpFields.removeLast();
                          pickCityControllers.removeLast();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      pickCityControllers.add(PickUpcityController);
    });
  }

  void getFinalPickUps() {
    List<String> enteredCities = [];
    if (pickUpcontroller1.text.isNotEmpty) {
      enteredCities.add(pickUpcontroller1.text);
    }
    for (var controller in pickCityControllers) {
      if (controller.text.isNotEmpty) {
        enteredCities.add(controller.text);
      }
    }
    setState(() {
      pickUpcities = enteredCities;
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            hintColor: Colors.black,
            colorScheme: ColorScheme.light(primary: Colors.black),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            // dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            hintColor: Colors.black,
            colorScheme: ColorScheme.light(primary: Colors.black),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            // dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (selectedTime != null) {
      DateTime selectedDateTime = DateTime(
        0,
        0,
        0,
        selectedTime.hour,
        selectedTime.minute,
      );
      String formattedTime = DateFormat('hh:mm a').format(selectedDateTime);
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  void addDropCityField() {
    TextEditingController DestinationcityController = TextEditingController();

    setState(() {
      dynamicDropFields.add(
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  CustomLocationSearchField(
                    width: double.infinity,
                    controller: DestinationcityController,
                    hintText: 'Enter more Drop Location',
                    iconButton: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          dynamicDropFields.removeLast();
                          dropCityControllers.removeLast();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      dropCityControllers.add(DestinationcityController);
    });
  }

  void getFinalDrops() {
    List<String> enteredCities = [];
    if (Dropcontroller1.text.isNotEmpty) {
      enteredCities.add(Dropcontroller1.text);
    }
    for (var controller in dropCityControllers) {
      if (controller.text.isNotEmpty) {
        enteredCities.add(controller.text);
      }
    }
    setState(() {
      dropCities = enteredCities;
    });
  }

  void clearFields() {
    // Clear all text controllers
    dummYcontroller.clear();
    startDateController.clear();
    startTimeController.clear();
    endDateController.clear();
    endTimeController.clear();
    destcontroller.clear();
    pickUpcontroller1.clear();
    Dropcontroller1.clear();
    extraPriceController.clear();
    totalKMController.clear();
    totalAmountController.clear();
    commisionController.clear();
    specialReqController.clear();

    // Clear dynamic fields
    pickCityControllers.forEach((controller) => controller.clear());
    dropCityControllers.forEach((controller) => controller.clear());
    dynamicPickUpFields.clear();
    dynamicDropFields.clear();

    // Reset other variables
    pickUpcities.clear();
    dropCities.clear();
    vehicalsValue = null;
    vehicalTypeValue = null;
    tollAppplicableValue = 'Include';
    taxAppplicablevalue = 'Include';
    add_on_serviceValue = 'Yes';
    is_show_phoneNumberValue = 'Yes';
    tripTypeValue = 'One Way'; // or any default value you want
    selectedTimeZone = null; // Reset selected time zone
    selectedAirportType = null; // Reset selected airport type
    totalKMController.text = '0'; // Reset total KM to default
    extraPriceController.text = '0'; // Reset extra price to default
    totalAmountController.text = '0'; // Reset total amount to default
    commisionController.text = '0'; // Reset commission to default
    endTimeController.text = "11:59 PM";
    // totalKMController.text = '0';
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        // Clear fields only if not update mode
        if (!(widget.isUpdate ?? false)) {
          clearFields();
          // Optionally refetch car list and other needed data after clearing
          await fetchCarList();
          await fetchTimeList();
          setState(() {});
        }
      },
      child: Column(
        children:[ Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonHeading(
                  text: 'Select Vehical',
                  color: Colors.black,
                ),
                SizedBox(
                  height: 15,
                ),
                isLoadingCarData
                    ? Center(child:CustomShimmerContainer(
                  width: width,
                  height: height * 0.1,
                ),)
                    : CustomDropdown<CarModel>(
                  selectedValue: vehicalsValue != null
                      ? vehicals.firstWhere((car) => car.id == vehicalsValue)
                      : null,
                  items: vehicals,
                  itemLabel: (CarModel car) => car.name,
                  onChanged: (CarModel? newValue) {
                    setState(() {
                      vehicalsValue = newValue?.id;
                    });
                  },
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  width: width,
                  hint: 'Select Vehicle',
                ),
                SizedBox(
                  height: 25,
                ),
                // commonHeading(
                //   text: 'Vehical Type',
                //   color: Colors.black,
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // CustomDropdown<String>(
                //   selectedValue: vehicalTypeValue,
                //   items: vehicalType,
                //   itemLabel: (String data) => data,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       vehicalTypeValue = newValue;
                //     });
                //   },
                //   color: Colors.black,
                //   backgroundColor: Colors.white,
                //   width: width,
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                commonHeading(
                  text: 'Trip Type',
                  color: Colors.black,
                ),
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          activeColor: const Color(0xFFFCB117),
                          value: 'One Way',
                          groupValue: tripTypeValue,
                          onChanged: (String? value) {
                            setState(() {
                              tripTypeValue = value;
                              dropCities.clear();
                              pickUpcities.clear();
                              pickUpcontroller1.clear();
                              Dropcontroller1.clear();
                              totalKMController.clear();
                            });
                          },
                        ),
                        Text(
                          'One Way',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          activeColor: const Color(0xFFFCB117),
                          value: 'Round Trip',
                          groupValue: tripTypeValue,
                          onChanged: (String? value) {
                            setState(() {
                              tripTypeValue = value;
                              dropCities.clear();
                              pickUpcities.clear();
                              pickUpcontroller1.clear();
                              Dropcontroller1.clear();
                              totalKMController.clear();
                            });
                          },
                        ),
                        Text(
                          'Round Trip',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          activeColor: const Color(0xFFFCB117),
                          value: 'Local Trip',
                          groupValue: tripTypeValue,
                          onChanged: (String? value) async {
                            setState(() {
                              tripTypeValue = value;
                              dropCities.clear();
                              pickUpcities.clear();
                              pickUpcontroller1.clear();
                              Dropcontroller1.clear();
                              totalKMController.clear();
                            });
                            await fetchTimeList();
                          },
                        ),
                        Text(
                          'Local Trip',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Radio<String>(
                    //       activeColor: const Color(0xFFFCB117),
                    //       value: 'Airport Transfer',
                    //       groupValue: tripTypeValue,
                    //       onChanged: (String? value) {
                    //         setState(() {
                    //           tripTypeValue = value;
                    //           dropCities.clear();
                    //           pickUpcities.clear();
                    //           pickUpcontroller1.clear();
                    //           Dropcontroller1.clear();
                    //           totalKMController.clear();
                    //         });
                    //       },
                    //     ),
                    //     Text(
                    //       'Airport Transfer',
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 12,
                    //         fontFamily: 'SF Pro Display',
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                if (tripTypeValue == 'One Way')
                  Column(
                    children: [
                      CustomLocationSearchField(
                        width: double.infinity,
                        controller: pickUpcontroller1,
                        hintText: 'Enter Pick Up Location',
                      ),
                      ...dynamicPickUpFields,
                      SizedBox(height: 10),
                      CustomLocationSearchField(
                        width: double.infinity,
                        // height: height * 0.4,
                        controller: Dropcontroller1,
                        hintText: 'Enter Destination Location',
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            width: width * 0.5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCB117),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: TextButton(
                              onPressed: addPickCityField,
                              child: Text(
                                '+ Add More Cities',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (tripTypeValue == 'Round Trip')
                  Column(
                    children: [
                      CustomLocationSearchField(
                        width: double.infinity,
                        controller: pickUpcontroller1,
                        hintText: 'Enter Pick Up Location',
                      ),
                      SizedBox(height: 10),
                      CustomLocationSearchField(
                        width: double.infinity,
                        controller: Dropcontroller1,
                        hintText: 'Enter Destination Location',
                      ), //pickUpLocation Field
                      ...dynamicDropFields,
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            width: width * 0.5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCB117),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: TextButton(
                              onPressed: addDropCityField,
                              child: Text(
                                '+ Add More Cities',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (tripTypeValue == 'Local Trip')
                  Column(
                    children: [
                      CustomLocationSearchField(
                        width: double.infinity,
                        controller: pickUpcontroller1,
                        hintText: 'Enter Pick Up Location',
                      ),
                      SizedBox(height: 10),
                      isLoadingTimeZone
                          ? Center(child: CircularProgressIndicator())
                          : CustomDropdown<TimeZone>(
                        selectedValue:
                        localTime != null && localTime.isNotEmpty
                            ? localTime.firstWhere(
                              (time) => time.id == selectedTimeZone,
                          orElse: () => TimeZone(
                              id: -1,
                              time:
                              'Please Select Preferred Time'), //a default object
                        )
                            : null,
                        items: localTime ?? [],
                        itemLabel: (TimeZone time) => time.time,
                        onChanged: (TimeZone? newValue) {
                          setState(() {
                            selectedTimeZone = newValue?.id;
                          });
                        },
                        color: Colors.black,
                        backgroundColor: Colors.white,
                        width: width,
                        hint: 'Select Preferred Time',
                      ),
                    ],
                  ),
                if (tripTypeValue == 'Airport Transfer')
                  Column(
                    children: [
                      CustomDropdown<String>(
                        selectedValue: selectedAirportType,
                        items: airportType,
                        itemLabel: (String data) => data,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedAirportType = newValue;
                          });
                        },
                        color: Colors.black,
                        backgroundColor: Colors.white,
                        width: width,
                        hint: 'Select From/To Airport',
                      ),
                      SizedBox(height: 10),
                      CustomLocationSearchField(
                        width: double.infinity,
                        controller: pickUpcontroller1,
                        hintText: 'Select Pick Up Airport Local',
                        locationType: 'airport',
                      ),
                      SizedBox(height: 10),
                      CustomLocationSearchField(
                        width: double.infinity,
                        controller: Dropcontroller1,
                        hintText: 'Select Drop Airport Local',
                        locationType: 'airport',
                      ),
                    ],
                  ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: ()  {
                    _selectDate(context, startDateController);
                  },
                  child: CustomContainer(
                    onPress: () async {
                      await _selectDate(context, startDateController);
                    },
                    readOnly: true,
                    width: width,
                    height: 45,
                    controller: startDateController,
                    hintText: 'Start Date',
                    icon: Icon(Icons.calendar_month, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomContainer(
                  onPress:  () async {
                    await _selectTime(context, startTimeController);
                  },
                  readOnly: true,
                  width: width,
                  height: 45,
                  controller: startTimeController,
                  hintText: 'Start Time',
                  icon: Icon(Icons.watch_later_outlined, color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                if (tripTypeValue == 'Round Trip')
                  CustomContainer(
                    onPress:  ()  {
                      print("bkl");
                      _selectDate(context, endDateController);
                    },
                    readOnly: true,
                    width: width,
                    height: 45,
                    controller: endDateController,
                    hintText: 'End Date',
                    icon: Icon(Icons.calendar_month, color: Colors.black),
                  ),
                SizedBox(
                  height: 10,
                ),
                if (tripTypeValue == 'Round Trip')
                  CustomContainer(
                    readOnly: true,
                    width: width,
                    height: 45,
                    controller: endTimeController,
                    hintText: 'End Time',
                    icon: Icon(Icons.watch_later_outlined, color: Colors.black),
                  ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    if (tripTypeValue != 'Local Trip')
                      SizedBox(
                        width: width * 0.4,
                        child: commonHeading(
                          text: 'Total Kms*',
                          color: Colors.black,
                        ),
                      ),
                    if (tripTypeValue != 'Local Trip')
                      SizedBox(
                        width: width * 0.13,
                      ),
                    SizedBox(
                      width: width * 0.4,
                      child: commonHeading(
                        text: 'Extra Price Per Km',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (tripTypeValue != 'Local Trip')
                      CustomContainer(
                        width: width * 0.4,
                        height: 45,
                        controller: totalKMController,
                        hintText: '',
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter total Kms';
                        //   }
                        //   return null;
                        // },
                        // iconButton: IconButton(
                        //   icon: Icon(Icons.sync, color: Colors.black),
                        //   onPressed: () async {
                        //     getFinalPickUps();
                        //     getFinalDrops();
                        //     print('pick-cities: ${pickUpcities.map((city) => '"$city"').toList()}');
                        //     List<String> destinationAddress = dropCities.map((city) => '"$city"').toList();
                        //     if (tripTypeValue == 'Round Trip' && pickUpcities.isNotEmpty) {
                        //       destinationAddress.add('"${pickUpcities.last}"');
                        //     }
                        //
                        //     // Instance of DistanceCalculator
                        //     DistanceCalculator distanceCalculator = DistanceCalculator();
                        //     double totalDistance = await distanceCalculator.calculateTotalDistance(
                        //       pickUpLocs: pickUpcities,
                        //       destinationLoc: destinationAddress.join(', '),  // multiple
                        //     );
                        //     setState(() {
                        //       totalKMController.text = totalDistance.toStringAsFixed(2);  // showing string with 2 decimal places
                        //     });
                        //   },
                        // ),
                      ),
                    CustomContainer(
                      width: width * 0.4,
                      height: 45,
                      controller: extraPriceController,
                      hintText: '',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      child: commonHeading(
                        text: 'Total Amount*',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.13,
                    ),
                    SizedBox(
                      width: width * 0.4,
                      child: commonHeading(
                        text: 'Commission*',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomContainer(
                      width: width * 0.4,
                      height: 45,
                      controller: totalAmountController,
                      hintText: '',
                      keyboardType: TextInputType.number,
                    ),
                    CustomContainer(
                      width: width * 0.4,
                      height: 45,
                      controller: commisionController,
                      hintText: '',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      child: commonHeading(
                        text: 'Toll',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.13,
                    ),
                    SizedBox(
                      width: width * 0.4,
                      child: commonHeading(
                        text: 'Tax',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDropdown<String>(
                      selectedValue: tollAppplicableValue,
                      items: tollAppplicable,
                      itemLabel: (String data) => data,
                      onChanged: (String? newValue) {
                        setState(() {
                          tollAppplicableValue = newValue;
                        });
                      },
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      width: width * 0.4,
                    ),
                    CustomDropdown<String>(
                      selectedValue: taxAppplicablevalue,
                      items: taxAppplicable,
                      itemLabel: (String data) => data,
                      onChanged: (String? newValue) {
                        setState(() {
                          taxAppplicablevalue = newValue;
                        });
                      },
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      width: width * 0.4,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                commonHeading(
                  text: 'Carrier',
                  color: Colors.black,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomDropdown<String>(
                  selectedValue: add_on_serviceValue,
                  items: add_on_service,
                  itemLabel: (String data) => data,
                  onChanged: (String? newValue) {
                    setState(() {
                      add_on_serviceValue = newValue;
                    });
                  },
                  backgroundColor: Colors.white,
                  width: width,
                  color: Colors.black,
                  hint: 'Do you have any luggage.',
                ),
                SizedBox(
                  height: 30,
                ),
                commonHeading(
                  text: 'Show your phone number*',
                  color: Colors.black,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomDropdown<String>(
                  isReadOnly: true,
                  selectedValue: is_show_phoneNumberValue,
                  items: is_show_phoneNumber,
                  itemLabel: (String data) => data,
                  onChanged: (String? newValue) {
                    setState(() {
                      is_show_phoneNumberValue = newValue;
                    });
                  },
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  width: width,
                  hint: 'Do you want to show your contact.',
                ),
                SizedBox(height: 20),
                commonHeading(
                  text: 'Special reuirement',
                  color: Colors.black,
                ),
                SizedBox(height: 15),
                CustomContainer(
                  width: width,
                  height: 100,
                  controller: specialReqController,
                  hintText: '',
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFFFB900),
              shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(6),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: _isPostingData
                ? null
                : () async {
              bool? bankInfoStatus = await NetworkService().checkBankInfo();
              if (bankInfoStatus != true) {
                Fluttertoast.showToast(
                  msg: 'Please add the Account Details!',
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                return;
              }
              setState(() {
                _isPostingData = true;
              });

              getFinalPickUps();
              getFinalDrops();

              if (!(widget.isUpdate ?? false)) {
                if (tripTypeValue == null ||
                    pickUpcities.isEmpty ||
                    vehicalsValue == null ||
                    tollAppplicableValue == null || totalAmountController.text == null || totalAmountController.text.isEmpty || totalAmountController.text == '0' ||commisionController.text == null || commisionController.text.isEmpty || commisionController.text == '0') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all the mandatory fields*'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                  setState(() {
                    _isPostingData = false;
                  });
                  return;
                }
              }

              List<String> destinationAddress =
              dropCities.map((city) => '"$city"').toList();

              if (tripTypeValue == 'Round Trip' &&
                  pickUpcities.isNotEmpty) {
                // city from pickUpcities to destinationAddress
                destinationAddress.add('"${pickUpcities.last}"');
              }
              print(vehicalsValue);
              print('vehicalsdsdsgValue');
              final postData = AddBookingModel(
                carCategoryId: vehicalsValue ?? 0,
                fuelType: vehicalTypeValue == 'Diesel cab'
                    ? 0
                    : vehicalTypeValue == 'CNG cab'
                    ? 1
                    : -1,
                tripType: tripTypeValue == 'One Way'
                    ? '1'
                    : tripTypeValue == 'Round Trip'
                    ? '0'
                    : tripTypeValue == 'Airport Transfer'
                    ? '2'
                    : tripTypeValue == 'Local Trip'
                    ? '3'
                    : '',
                pickupAddress:
                pickUpcities.map((city) => '"$city"').toList(),
                destinationAddress: destinationAddress,
                startDate: startDateController.text,
                startTime: startTimeController.text,
                totalKm: totalKMController.text.isEmpty
                    ? '0'
                    : totalKMController.text,
                extraPricePerKm: extraPriceController.text,
                toll: tollAppplicableValue ?? '',
                tax: taxAppplicablevalue ?? '',
                totalAmount: totalAmountController.text.isEmpty ?'0' :totalAmountController.text,
                commission: commisionController.text.isEmpty?'0':commisionController.text,
                addOnService: add_on_serviceValue ?? '',
                // isShowPhoneNumber: is_show_phoneNumberValue == 'Yes' ? '1' : '0',
                isShowPhoneNumber: is_show_phoneNumberValue ='1',
                specialRequirement: specialReqController.text,
                endDate: endDateController.text,
                endTime: endTimeController.text,
                timeScheduleId: selectedTimeZone,
                airportTypeId: selectedAirportType == 'From Airport'
                    ? 1
                    : selectedAirportType == 'To Airport'
                    ? 2
                    : 0,
              );
              final networkService = NetworkService();
              final apiResponse = widget.isUpdate??false
                  ? await myBookingController.updateBooking(tripData: postData, bookingId: widget.bookingId ?? 0)
              // : await networkService.postTripData(postData);
                  : await myBookingController.postBooking(tripData: postData);
              setState(() {
                _isPostingData = false;
              });

              if (apiResponse != null && apiResponse.status == true) {
                if (widget.isUpdate ?? false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Trip Updated successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Trip posted successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  await Future.delayed(Duration(milliseconds: 500));
                  Get.offAll(() => const MainHomeController(), arguments: {'initialIndex': 0});
                }
              } else {
                print('Failed to post trip data');
              }
            },
            child: _isPostingData
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
                : Center(
              child: Text(
                (widget.isUpdate ?? false) ? 'Update' : 'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget commonHeading({
    required String text,
    required Color color,
  }) =>
      Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w500,
          height: 0.11,
        ),
      );
}