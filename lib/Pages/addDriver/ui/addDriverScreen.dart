import 'dart:io';

import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget/customTextField.dart';
import '../bloc/driverBloc.dart';
import '../bloc/driverState.dart';
import '../bloc/submitDriver.dart';

//
// class AddDriverScreen extends StatelessWidget {
//   AddDriverScreen({super.key});
//
//   final nameCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   final licenseCtrl = TextEditingController();
//   final cityCtrl = TextEditingController();
//   final addressCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     // final imageProvider = context.watch<DriverImageProvider>();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Driver")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             CommonTextFormField(controller: nameCtrl, hintText: "Driver Name"),
//             const SizedBox(height: 12),
//             CommonTextFormField(controller: phoneCtrl, hintText: "Phone"),
//             const SizedBox(height: 12),
//             CommonTextFormField(controller: licenseCtrl, hintText: "License"),
//             const SizedBox(height: 12),
//             CommonTextFormField(controller: cityCtrl, hintText: "City"),
//             const SizedBox(height: 12),
//             CommonTextFormField(controller: addressCtrl, hintText: "Address"),
//             GestureDetector(
//               onTap: () {
//                 context.read<DriverBloc>().add(PickDLFront());
//               },
//               child: BlocBuilder<DriverBloc, DriverState>(
//                 builder: (context, state) {
//                   return Container(
//                     height: 100,
//                     width: 100,
//                     decoration: BoxDecoration(border: Border.all()),
//                     child: state.dlFront == null
//                         ? Icon(Icons.camera_alt)
//                         : Image.file(state.dlFront!, fit: BoxFit.cover),
//                   );
//                 },
//               ),
//             ),
//
//
//             const SizedBox(height: 20),
//             BlocBuilder<DriverBloc, DriverState>(
//               builder: (context, state) {
//                 return ElevatedButton(
//                   onPressed: () {
//                     final fields = {
//                       "driver_id": "1",
//                       "name": nameCtrl.text,
//                       "phone_number": phoneCtrl.text,
//                       "license_number": licenseCtrl.text,
//                       "city_name": cityCtrl.text,
//                       "address": addressCtrl.text,
//                     };
//
//                     final files = {
//                       if (state.dlFront != null) "dl_frontImage": state.dlFront!,
//                       if (state.dlBack != null) "dl_backImage": state.dlBack!,
//                       if (state.aadharFront != null) "aadhar_frontImage": state.aadharFront!,
//                       if (state.aadharBack != null) "aadhar_backImage": state.aadharBack!,
//                     };
//
//                     context.read<DriverBloc>().add(
//                       SubmitDriver(fields, files),
//                     );
//                   },
//                   child: const Text("Add Driver"),
//                 );
//               },
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
class AddDriverBottomSheet extends StatefulWidget {
  final int? driverId;
  const AddDriverBottomSheet({super.key, this.driverId});

  @override
  State<AddDriverBottomSheet> createState() => _AddDriverBottomSheetState();
}

