import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widget/customTextField.dart';
import '../../../widget/primary_button.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';

class AddVehicleBottomSheet extends StatefulWidget {
  const AddVehicleBottomSheet({super.key});

  @override
  State<AddVehicleBottomSheet> createState() => _AddVehicleBottomSheetState();
}

class _AddVehicleBottomSheetState extends State<AddVehicleBottomSheet> {
  final vehicleTypeCtrl = TextEditingController();
  final vehicleNumberCtrl = TextEditingController();
  final registrationYearCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Add Vehicle",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

            const SizedBox(height: 20),

            /// Vehicle Image Placeholder/Picker
            Center(
              child: BlocBuilder<VehicleBloc, VehicleState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      context.read<VehicleBloc>().add(PickVehicleImage());
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: state.vehicleImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(state.vehicleImage!, fit: BoxFit.cover),
                            )
                          : const Icon(Icons.directions_car_filled, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            /// Text Fields
            CommonTextFormField(controller: vehicleTypeCtrl, hintText: "Vehicle Type (e.g. Sedan)"),
            const SizedBox(height: 15),
            CommonTextFormField(controller: vehicleNumberCtrl, hintText: "Vehicle Number"),
            const SizedBox(height: 15),
            CommonTextFormField(controller: registrationYearCtrl, hintText: "Registration Year"),

            const SizedBox(height: 30),

            BlocBuilder<VehicleBloc, VehicleState>(
              builder: (context, state) {
                return CommonAppButton(
                  isLoading: state.isLoading,
                  onPressed: () {
                    if (vehicleTypeCtrl.text.isEmpty || vehicleNumberCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    final fields = {
                      "type": vehicleTypeCtrl.text,
                      "vehicle_number": vehicleNumberCtrl.text,
                      "registration_year": registrationYearCtrl.text,
                    };

                    final Map<String, File> files = {};
                    if (state.vehicleImage != null) {
                      files["vehicle_image"] = state.vehicleImage!;
                    }

                    context.read<VehicleBloc>().add(AddVehicle(fields, files));

                    Navigator.pop(context);
                  },
                  text: "Add Vehicle",
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
