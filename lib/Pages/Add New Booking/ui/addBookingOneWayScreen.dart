import 'package:cab_taxi_app/Pages/Add%20New%20Booking/repo/addCreateRepo.dart';
import 'package:cab_taxi_app/widget/customTextField.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/network_service.dart';
import '../../../models/dropdown_models.dart';
import '../../../models/post_booking_model.dart';
import '../../../services/location_search.dart';
import '../../Custom_Widgets/custom_app_bar.dart';

import '../bloc/addBookingBloc.dart';
import '../bloc/addBookingEvent.dart';
import '../bloc/addBookingState.dart';

class AddBookingOneWayScreen extends StatelessWidget {
  const AddBookingOneWayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddBookingBloc()..add(LoadCarCategories(context)),
      child: const _AddBookingOneWayScreenView(),
    );
  }
}

class _AddBookingOneWayScreenView extends StatefulWidget {
  const _AddBookingOneWayScreenView();

  @override
  State<_AddBookingOneWayScreenView> createState() =>
      _AddBookingOneWayScreenViewState();
}

class _AddBookingOneWayScreenViewState
    extends State<_AddBookingOneWayScreenView> {
  // Controllers
  final _startDateCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();
  final _pickupCtrl = TextEditingController();
  final _dropCtrl = TextEditingController();
  final _totalFareCtrl = TextEditingController();
  final _driverCommCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  String? _selectedTripType = 'One Way';
  bool _showPhoneNumber = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
        // appBar: AppBAR(title: "Add New Booking"),
      body: BlocConsumer<AddBookingBloc, AddBookingState>(
        listener: (context, state) {
          if (state.isSuccess) {
            // Fluttertoast.showToast(
            //   msg: "Booking created successfully!",
            //   backgroundColor: Colors.green,
            // );
            showAssignDriverBottomSheet(context);
         //   Get.back();
          }
          // if (state.hasError && state.errorMessage != null) {
          //   Fluttertoast.showToast(
          //     msg: state.errorMessage!,
          //     backgroundColor: Colors.red,
          //   );
          // }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<AddBookingBloc>().add(LoadCarCategories(context));
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Vehicle Category Dropdown ───────────────────────────────
                  const Text("Select Vehicle Category",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  state.isLoading
                      ? const Center(child: SizedBox())
                      : state.carCategories == null ||
                              state.carCategories!.data!.isEmpty
                          ? const Text("No categories available",
                              style: TextStyle(color: Colors.red))
                          : containerShadow(
                              child: DropdownButtonFormField<int>(
                                value: state.selectedCarCategoryId,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                ),
                                hint: const Text("Choose vehicle",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),),
                                items: state.carCategories!.data!.map((car) {
                                  return DropdownMenuItem<int>(
                                    value: car.id,
                                    child: Text(
                                      car.name ?? "Unknown",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<AddBookingBloc>()
                                        .add(SelectCarCategory(value));
                                  }
                                },
                              ),
                            ),

                  const SizedBox(height: 24),

                  // ── Trip Type (simple for now) ──────────────────────────────
                  // _buildDropdownField(
                  //   label: "Trip Type",
                  //   value: _selectedTripType,
                  //   items: const ['One Way', 'Round Trip'],
                  //   onChanged: (val) => setState(() => _selectedTripType = val),
                  // ),

                  //  const SizedBox(height: 16),

                  // ── Pickup & Drop (single field for now) ────────────────────
                  CommonTextFormField(
                    controller: _pickupCtrl,
                    hintText:  "Pickup Location",

                  ),
                  // containerShadow(
                  //   child: _buildTextField(
                  //     label: "Pickup Location",
                  //     controller: _pickupCtrl,
                  //     hint: "e.g. Ghaziabad",
                  //   ),
                  // ),
                  const SizedBox(height: 16),
                  CommonTextFormField(
                    controller: _dropCtrl,
                    hintText:  "Drop Location",

                  ),
                  // containerShadow(
                  //   child: _buildTextField(
                  //     label: "Drop Location",
                  //     controller: _dropCtrl,
                  //     hint: "e.g. Noida",
                  //   ),
                  // ),

                  const SizedBox(height: 24),

                  // ── Date & Time ─────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: containerShadow(
                          child: _buildDateField(
                            label: "Pickup Date",
                            controller: _startDateCtrl,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: containerShadow(
                          child: _buildTimeField(
                            label: "Pickup Time",
                            controller: _startTimeCtrl,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Total Fare & Driver Commission ──────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFormField(
                          hintText:  "Total Fare",
                          controller: _totalFareCtrl,
                          keyboardType: TextInputType.number,
                        ),),

                      const SizedBox(width: 12),
                      Expanded(
                        child: CommonTextFormField(
                          hintText: "Driver Commission",
                          controller: _driverCommCtrl,
                          keyboardType: TextInputType.number,
                        ),
                        // child: containerShadow(
                        //   child: _buildNumberField(
                        //     label: "Driver Commission",
                        //     controller: _driverCommCtrl,
                        //   ),
                        // ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Show Phone Number Switch ────────────────────────────────
                  Container(
                    // width: 333,
                    height: 60,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    child: SwitchListTile(
                      title: const Text(
                        "Show my phone number to driver",
                        style: TextStyle(fontSize: 13),
                      ),
                      value: _showPhoneNumber,
                      onChanged: (val) =>
                          setState(() => _showPhoneNumber = val),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Remarks ─────────────────────────────────────────────────
                  Container(
                    // width: 333,
                    height: 130,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    child: TextField(
                      controller: _remarksCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        labelText: "Remarks / Special Instructions",
                        hintStyle: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                        labelStyle: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  CommonAppButton(isLoading: state.isSubmitting,
                    text: "Post Booking",   onPressed: state.isSubmitting
                      ? null
                      : () {
                    if (state.selectedCarCategoryId == null) {
                      Fluttertoast.showToast(
                          msg: "Please select vehicle category");
                      return;
                    }
                    if (_pickupCtrl.text.trim().isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Pickup location is required");
                      return;
                    }
                    if (_dropCtrl.text.trim().isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Drop location is required");
                      return;
                    }
                    if (_startDateCtrl.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Pickup date is required");
                      return;
                    }
                    if (_totalFareCtrl.text.trim().isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Total fare is required");
                      return;
                    }

                    final booking = SubmitBooking(
                      subType: "0",
                      noOfDay: "",
                      tripNotes: "",
                      // hardcoded as per requirement
                      carCategoryId: state.selectedCarCategoryId!,
                      pickUpDate: _startDateCtrl.text,
                      pickUpTime: _startTimeCtrl.text,
                      pickUpLocations: [_pickupCtrl.text.trim()],
                      destinationLocations: [_dropCtrl.text.trim()],
                      totalFare:
                      double.tryParse(_totalFareCtrl.text) ?? 0.0,
                      driverCommission:
                      double.tryParse(_driverCommCtrl.text) ??
                          0.0,
                      showPhoneNumber: _showPhoneNumber,
                      remarks: _remarksCtrl.text.trim(),
                      context: context,
                    );

                    context.read<AddBookingBloc>().add(booking);
                    showAssignDriverBottomSheet(context);

                  },),



                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────────────────





  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            suffixIcon: const Icon(Icons.calendar_month),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          final now = DateTime.now();
          final dt = DateTime(
              now.year, now.month, now.day, picked.hour, picked.minute);
          controller.text = DateFormat('HH:mm').format(dt);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            suffixIcon: const Icon(Icons.access_time),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget containerShadow({required Widget child}) {
    return Container(
      // width: 333,
      height: 50,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
      child: child,
    );
  }



  @override
  void dispose() {
    _startDateCtrl.dispose();
    _startTimeCtrl.dispose();
    _pickupCtrl.dispose();
    _dropCtrl.dispose();
    _totalFareCtrl.dispose();
    _driverCommCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }
  void showAssignDriverBottomSheet(BuildContext context) {
    int selectedValue = 0;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Icon(Icons.check_circle,
                      size: 70, color: Colors.red),

                  const SizedBox(height: 10),

                  const Text(
                    "Booking posted Successfully",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [

                        RadioListTile<int>(
                          value: 0,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                          title: const Text(
                            "Auto Assign Driver – The first driver who pays the commission will get the booking",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),

                        RadioListTile<int>(
                          value: 1,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                          title: const Text(
                            "Manual Selection – You will choose the driver yourself",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {

                        context.read<AddBookingBloc>().add(
                          UpdateAssignMethodEvent(

                            context: context,
                            assignType: selectedValue.toString(),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10)
                ],
              ),
            );
          },
        );
      },
    );
  }
}
