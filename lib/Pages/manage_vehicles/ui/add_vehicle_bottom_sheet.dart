import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widget/primary_button.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';

class AddVehicleBottomSheet extends StatefulWidget {
  final int? vehicleId;
  const AddVehicleBottomSheet({super.key, this.vehicleId});

  @override
  State<AddVehicleBottomSheet> createState() => _AddVehicleBottomSheetState();
}

class _AddVehicleBottomSheetState extends State<AddVehicleBottomSheet> {
  final insuranceExpiryCtrl = TextEditingController();
  final vehicleNumberCtrl = TextEditingController();
  final registrationYearCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(LoadCarCategories(context));
    if (widget.vehicleId != null) {
      context.read<VehicleBloc>().add(FetchVehicleById(widget.vehicleId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BlocListener<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.vehicleId == null 
                  ? "Vehicle Added Successfully" 
                  : "Vehicle Updated Successfully"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Return true for success
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state.selectedVehicle != null && widget.vehicleId != null) {
            final vehicle = state.selectedVehicle;
            if (vehicleNumberCtrl.text.isEmpty) {
              vehicleNumberCtrl.text = (vehicle['registration_number'] ?? vehicle['car_registration_number'] ?? '').toString();
            }
            if (registrationYearCtrl.text.isEmpty) {
              registrationYearCtrl.text = (vehicle['year_of_mfg'] ?? vehicle['registration_year'] ?? vehicle['manifacturer_of_year'] ?? '').toString();
            }
            if (insuranceExpiryCtrl.text.isEmpty) {
              final exp = (vehicle['insurence_expiry'] ?? vehicle['insurance_exp'] ?? vehicle['insurance_expiry'] ?? vehicle['insurance_expire_date'] ?? '').toString();
              if (exp.length > 10) {
                 insuranceExpiryCtrl.text = exp.substring(0, 10);
              } else {
                 insuranceExpiryCtrl.text = exp;
              }
            }
            if (state.selectedCarCategoryId == null && vehicle['car_category_id'] != null) {
              context.read<VehicleBloc>().add(SelectCarCategory(int.parse(vehicle['car_category_id'].toString())));
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.vehicleId == null ? "Add Car" : "Update Car",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<VehicleBloc, VehicleState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Vehicle Type Dropdown
                        state.carCategories == null ||
                                state.carCategories!.data == null ||
                                state.carCategories!.data!.isEmpty
                            ? const Center(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator()))
                            : Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: state.selectedCarCategoryId,
                                    isExpanded: true,
                                    hint: const Text("Vehicle Type",
                                        style: TextStyle(color: Colors.grey)),
                                    icon: const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.black54),
                                    items:
                                        state.carCategories!.data!.map((car) {
                                      return DropdownMenuItem<int>(
                                        value: car.id,
                                        child: Text(car.name ?? "Unknown"),
                                      );
                                    }).toList(),
                                    onChanged: (int? newValue) {
                                      if (newValue != null) {
                                        context
                                            .read<VehicleBloc>()
                                            .add(SelectCarCategory(newValue));
                                      }
                                    },
                                  ),
                                ),
                              ),
                        const SizedBox(height: 15),

                        /// Year of Manufacture
                        _buildTextField(
                          controller: registrationYearCtrl,
                          hintText: "Year of Manufacture",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                        ),
                        const SizedBox(height: 15),

                        /// Car Registration Number
                        _buildTextField(
                          controller: vehicleNumberCtrl,
                          hintText: "Car Registration Number",
                        ),
                        const SizedBox(height: 15),

                        const SizedBox(height: 15),

                        /// Upload Insurance Section
                        const Text(
                          "Upload Insurance",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              insuranceExpiryCtrl.text =
                                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                            }
                          },
                          child: AbsorbPointer(
                            child: _buildTextField(
                              controller: insuranceExpiryCtrl,
                              hintText: "Select Insurance Expiry Date",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildImagePickerBox(
                          context,
                          title: "+ Upload Insurance",
                          imageFile: state.insuranceImage,
                          imageUrl: state.selectedVehicle?['insurence_image_url'] ?? state.selectedVehicle?['insurance_document_url'] ?? state.selectedVehicle?['insurance_url'],
                          onTap: () {
                            context
                                .read<VehicleBloc>()
                                .add(PickSpecificDocument("insurance"));
                          },
                        ),
                        const SizedBox(height: 25),

                        /// RC Front & Back Section
                        const Text(
                          "RC Front & Back",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildImagePickerBox(
                                context,
                                title: "+ RC Front",
                                imageFile: state.rcFrontImage,
                                imageUrl: state.selectedVehicle?['car_rc_frontImage_url'] ?? state.selectedVehicle?['rc_front_image_url'] ?? state.selectedVehicle?['rc_front_url'],
                                onTap: () {
                                  context
                                      .read<VehicleBloc>()
                                      .add(PickSpecificDocument("rcFront"));
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildImagePickerBox(
                                context,
                                title: "+ RC Back",
                                imageFile: state.rcBackImage,
                                imageUrl: state.selectedVehicle?['car_rc_backImage_url'] ?? state.selectedVehicle?['rc_back_image_url'] ?? state.selectedVehicle?['rc_back_url'],
                                onTap: () {
                                  context
                                      .read<VehicleBloc>()
                                      .add(PickSpecificDocument("rcBack"));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        /// Vehicle Images Section
                        const Text(
                          "Vehicle Images",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildImagePickerBox(
                                context,
                                title: "+ Car image",
                                imageFile: state.carImage1,
                                imageUrl: state.selectedVehicle?['car_image1_url'],
                                onTap: () {
                                  context
                                      .read<VehicleBloc>()
                                      .add(PickSpecificDocument("car1"));
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildImagePickerBox(
                                context,
                                title: "+ Car Image",
                                imageFile: state.carImage2,
                                imageUrl: state.selectedVehicle?['car_image2_url'],
                                onTap: () {
                                  context
                                      .read<VehicleBloc>()
                                      .add(PickSpecificDocument("car2"));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        CommonAppButton(
                          isLoading: state.isLoading,
                          onPressed: () {
                            if (state.selectedCarCategoryId == null ||
                                vehicleNumberCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please fill all fields")),
                              );
                              return;
                            }

                            final selectedCategory = state.carCategories?.data?.firstWhere(
                                (element) => element.id == state.selectedCarCategoryId,
                                orElse: () => null as dynamic);
                            final String categoryName = selectedCategory?.name ?? "";

                            final fields = {
                              "car_category_id":
                                  state.selectedCarCategoryId.toString(),
                              "car_name": categoryName,
                              "registration_number": vehicleNumberCtrl.text,
                              "year_of_mfg": registrationYearCtrl.text,
                              "insurance_exp": insuranceExpiryCtrl.text,
                            };

                            final Map<String, File> files = {};
                            if (state.insuranceImage != null)
                              files["insurance_document"] = state.insuranceImage!;
                            if (state.rcFrontImage != null)
                              files["rc_front_image"] = state.rcFrontImage!;
                            if (state.rcBackImage != null)
                              files["rc_back_image"] = state.rcBackImage!;
                            if (state.carImage1 != null)
                              files["car_image1"] = state.carImage1!;
                            if (state.carImage2 != null)
                              files["car_image2"] = state.carImage2!;

                            if (widget.vehicleId != null) {
                              context
                                  .read<VehicleBloc>()
                                  .add(UpdateVehicle(widget.vehicleId!, fields, files));
                            } else {
                              context
                                  .read<VehicleBloc>()
                                  .add(AddVehicle(fields, files));
                            }
                          },
                          text: widget.vehicleId == null ? "Add +" : "Update",
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildImagePickerBox(BuildContext context,
      {required String title, File? imageFile, String? imageUrl, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(imageFile, fit: BoxFit.cover),
              )
            : (imageUrl != null && imageUrl.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          title,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
      ),
    );
  }
}
