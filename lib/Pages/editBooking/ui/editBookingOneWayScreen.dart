import 'package:cab_taxi_app/Pages/Add%20New%20Booking/repo/addCreateRepo.dart';
import 'package:cab_taxi_app/widget/customTextField.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import '../bloc/editBookingBloc.dart';
import '../bloc/editBookingEvent.dart';
import '../bloc/editBookingState.dart';
import '../repo/editBookingRepo.dart';

class EditBookingOneWayScreen extends StatefulWidget {
  final String vehicalType;
  final String pickUpLocation;
  final String dropLocation;
  final String pickUpDate;
  final String pickUpTime;
  final String totalFare;
  final String driverCommission;
  final String remark;
  const EditBookingOneWayScreen({super.key,required this.pickUpTime,required this.remark,required this.driverCommission,required this.pickUpDate,required this.totalFare,required this.dropLocation,required this.pickUpLocation,required this.vehicalType});

  @override
  State<EditBookingOneWayScreen> createState() =>
      EditBookingOneWayScreenState();
}

class EditBookingOneWayScreenState
    extends State<EditBookingOneWayScreen> {
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
  void initState() {
    super.initState();

    _pickupCtrl.text = widget.pickUpLocation;
    _dropCtrl.text = widget.dropLocation;
    _startDateCtrl.text = widget.pickUpDate;
    _startTimeCtrl.text = widget.pickUpTime;
    _totalFareCtrl.text = widget.totalFare;
    _driverCommCtrl.text = widget.driverCommission;
    _remarksCtrl.text = widget.remark;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      //  appBar: AppBAR(title: "Add New Booking"),
      body: BlocConsumer<EditBookingBloc, EditBookingState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Fluttertoast.showToast(
              msg: "Booking created successfully!",
              backgroundColor: Colors.green,
            );
            Get.back();
          }
          if (state.hasError && state.errorMessage != null) {
            Fluttertoast.showToast(
              msg: state.errorMessage!,
              backgroundColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<EditBookingBloc>().add(EditLoadCarCategories(context));
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
                      ? const Center(child: CircularProgressIndicator())
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
                                        .read<EditBookingBloc>()
                                        .add(EditSelectCarCategory(value));
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
                        ),),

                      const SizedBox(width: 12),
                      Expanded(
                        child: CommonTextFormField(
                          hintText: "Driver Commission",
                          controller: _driverCommCtrl,
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
                    text: "Update Booking",   onPressed: state.isSubmitting
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

                    final booking = EditSubmitBooking(
                      subType: "0",
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

                    context.read<EditBookingBloc>().add(booking);
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
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
}
