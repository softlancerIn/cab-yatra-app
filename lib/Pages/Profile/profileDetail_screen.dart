import 'dart:io';
import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../Controllers/profile_controller.dart';
import '../Add Profile/add_profile.dart';
import '../Custom_Widgets/custom_app_bar.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final ProfileController controller = Get.put(ProfileController());
  bool isDriverDetailsSelected = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController dlController = TextEditingController();

  /// Car controller
  final TextEditingController carBrandController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();
  final TextEditingController fuelController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController carRcController = TextEditingController();
  final TextEditingController noOfSeats = TextEditingController();
  String driverImagePath = '';
  String carImagePath = '';
  String insuranceImagePath = '';
  String carRcFrontImagePath = '';
  String carRcBackImagePath = '';
  String? selectedFuelType;
  int? selectedFuelIndex;

  final List<String> fuelTypes = [
    "Petrol",
    "Diesel",
    "Electric",
    "Hybrid",
    "Others",
    "CNG",
  ];

  @override
  void initState() {
    super.initState();
    fetchDetailsData();
  }

  Future<void> fetchDetailsData() async {
    final profile = controller.profileData.value.data;

    // Populate text controllers with profile data
    nameController.text = profile?.name ?? '';
    emailController.text = profile?.email ?? '';
    mobileController.text = profile?.phone ?? '';
    aadharController.text = profile?.aadharNo ?? '';
    panController.text = profile?.panNo ?? '';
    dlController.text = profile?.dlNo ?? '';
    carBrandController.text = profile?.driverCarDetails?.carBrand ?? '';
    carNameController.text = profile?.driverCarDetails?.carName ?? '';
    carNumberController.text = profile?.driverCarDetails?.carNo ?? '';
    noOfSeats.text = profile?.driverCarDetails?.noSeat ?? '';
    driverImagePath =profile?.driverImageUrl??'';
    carImagePath = profile?.driverCarDetails?.carImageUrl??'';
    insuranceImagePath = profile?.driverCarDetails?.insurenceImageUrl??'';
    carRcFrontImagePath = profile?.driverCarDetails?.carRcFrontImageUrl??'';
    expiryController.text = profile?.driverCarDetails?.insurenceExpiry??'';
    String? fetchedFuelType = profile?.driverCarDetails?.fuelType;
    print(profile?.driverCarDetails?.fuelType);
    print('fetchedFuelType');
    if (fetchedFuelType != null) {
      print(fetchedFuelType);
      int index = int.tryParse(fetchedFuelType) ?? -1;
      if (index >= 0 && index < fuelTypes.length) {
        selectedFuelType = fuelTypes[index];
        selectedFuelIndex = index;
        print(selectedFuelIndex);
      }
    }
    setState(() {});
  }
  void _showImageSourceDialog(String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(type, ImageSource.camera);
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(type, ImageSource.gallery);
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _pickImage(String type, ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        switch (type) {
          case 'driver':
            driverImagePath = image.path;
            break;
          case 'car':
            carImagePath = image.path;
            break;
          case 'insurance':
            insuranceImagePath = image.path;
            break;
          case 'carRcFront':
            carRcFrontImagePath = image.path;
            break;
          case 'carRcBack':
            carRcBackImagePath = image.path;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBAR(title: "Profile"),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          if (controller.profileLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToggleButton('Driver Details', isDriverDetailsSelected, () {
                    setState(() {
                      isDriverDetailsSelected = true;
                    });
                  }),
                  _buildToggleButton('Car Details', !isDriverDetailsSelected, () {
                    setState(() {
                      isDriverDetailsSelected = false;
                    });
                  }),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: isDriverDetailsSelected
                        ? _buildDriverDetails(context)
                        : _buildCarDetails(context, screenWidth, screenHeight),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buildToggleButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFCB117) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: title == 'Driver Details' ? const Radius.circular(16) : Radius.zero,
            bottomLeft: title == 'Driver Details' ? const Radius.circular(16) : Radius.zero,
            topRight: title == 'Car Details' ? const Radius.circular(16) : Radius.zero,
            bottomRight: title == 'Car Details' ? const Radius.circular(16) : Radius.zero,
          ),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDriverDetails(BuildContext context) {
    return Column(
      children: [
        const Text(
          'In case of any problem in uploading documents,\nplease Whatsapp and call to 7820078200',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            _showImageSourceDialog('driver');
          },
          child: driverImagePath.isEmpty
              ? CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.upload, size: 40),
          )
              : CircleAvatar(
            radius: 50,
            backgroundImage: driverImagePath.startsWith('http')
                ? NetworkImage(driverImagePath) // Use NetworkImage for URLs
                : FileImage(File(driverImagePath)), // Use FileImage for local images
          ),
        ),
        const SizedBox(height: 8),
        const Text("Upload Driver’s Photo"),
        const SizedBox(height: 16),
        _buildTextField('Enter your Name', nameController,false),
        _buildTextField('Email Id', emailController,false),
        _buildTextField('Phone Number', mobileController,false),
        _buildTextField('Aadhar Card Number', aadharController,true),
        _buildTextField('Pan Card Number', panController,true),
        _buildTextField('DL Number', dlController,false),
        const SizedBox(height: 16),
        _buildSaveButton(),
      ],
    );
  }
  Widget _buildCarDetails(BuildContext context, screenWidth, screenHeight ) {
    return Column(
      children: [
        const Text(
          'In case of any problem in uploading documents,\nplease Whatsapp and call to 7820078200',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            _showImageSourceDialog('car');
          },
          child: carImagePath.isEmpty
              ? CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.upload, size: 40),
          )
              : CircleAvatar(
            radius: 50,
            backgroundImage: carImagePath.startsWith('http')
                ? NetworkImage(carImagePath)
                : FileImage(File(carImagePath)) as ImageProvider,
          ),
        ),
        const SizedBox(height: 8),
        const Text("Upload Car’s Photo"),
        const SizedBox(height: 16),

        _buildTextField('Car Brand', carBrandController,false),
        _buildTextField('Car Name', carNameController,false),
        _buildTextField('Car Number', carNumberController,false),
        _buildTextField('Expiry Date', expiryController,false),
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
        _buildTextField('No. of Seats', noOfSeats,false),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                _buildImageContainer(context, insuranceImagePath, 'Upload Insurance Photo', screenWidth, screenHeight),
                const SizedBox(height: 8),
                const Text('Insurance', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              children: [
                _buildImageContainer(context, carRcFrontImagePath, 'Upload Car RC Photo', screenWidth, screenHeight),
                const SizedBox(height: 8),
                const Text('Car RC', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, bool? isReadonly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: isReadonly??false,
        decoration: InputDecoration(
          hintText: hint,
          label: Text(hint),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFCB117),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        if (isDriverDetailsSelected) {
          try {
            await controller.updateDriverProfileData(
              pan: panController.text,
              driverPhoto: driverImagePath,
              name: nameController.text,
              email: emailController.text,
              aadhaarNo: aadharController.text,
              phone: mobileController.text,
              dlNo: dlController.text,
            );
            Get.snackbar(
              'Success',
              'Driver details updated successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white,
            );
          } catch (e) {
            print('Error updating driver details: $e');
          }
        } else {
          try {
            await controller.updateCarProfileData(
              carBrand: carBrandController.text,
              carName: carNameController.text,
              fuelType: selectedFuelIndex.toString(),
              carImage: carImagePath,
              insuranceImage: insuranceImagePath,
              carRcFrontImage: carRcFrontImagePath,
              carNo: carNumberController.text,
              seat: noOfSeats.text,
              expiryDate: expiryController.text,
            );
            Get.snackbar(
              'Success',
              'Car details updated successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white,
            );
          } catch (e) {
            print('Error updating car details: $e');
          }
        }
      },
      child: const Text(
        'Update',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, String imagePath, String uploadButtonText, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () {
        _showFullScreenImage(context, imagePath, uploadButtonText, screenWidth, screenHeight);
      },
      child: imagePath.isEmpty
          ? Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.3,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.upload, size: 40),
      )
          : Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: imagePath.startsWith('http')
                ? NetworkImage(imagePath) // Use NetworkImage for URLs
                : FileImage(File(imagePath)), // Use FileImage for local images
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  void _showFullScreenImage(BuildContext context, String imagePath, String uploadButtonText, double screenWidth, double screenHeight) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.8,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: imagePath.isEmpty
                        ? const Icon(Icons.upload, size: 40)
                        : Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        title: 'Cancel',
                        color: const Color(0xFFFF0000),
                        textColor: Colors.white,
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        title: uploadButtonText,
                        color: const Color(0xFFFCB117),
                        textColor: Colors.white,
                        onPressed: () {
                          Get.back();
                          if (imagePath == insuranceImagePath) {
                            _showImageSourceDialog('insurance');
                          } else if (imagePath == carRcFrontImagePath) {
                            _showImageSourceDialog('carRcFront');
                          } else if (imagePath == carRcBackImagePath) {
                            _showImageSourceDialog('carRcBack');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}