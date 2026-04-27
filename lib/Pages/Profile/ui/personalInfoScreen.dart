import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/customTextField.dart';
import '../../Custom_Widgets/custom_app_bar.dart';
import 'package:cab_taxi_app/Pages/Profile/bloc/personal_info_bloc.dart';
import 'package:cab_taxi_app/Pages/Profile/bloc/personal_info_event.dart';
import 'package:cab_taxi_app/Pages/Profile/bloc/personal_info_state.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final license1Controller = TextEditingController();
  final license2Controller = TextEditingController();

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
    license2Controller.dispose();
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
              // ── Update Controllers from state ──
              if (!state.isSubmitting) {
                nameController.text = state.name;
                companyController.text = state.company;
                license1Controller.text = state.licenseNumber;
                license2Controller.text = state.licenseNumber2;
              }

              // Close screen after success
              if (state.isProfileUpdateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profile updated successfully"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
              }
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
                  const SizedBox(height: 60),

                  // Profile Image
                  Center(
                    child: GestureDetector(
                      onTap: () => pickImage(context),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          image: (state.image != null)
                              ? DecorationImage(image: FileImage(state.image!), fit: BoxFit.cover)
                              : (state.networkImage != null && state.networkImage!.isNotEmpty)
                                  ? DecorationImage(image: NetworkImage(state.networkImage!), fit: BoxFit.cover)
                                  : null,
                        ),
                        child: (state.image == null && (state.networkImage == null || state.networkImage!.isEmpty))
                            ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  CommonTextFormField(
                    controller: nameController,
                    hintText: "Name",
                    onChanged: (val) =>
                        context.read<PersonalInfoBloc>().add(NameChanged(val)),
                  ),

                  const SizedBox(height: 25),

                  CommonTextFormField(
                    controller: companyController,
                    hintText: "Campany",
                    onChanged: (val) => context
                        .read<PersonalInfoBloc>()
                        .add(CompanyChanged(val)),
                  ),

                  const SizedBox(height: 25),

                  // Role buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<PersonalInfoBloc>().add(TypeChanged("agent")),
                          child: roleButton("Agent", state.type),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<PersonalInfoBloc>().add(TypeChanged("owner")),
                          child: roleButton("Owner", state.type),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<PersonalInfoBloc>().add(TypeChanged("driver")),
                          child: roleButton("Driver", state.type),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  CommonTextFormField(
                    controller: license1Controller,
                    hintText: "City name",
                    onChanged: (val) {},
                  ),

                  const SizedBox(height: 80), // Large gap before the update button as per design

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
                                      licenseNumber: license1Controller.text.trim(),
                                      licenseNumber2: license2Controller.text.trim(),
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
    // Standardize comparison to avoid case-sensitivity issues while keeping UI labels capitalized
    final bool isSelected = role.toLowerCase() == selectedRole.toLowerCase();

    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xffF4A100) : const Color(0xFFE9E9E9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