class _AddDriverBottomSheetState extends State<AddDriverBottomSheet> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final licenseCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.driverId != null) {
      context.read<DriverBloc>().add(FetchDriverById(widget.driverId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BlocListener<DriverBloc, DriverState>(
        listener: (context, state) {
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.driverId == null
                    ? "Driver Added Successfully"
                    : "Driver Updated Successfully"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state.selectedDriver != null && widget.driverId != null) {
            final driver = state.selectedDriver;
            if (nameCtrl.text.isEmpty)
              nameCtrl.text = (driver['name'] ?? '').toString();
            if (phoneCtrl.text.isEmpty)
              phoneCtrl.text = (driver['phone_number'] ?? '').toString();
            if (licenseCtrl.text.isEmpty)
              licenseCtrl.text = (driver['license_number'] ?? '').toString();
            if (cityCtrl.text.isEmpty)
              cityCtrl.text = (driver['city_name'] ?? '').toString();
            if (addressCtrl.text.isEmpty)
              addressCtrl.text = (driver['address'] ?? '').toString();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.driverId == null ? "Add Driver" : "Update Driver",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
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

              /// Profile Circle
              Center(
                child: BlocBuilder<DriverBloc, DriverState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        context.read<DriverBloc>().add(PickProfileImage());
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.grey.shade400, width: 1.5),
                          image: state.profileImage != null
                              ? DecorationImage(
                                  image: FileImage(state.profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : (state.selectedDriver != null &&
                                      state.selectedDriver[
                                              'profile_image_url'] !=
                                          null)
                                  ? DecorationImage(
                                      image: NetworkImage(state
                                          .selectedDriver['profile_image_url']),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: (state.profileImage == null &&
                                (state.selectedDriver == null ||
                                    state.selectedDriver['profile_image_url'] ==
                                        null))
                            ? const Icon(Icons.person_add,
                                size: 40, color: Colors.black)
                            : null,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              /// Text Fields
              CommonTextFormField(
                  controller: nameCtrl, hintText: "Driver Full Name"),
              const SizedBox(height: 15),

              CommonTextFormField(
                controller: phoneCtrl,
                hintText: "Contact Number",
                maxLength: 10,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),

              CommonTextFormField(
                  controller: licenseCtrl, hintText: "Licence Number"),
              const SizedBox(height: 15),

              CommonTextFormField(controller: cityCtrl, hintText: "City Name"),
              const SizedBox(height: 15),

              CommonTextFormField(
                  controller: addressCtrl, hintText: "Enter Full Address"),

              const SizedBox(height: 25),

              /// DL Section
              const Text("DL Front & Back",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),

              BlocBuilder<DriverBloc, DriverState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: _uploadBox(
                          text: "+ Front",
                          file: state.dlFront,
                          imageUrl: state.selectedDriver?['dl_frontImage_url'],
                          onTap: () {
                            context.read<DriverBloc>().add(PickDLFront());
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _uploadBox(
                          text: "+ Back",
                          file: state.dlBack,
                          imageUrl: state.selectedDriver?['dl_backImage_url'],
                          onTap: () {
                            context.read<DriverBloc>().add(PickDLBack());
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 25),

              /// Aadhar Section
              const Text("Aadhar Front & Back",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),

              BlocBuilder<DriverBloc, DriverState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: _uploadBox(
                          text: "+ Front",
                          file: state.aadharFront,
                          imageUrl:
                              state.selectedDriver?['aadhar_frontImage_url'],
                          onTap: () {
                            context.read<DriverBloc>().add(PickAadharFront());
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _uploadBox(
                          text: "+ Back",
                          file: state.aadharBack,
                          imageUrl:
                              state.selectedDriver?['aadhar_backImage_url'],
                          onTap: () {
                            context.read<DriverBloc>().add(PickAadharBack());
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),
              BlocBuilder<DriverBloc, DriverState>(
                builder: (context, state) {
                  return CommonAppButton(
                    onPressed: () {
                      final fields = {
                        "name": nameCtrl.text,
                        "phone_number": phoneCtrl.text,
                        "license_number": licenseCtrl.text,
                        "city_name": cityCtrl.text,
                        "address": addressCtrl.text,
                      };

                      final files = <String, File>{};
                      if (state.profileImage != null)
                        files["driver_image"] = state.profileImage!;
                      if (state.dlFront != null)
                        files["dl_frontImage"] = state.dlFront!;
                      if (state.dlBack != null)
                        files["dl_backImage"] = state.dlBack!;
                      if (state.aadharFront != null)
                        files["aadhar_frontImage"] = state.aadharFront!;
                      if (state.aadharBack != null)
                        files["aadhar_backImage"] = state.aadharBack!;

                      if (widget.driverId != null) {
                        context
                            .read<DriverBloc>()
                            .add(UpdateDriver(widget.driverId!, fields, files));
                      } else {
                        context
                            .read<DriverBloc>()
                            .add(SubmitDriver(fields, files));
                      }
                    },
                    isLoading: state.loading,
                    text: widget.driverId == null ? "Add +" : "Update",
                  );
                },
              ),

              /// Add Button

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadBox({
    required String text,
    required VoidCallback onTap,
    required File? file,
    String? imageUrl,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: file != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : (imageUrl != null && imageUrl.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          text,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
      ),
    );
  }
}
