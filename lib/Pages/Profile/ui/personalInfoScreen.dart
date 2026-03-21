import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/customTextField.dart';
import '../../Custom_Widgets/custom_app_bar.dart';
import '../bloc/personal_info_bloc.dart';
import '../bloc/personal_info_event.dart';
import '../bloc/personal_info_state.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final license1Controller = TextEditingController();

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<PersonalInfoBloc>().add(LoadProfile(context));
  }

  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    license1Controller.dispose();
    super.dispose();
  }

  Future<void> pickImage(BuildContext context) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      context.read<PersonalInfoBloc>().add(ImageChanged(File(picked.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBAR(
          title: "Personal information", showLeading: true, showAction: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<PersonalInfoBloc, PersonalInfoState>(
            listener: (context, state) {
              // ── This runs EVERY time state changes ──
              // Perfect place for side-effects like updating controllers
              nameController.text = state.name;
              companyController.text = state.company;
              license1Controller.text = state.licenseNumber;

              // Optional: only update if user hasn't typed anything yet
              // if (nameController.text.isEmpty || nameController.text == "Name") {
              //   nameController.text = state.name;
              // }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Profile Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => pickImage(context),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: state.image != null
                              ? FileImage(state.image!)
                              : (state.networkImage != null &&
                                      state.networkImage!.isNotEmpty)
                                  ? NetworkImage(state.networkImage!)
                                  : null,
                          child: (state.image == null &&
                                  (state.networkImage == null ||
                                      state.networkImage!.isEmpty))
                              ? const Icon(Icons.camera_alt,
                                  size: 40, color: Colors.grey)
                              : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  CommonTextFormField(
                    controller: nameController,
                    hintText: "Name",
                    onChanged: (val) =>
                        context.read<PersonalInfoBloc>().add(NameChanged(val)),
                  ),

                  const SizedBox(height: 15),

                  CommonTextFormField(
                    controller: companyController,
                    hintText: "Remark",
                    onChanged: (val) => context
                        .read<PersonalInfoBloc>()
                        .add(CompanyChanged(val)),
                  ),

                  const SizedBox(height: 20),

                  // Role buttons (unchanged)

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context
                              .read<PersonalInfoBloc>()
                              .add(TypeChanged("agent")),
                          child: roleButton("agent", state.type),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context
                              .read<PersonalInfoBloc>()
                              .add(TypeChanged("owner")),
                          child: roleButton("owner", state.type),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context
                              .read<PersonalInfoBloc>()
                              .add(TypeChanged("driver")),
                          child: roleButton("driver", state.type),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  CommonTextFormField(
                    controller: license1Controller,
                    hintText: "Licence Number (optional)",
                    onChanged: (val) {
                      // Optional: you can add event if you want live update in state
                    },
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF4A100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Profile updated successfully"),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              // Only send image if picked, otherwise null
                              final imageToSend = state.image != null &&
                                      (state.image?.path.isNotEmpty ?? false)
                                  ? state.image
                                  : null;
                              context.read<PersonalInfoBloc>().add(
                                    SubmitPressed(
                                      context: context,
                                      type: state.type,
                                      name: nameController.text.trim(),
                                      licenseNumber:
                                          license1Controller.text.trim(),
                                      licenseNumber2: "",
                                      cInfo: companyController.text.trim(),
                                      driverImage: imageToSend,
                                    ),
                                  );
                            },
                      child: state.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Update",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget roleButton(String role, String selectedRole) {
    final bool isSelected = role == selectedRole;

    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xffF4A100) : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role, // small letter show karega
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
