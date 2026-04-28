import 'package:cab_taxi_app/Pages/HomePageFlow/custom/location_autocomplete_field.dart';
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
import '../../HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import '../../Booking/bloc/booking_bloc.dart';
import '../../Booking/bloc/booking_event.dart';

class EditBookingOneWayScreen extends StatefulWidget {
  final String sId;
  final String vehicalType;
  final String? vehicleCategoryName;
  final String pickUpLocation;
  final String dropLocation;
  final String pickUpDate;
  final String pickUpTime;
  final String totalFare;
  final String driverCommission;
  final String remark;
  final String? isShowPhoneNumber;
  const EditBookingOneWayScreen(
      {super.key,
      required this.sId,
      required this.pickUpTime,
      required this.remark,
      required this.driverCommission,
      required this.pickUpDate,
      required this.totalFare,
      required this.dropLocation,
      required this.pickUpLocation,
      required this.vehicalType,
      this.vehicleCategoryName,
      this.extra,
      this.isShowPhoneNumber});

  final String? extra;

  @override
  State<EditBookingOneWayScreen> createState() =>
      EditBookingOneWayScreenState();
}

class EditBookingOneWayScreenState extends State<EditBookingOneWayScreen> {
  // Controllers
  final _startDateCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();
  final _pickupCtrl = TextEditingController();
  final _dropCtrl = TextEditingController();
  final _totalFareCtrl = TextEditingController();
  final _driverCommCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  final String _selectedTripType = 'One Way';
  bool _showPhoneNumber = false;
  final Set<String> _selectedRequirements = {};

