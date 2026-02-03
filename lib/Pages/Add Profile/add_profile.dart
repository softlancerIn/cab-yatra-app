import 'dart:io';
import 'package:cab_taxi_app/Controllers/driver_image_controller.dart';
import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../Controllers/auth_controller.dart';

class Profile extends StatefulWidget {
  final String mobile;

  const Profile({super.key, required this.mobile});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isNearestSelected = true;

  final DriverImagePickerController controller =
      Get.put(DriverImagePickerController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController dlController = TextEditingController();

  ///car controller
  final TextEditingController carBrandController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();
  final TextEditingController fuelController = TextEditingController();
  final TextEditingController seatController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController carRcController = TextEditingController();
  final TextEditingController noOfSeats = TextEditingController();

  final authController = Get.put(AuthController());

  @override
  void initState() {
    mobileController.text = widget.mobile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppBAR(title: "Profile"),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isNearestSelected = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isNearestSelected
                                ? const Color(0xFFFCB117)
                                : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            border: isNearestSelected
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.black, width: 0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          child: Text(
                            'Driver Details',
                            style: TextStyle(
                              color: isNearestSelected
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isNearestSelected = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isNearestSelected
                                ? const Color(0xFFFCB117)
                                : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            border: !isNearestSelected
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.black, width: 0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          child: Text(
                            'Car Details',
                            style: TextStyle(
                              color: !isNearestSelected
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isNearestSelected)
                    _buildDriverDetails(context)
                  else
                    _buildCarDetails(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  String? selectedCarBrand;

  String? selectedFuelType;
  // String? selectedSeats;
  int? selectedFuelIndex;

  final List<String> carBrands = [
    "Force",
    "Toyota",
    "Mahindra",
    "Honda",
    "Ford",
    "Renault",
    "Tata",
    "Nissan",
    "Maruti Suzuki",
    "BMW",
    "Mercedes-Benz",
    "Volkswagen",
    "Hyundai",
    "Kia",
  ];

  final List<String> fuelTypes = [
    "Petrol",
    "Diesel",
    "Electric",
    "Hybrid",
    "Others",
    "CNG",
  ];

  // final List<String> seatNumbers = [
  //   "2",
  //   "4",
  //   "5",
  //   "7",
  // ];

  // Widget for Driver Details
  Widget _buildDriverDetails(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.send),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  'In case of any problem in uploading documents, please WhatsApp and call to 7820078200',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _showImagePickerOptions('driver_image', context);
                  },
                  child: ClipOval(
                    child: Obx(() {
                      final imagePath =
                          controller.selectedImages['driver_image']!;
                      return Container(
                        width: 114,
                        height: 114,
                        color: const Color(0xFFDADADA),
                        // child: controller.selectedImagePath.value.isEmpty
                        child: imagePath.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(28),
                                child: Image.asset(
                                  'assets/images/driver_upload_logo.png',
                                  height: 20,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Image.file(
                                File(imagePath),
                                // File(controller.selectedImagePath.value),
                                fit: BoxFit.cover,
                              ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Upload Driver's Photo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Input fields

          const Row(
            children: [
              Text(
                'Enter your Name',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          _buildTextField("Enter your Name", "", false, nameController),
          const Row(
            children: [
              Text(
                'Email Id',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          _buildTextField("Email Id", '', false, emailController),
          const Row(
            children: [
              Text(
                'Phone Number',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          _buildTextField("Phone Number", "phone", false, mobileController),
          const Row(
            children: [
              Text(
                'Aadhar Card Number',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          _buildTextField(
            "Aadhar Card Number",
            "phone",
            false,
            aadharController,
          ),
          const Row(
            children: [
              Text(
                'Aadhar Card Images',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final adhaarImagePath =
                    controller.selectedImages['aadhar_frontImage']!;
                // aadhar_backImage
                return InkWell(
                  onTap: () {
                    _showImagePickerOptions('aadhar_frontImage', context);
                  },
                  child: Container(
                    width: 160,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: adhaarImagePath.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/upload_image_icon.png',
                                    height: 60,
                                  ),
                                  const Text(
                                    'Front Image',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ]),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(adhaarImagePath),
                              // File(controller.selectedImagePath.value),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                );
              }),
              Obx(() {
                final adhaarBackImagePath =
                    controller.selectedImages['aadhar_backImage']!;
                return InkWell(
                  onTap: () {
                    _showImagePickerOptions('aadhar_backImage', context);
                  },
                  child: Container(
                    width: 160,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: adhaarBackImagePath.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/upload_image_icon.png',
                                    height: 60,
                                  ),
                                  const Text(
                                    'Back Image',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ]),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(adhaarBackImagePath),
                              // File(controller.selectedImagePath.value),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            children: [
              Text(
                'Pan Card Number',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          _buildTextField("Pan Card Number", "", false, panController),
          const Row(
            children: [
              Text(
                'DL Number',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          _buildTextField("DL Number", "", false, dlController),
          const Row(
            children: [
              Text(
                'DL Image',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(() {
            final dlImagePath = controller.selectedImages['dl_image']!;
            return InkWell(
              onTap: () {
                _showImagePickerOptions('dl_image', context);
              },
              child: Container(
                width: width,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                ),
                child: dlImagePath.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/upload_image_icon.png',
                                  height: 70,
                                  fit: BoxFit.fitHeight,
                                ),
                                const Text(
                                  'Upload Image',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )
                              ]),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(dlImagePath),
                          // File(controller.selectedImagePath.value),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            );
          }),

          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCB117), // button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter valid name')),
                    );
                  } else if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter valid email ID')),
                    );
                  } else if (!validateEmail(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter valid email ID')),
                    );
                  } else if (mobileController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter valid phone number')),
                    );
                  } else if (aadharController.text.isEmpty ||
                      aadharController.text.length < 12 ||
                      aadharController.text.length > 12) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter valid aadhar number')),
                    );
                  } else if (dlController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter valid DL number')),
                    );
                  } else if (panController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter valid pan')),
                    );
                  } else if (controller
                      .selectedImages['driver_image']!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please upload a valid image')),
                    );
                  } else if (controller
                      .selectedImages['aadhar_frontImage']!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Please upload a valid aadhar front image')),
                    );
                  } else if (controller
                      .selectedImages['aadhar_backImage']!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Please upload a valid aadhar back image')),
                    );
                  } else if (controller.selectedImages['dl_image']!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please upload a valid dl image')),
                    );
                  } else {
                    await authController.uploadDriverDetails(
                        name: nameController.text,
                        email: emailController.text,
                        phone: mobileController.text,
                        aadhaarFrontImage:
                            controller.selectedImages['aadhar_frontImage']!,
                        aadhaarBackImage:
                            controller.selectedImages['aadhar_backImage']!,
                        aadhaarNo: aadharController.text,
                        pan: panController.text,
                        dlNo: dlController.text,
                        dlImage: controller.selectedImages['dl_image']!,
                        driverPhoto:
                            controller.selectedImages['driver_image']!);
                  }

                  authController.nextSeen.value
                      ? isNearestSelected = false
                      : null;
                  setState(() {});
                  // Get.to(Homepage());
                },
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2040, 8));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        expiryController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
        // dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        // _dateText.text=outputFormat.format(outputFormat);
      });
    }
  }

  // Widget for Car Details
  Widget _buildCarDetails(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.send),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      'In case of any problem in uploading documents, please WhatsApp and call to 7820078200',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Column(
              children: [
                Obx(() {
                  final carImagePath = controller.selectedImages['car_image']!;
                  return InkWell(
                      onTap: () {
                        _showImagePickerOptions('car_image', context);
                      },
                      child: ClipOval(
                        child: Container(
                          width: 114,
                          height: 114,
                          color: const Color(0xFFDADADA),
                          child: carImagePath.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(28),
                                  child: Image.asset(
                                    'assets/images/driver_upload_logo.png',
                                    height: 20,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Image.file(
                                  File(carImagePath),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ));
                }),
                const Text(
                  "Upload Car’s Photo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          DropdownField(
            items: carBrands,
            selectedValue: selectedCarBrand,
            label: 'Car Brand',
            onChanged: (value) {
              setState(() {
                selectedCarBrand = value;
              });
            },
          ),
          const Row(
            children: [
              Text(
                'Car Name',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          _buildTextField("Car Name", '', false, carNameController),
          const Row(
            children: [
              Text(
                'Car Number',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          _buildTextField("Car Number", "", false, carNumberController),
          DropdownField(
            items: fuelTypes,
            selectedValue: selectedFuelType,
            label: 'Fuel Type',
            onChanged: (value) {
              setState(() {
                selectedFuelType = value;
                selectedFuelIndex = fuelTypes.indexOf(value!);
              });
            },
          ),
          const Row(
            children: [
              Text(
                'No. of Seats With Diver Seats',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          _buildTextField('No. of Seats', 'number', false, noOfSeats),
          const Row(
            children: [
              Text(
                'Insurance',
                style: TextStyle(fontSize: 12, height: 2.5),
              ),
            ],
          ),
          Obx(() {
            final insuranceImagepath =
                controller.selectedImages['insurence_image']!;
            return InkWell(
                onTap: () {
                  _showImagePickerOptions('insurence_image', context);
                },
                child: Container(
                    width: width,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: insuranceImagepath.isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/upload_image_icon.png',
                                      height: 70,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    const Text(
                                      'Upload Image',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    )
                                  ]),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(
                                insuranceImagepath,
                              ),
                              fit: BoxFit.cover,
                            ),
                          )));
          }),
          const SizedBox(
            height: 10,
          ),
          const Row(
            children: [
              Text(
                'Expiry Date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          _buildTextDateField("Expiry Date", "", false, expiryController),
          const Row(
            children: [
              Text(
                'Car RC',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final carRcImagepath =
                    controller.selectedImages['car_rc_frontImage']!;
                return InkWell(
                    onTap: () {
                      _showImagePickerOptions('car_rc_frontImage', context);
                    },
                    child: Container(
                        width: 160,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: carRcImagepath.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Image.asset(
                                      'assets/images/upload_image_icon.png',
                                      height: 60,
                                    ),
                                    const Text(
                                      'Front Image',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ])
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(carRcImagepath),
                                  fit: BoxFit.cover,
                                ))));
              }),
              Obx(() {
                final carBackRcImagepath =
                    controller.selectedImages['car_rc_backImage']!;
                return InkWell(
                    onTap: () {
                      _showImagePickerOptions('car_rc_backImage', context);
                    },
                    child: Container(
                        width: 160,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: carBackRcImagepath.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Image.asset(
                                      'assets/images/upload_image_icon.png',
                                      height: 60,
                                    ),
                                    const Text(
                                      'Back Image',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ])
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(carBackRcImagepath),
                                  fit: BoxFit.cover,
                                ))));
              }),
            ],
          ),
          const SizedBox(height: 10,),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Container(
          //         width: 52,
          //         height: 52,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(100),
          //           color: Colors.black,
          //         ),
          //         child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Image.asset(
          //                 'assets/images/car_icon.png',
          //                 height: 30,
          //               )
          //             ]),
          //       ),
          //     ],
          //   ),
          // ),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCB117),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {

                  authController.uploadCarDetails(
                    driverId: authController.addDriverModel.value.driverId.toString(),
                    carBrand: selectedCarBrand.toString(),
                    carName: carNameController.text,
                    carNo: carNumberController.text,
                    seat: noOfSeats.text,
                    fuelType: selectedFuelIndex.toString(),
                    carImage: controller.selectedImages['car_image']!,
                    carRcBackImage:
                        controller.selectedImages['car_rc_backImage']!,
                    carRcFrontImage:
                        controller.selectedImages['car_rc_frontImage']!,
                    expiryDate: expiryController.text,
                    insuranceImage:
                        controller.selectedImages['insurence_image']!,
                  );

                  // Get.to(() => Homepage());
                },
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions(String fieldName, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  controller.pickImage(fieldName, ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  controller.pickImage(fieldName, ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to create TextFormField
  Widget _buildTextField(
    String label,
    String typeE,
    bool down,
    TextEditingController textController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: typeE == "phone" ? TextInputType.phone : typeE == "number" ? TextInputType.number : TextInputType.text,
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon:
              down == true ? const Icon(Icons.keyboard_arrow_down) : null,
        ),
      ),
    );
  }

  Widget _buildTextDateField(
    String label,
    String typeE,
    bool down,
    TextEditingController textController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType:
            typeE == "phone" ? TextInputType.phone : TextInputType.text,
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon:
              down == true ? const Icon(Icons.keyboard_arrow_down) : null,
        ),
      ),
    );
  }
}



class DropdownField extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final String label;
  final Function(String?) onChanged;

  DropdownField({
    required this.items,
    this.selectedValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedValue,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: const TextStyle(fontSize: 14, color: Colors.black),
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
    );
  }
}