  @override
  void initState() {
    super.initState();
    _pickupCtrl.text = widget.pickUpLocation;
    _dropCtrl.text = widget.dropLocation;
    _startDateCtrl.text = widget.pickUpDate;
    _startTimeCtrl.text = widget.pickUpTime;
    _totalFareCtrl.text = widget.totalFare;
    _driverCommCtrl.text = widget.driverCommission;
    
    // Initialize selected chips from extra string
    if (widget.extra != null && widget.extra!.isNotEmpty) {
      final parts = widget.extra!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
      _selectedRequirements.addAll(parts);
    }
    
    _remarksCtrl.text = widget.remark; 
    
    _showPhoneNumber = widget.isShowPhoneNumber == "1";
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, top: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF3E4959),
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  void _toggleRequirement(String label) {
    setState(() {
      if (_selectedRequirements.contains(label)) {
        _selectedRequirements.remove(label);
      } else {
        _selectedRequirements.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditBookingBloc()
        ..add(EditLoadCarCategories(context,
            initialCarCategoryId: int.tryParse(widget.vehicalType),
            initialCarCategoryName: widget.vehicleCategoryName)),
      child: BlocConsumer<EditBookingBloc, EditBookingState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Fluttertoast.showToast(
              msg: "Booking details updated!",
              backgroundColor: Colors.green,
            );
            showAssignDriverBottomSheet(context);
          }
          if (state.hasError && state.errorMessage != null) {
            Fluttertoast.showToast(
              msg: state.errorMessage!,
              backgroundColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              onRefresh: () async {
                context
                    .read<EditBookingBloc>()
                    .add(EditLoadCarCategories(context));
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Select vehical"), // Figma spelling
                    state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.carCategories == null ||
                                state.carCategories!.data!.isEmpty
                            ? const Text("No categories available",
                                style: TextStyle(color: Colors.red))
                            : Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xffDBDBDB)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    dropdownColor: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    value: state.selectedCarCategoryId,
                                    hint: const Text("Select vehicle...", style: TextStyle(fontSize: 13, color: Colors.grey)),
                                    items: state.carCategories!.data!.map((car) {
                                      return DropdownMenuItem<int>(
                                        value: car.id,
                                        child: Text(car.name ?? "", style: const TextStyle(fontSize: 13, color: Colors.black87)),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        context.read<EditBookingBloc>().add(EditSelectCarCategory(val));
                                      }
                                    },
                                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.orange),
                                  ),
                                ),
                              ),

                    const SizedBox(height: 8),

                    _label("Pickup Location"),
                    LocationAutocompleteField(
                      controller: _pickupCtrl,
                      hint: "Enter Pickup Location",
                    ),
                    const SizedBox(height: 8),
                    
                    _label("Drop-off Location"),
                    LocationAutocompleteField(
                      controller: _dropCtrl,
                      hint: "Enter Drop Location",
                    ),

                    const SizedBox(height: 8),

                    _label("Date / Time"),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            label: "Nov 01, 2025",
                            controller: _startDateCtrl,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTimeField(
                            label: "10:51 PM",
                            controller: _startTimeCtrl,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("Total amount"),
                              CommonTextFormField(
                                hintText: "0",
                                controller: _totalFareCtrl,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("commision amount"),
                              CommonTextFormField(
                                hintText: "0",
                                controller: _driverCommCtrl,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffDBDBDB)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Show your contact to drivers",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E4959),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "this will help you to make direct deal.",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: _showPhoneNumber,
                              activeColor: Colors.white,
                              activeTrackColor: const Color(0xFFFFB300),
                              onChanged: (val) => setState(() => _showPhoneNumber = val),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    _label("Extra Requirements"),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildRequirementChip("Only Diesel"),
                        _buildRequirementChip("With Carrier"),
                        _buildRequirementChip("All Inclusive"),
                        _buildRequirementChip("All Exclusive"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffDBDBDB)),
                      ),
                      child: TextField(
                        controller: _remarksCtrl,
                        onChanged: (val) => setState(() {}),
                        maxLines: 1,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: "Enter extra requirements...",
                          hintStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    CommonAppButton(
                      isLoading: state.isSubmitting,
                      text: "Update Booking",
                      onPressed: state.isSubmitting
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

                               double totalAmountValue = double.tryParse(_totalFareCtrl.text) ?? 0.0;
                               double commissionValue = double.tryParse(_driverCommCtrl.text) ?? 0.0;
                               if (commissionValue >= totalAmountValue && totalAmountValue > 0) {
                                 Fluttertoast.showToast(
                                     msg: "Commission must be less than Total amount");
                                 return;
                               }


                              final booking = EditSubmitBooking(
                                id: widget.sId,
                                subType: "1",
                                carCategoryId: state.selectedCarCategoryId!,
                                pickUpDate: _startDateCtrl.text,
                                pickUpTime: _startTimeCtrl.text,
                                pickUpLocations: [_pickupCtrl.text.trim()],
                                destinationLocations: [_dropCtrl.text.trim()],
                                totalFare:
                                    double.tryParse(_totalFareCtrl.text) ?? 0.0,
                                driverCommission:
                                    double.tryParse(_driverCommCtrl.text) ?? 0.0,
                                showPhoneNumber: _showPhoneNumber,
                                remarks: _remarksCtrl.text.trim(),
                                extra: _selectedRequirements.toList(),
                                context: context,
                              );

                              context.read<EditBookingBloc>().add(booking);
                            },
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
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
          controller.text = DateFormat('MMM dd, yyyy').format(picked);
          if (mounted) setState(() {});
        }
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffDBDBDB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                controller.text.isEmpty ? label : controller.text,
                style: TextStyle(
                  fontSize: 13,
                  color: controller.text.isEmpty ? Colors.grey : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.calendar_month_outlined, color: Colors.grey, size: 20),
          ],
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
          controller.text = DateFormat('hh:mm a').format(dt);
          if (mounted) setState(() {});
        }
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffDBDBDB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                controller.text.isEmpty ? label : controller.text,
                style: TextStyle(
                  fontSize: 13,
                  color: controller.text.isEmpty ? Colors.grey : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.access_time, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementChip(String label) {
    bool isSelected = _selectedRequirements.contains(label);

    return GestureDetector(
      onTap: () {
        _toggleRequirement(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffFCB117) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xffFCB117) : Colors.grey.shade300,
          ),
          boxShadow: [
            if (!isSelected)
              const BoxShadow(
                color: Color(0x19000000),
                blurRadius: 4,
                offset: Offset(0, 0),
              )
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
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

  void showAssignDriverBottomSheet(BuildContext parentContext) {
    String? selectedValue = "0";

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return BlocConsumer<EditBookingBloc, EditBookingState>(
              listener: (context, state) {
                if (state.updateAssignMethodModel != null) {
                  Fluttertoast.showToast(
                    msg: "Booking assigned successfully!",
                    backgroundColor: Colors.green,
                  );
                  // Refresh the list
                  context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
                  
                  // Refresh Posted Booking List if available
                  try {
                    context.read<BookingBloc>().add(GetPostedBooingEvent(context: context));
                  } catch (e) {
                    debugPrint("BookingBloc not found in context, skipping refresh");
                  }

                  // Navigate back
                  Navigator.pop(modalContext); // Close BottomSheet
                  Navigator.pop(context); // Close Edit Screen
                }
              },
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Icon(Icons.check_circle_rounded,
                          size: 80, color: Color(0xFFFFB300)),
                      const SizedBox(height: 16),
                      const Text(
                        "Booking updated Successfully!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Choose how you want to assign this booking",
                        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 24),
                      _buildOption(
                        title: "Direct Assign",
                        subtitle: "Auto assign to the first available driver",
                        value: "0",
                        selectedValue: selectedValue,
                        onChanged: (val) =>
                            setModalState(() => selectedValue = val),
                      ),
                      const SizedBox(height: 16),
                      _buildOption(
                        title: "Manual Selection",
                        subtitle: "Choose your favorite driver personally",
                        value: "1",
                        selectedValue: selectedValue,
                        onChanged: (val) =>
                            setModalState(() => selectedValue = val),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB300),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  context.read<EditBookingBloc>().add(
                                        EditUpdateAssignMethodEvent(
                                          context: context,
                                          assignType: selectedValue.toString(),
                                          bookingId: widget.sId,
                                        ),
                                      );
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Text(
                                  "Confirm Selection",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildOption({
    required String title,
    required String subtitle,
    required String value,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = value == selectedValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF8E6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFFFCB117) : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFCB117)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
                color:
                    isSelected ? const Color(0xFFFCB117) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF92400E)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? const Color(0xFFB45309)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiskIndicatorReplacement extends StatelessWidget {
  const DiskIndicatorReplacement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
