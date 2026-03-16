import 'package:cab_taxi_app/Pages/HomePageFlow/custom/location_autocomplete_field.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../widget/customTextField.dart';
import '../bloc/addBookingBloc.dart';
import '../bloc/addBookingEvent.dart';
import '../bloc/addBookingState.dart';
import '../../HomePageFlow/dashboard/bloc/dashboard_bloc.dart';

class AddBookingRoundTripScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const AddBookingRoundTripScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBookingBloc()..add(LoadCarCategories(context)),
      child: _AddBookingRoundTripScreenView(onBack: onBack),
    );
  }
}

class _AddBookingRoundTripScreenView extends StatefulWidget {
  final VoidCallback? onBack;
  const _AddBookingRoundTripScreenView({this.onBack});

  @override
  State<_AddBookingRoundTripScreenView> createState() =>
      _AddBookingRoundTripScreenViewState();
}

class _AddBookingRoundTripScreenViewState
    extends State<_AddBookingRoundTripScreenView> {
  // Controllers
  final _startDateCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();
  final _pickupCtrl = TextEditingController();
  final _dropCtrl = TextEditingController();
  final noOfDays = TextEditingController();
  final tripNotes = TextEditingController();
  final _totalFareCtrl = TextEditingController();
  final _driverCommCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  final String _selectedTripType = 'One Way';
  bool _showPhoneNumber = false;
  final List<String> _selectedRequirements = [];

  @override
  void initState() {
    super.initState();
    _remarksCtrl.addListener(_onRemarksChanged);
  }

  void _onRemarksChanged() {
    final List<String> parts = _remarksCtrl.text
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();

    final List<String> availableChips = [
      "Only Diesel",
      "With Carrier",
      "All Inclusive",
      "All Exclusive"
    ];

    bool changed = false;
    for (var chip in availableChips) {
      bool isInText = parts.contains(chip.toLowerCase());
      bool isInList = _selectedRequirements.contains(chip);

      if (isInText && !isInList) {
        _selectedRequirements.add(chip);
        changed = true;
      } else if (!isInText && isInList) {
        _selectedRequirements.remove(chip);
        changed = true;
      }
    }

    if (changed) {
      setState(() {});
    }
  }

  void _updateTextField(String label, bool isAdding) {
    String currentText = _remarksCtrl.text.trim();

    // Split by comma and clean whitespace
    List<String> parts = currentText
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (isAdding) {
      // Case-insensitive check to prevent duplicates if user typed it manually
      bool exists = parts.any((e) => e.toLowerCase() == label.toLowerCase());
      if (!exists) {
        parts.insert(0, label);
      }
    } else {
      // Remove all instances of the label (case-insensitive)
      parts.removeWhere((e) => e.toLowerCase() == label.toLowerCase());
    }

    _remarksCtrl.text = parts.join(", ");

    // Position cursor at the end to allow for continued manual typing
    _remarksCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: _remarksCtrl.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      //  appBar: AppBAR(title: "Add New Booking"),
      body: BlocConsumer<AddBookingBloc, AddBookingState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Fluttertoast.showToast(
              msg: "Booking created successfully!",
              backgroundColor: Colors.green,
            );
            // Trigger refresh of dashboard data
            context
                .read<DashboardBloc>()
                .add(GetHomeDataEvent(context: context));
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
                                initialValue: state.selectedCarCategoryId,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                ),
                                hint: const Text(
                                  "Choose vehicle",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                                items: state.carCategories!.data!.map((car) {
                                  return DropdownMenuItem<int>(
                                    value: car.id,
                                    child: Text(
                                      car.name ?? "Unknown",
                                      style: const TextStyle(
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
                  // containerShadow(
                  //   child: _buildTextField(
                  //     label: "Pickup Location",
                  //     controller: _pickupCtrl,
                  //     hint: "e.g. Ghaziabad",
                  //   ),
                  // ),
                  LocationAutocompleteField(
                    controller: _pickupCtrl,
                    hint: "Pickup Location",
                  ),
                  const SizedBox(height: 16),
                  LocationAutocompleteField(
                    controller: _dropCtrl,
                    hint: "Drop Location",
                  ),
                  const SizedBox(height: 16),
                  CommonTextFormField(
                    controller: noOfDays,
                    hintText: "No Of Days",
                  ),
                  const SizedBox(height: 16),
                  CommonTextFormField(
                    controller: tripNotes,
                    hintText: "Trip Notes",
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
                          controller: _totalFareCtrl,
                          hintText: "Total Fare",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: CommonTextFormField(
                        controller: _driverCommCtrl,
                        hintText: "Driver Commission",
                      )),
                      // Expanded(
                      //   child: containerShadow(
                      //     child: _buildNumberField(
                      //       label: "Driver Commission",
                      //       controller: _driverCommCtrl,
                      //     ),
                      //   ),
                      // ),
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
                      shadows: const [
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

                  // ── Extra Requirements Chips ───────────────────────────────────────
                  const Text("Extra Requirements",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 24),

                  // ── Remarks / Extra Requirements TextField ──────────────────
                  containerShadow(
                    height: 100,
                    child: TextField(
                      controller: _remarksCtrl,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: "Extra Requirements...",
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
                    text: "Post Booking",
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
                            if (noOfDays.text.trim().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "No Of Days is required");
                              return;
                            }
                            if (tripNotes.text.trim().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Trip Notes is required");
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
                              context: context,
                            );

                            context.read<AddBookingBloc>().add(booking);
                    },
                  ),



                  // ── Submit Button ───────────────────────────────────────────
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 54,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFFFFB900),
                  //       foregroundColor: Colors.black87,
                  //     ),
                  //     onPressed: state.isSubmitting
                  //         ? null
                  //         : () {
                  //       if (state.selectedCarCategoryId == null) {
                  //         Fluttertoast.showToast(
                  //             msg: "Please select vehicle category");
                  //         return;
                  //       }
                  //       if (_pickupCtrl.text.trim().isEmpty) {
                  //         Fluttertoast.showToast(
                  //             msg: "Pickup location is required");
                  //         return;
                  //       }
                  //       if (_dropCtrl.text.trim().isEmpty) {
                  //         Fluttertoast.showToast(
                  //             msg: "Drop location is required");
                  //         return;
                  //       }
                  //       if (_startDateCtrl.text.isEmpty) {
                  //         Fluttertoast.showToast(
                  //             msg: "Pickup date is required");
                  //         return;
                  //       }
                  //       if (_totalFareCtrl.text.trim().isEmpty) {
                  //         Fluttertoast.showToast(
                  //             msg: "Total fare is required");
                  //         return;
                  //       }
                  //
                  //       final booking = SubmitBooking(
                  //         subType: "1",
                  //         // hardcoded as per requirement
                  //         carCategoryId: state.selectedCarCategoryId!,
                  //         pickUpDate: _startDateCtrl.text,
                  //         pickUpTime: _startTimeCtrl.text,
                  //         pickUpLocations: [_pickupCtrl.text.trim()],
                  //         destinationLocations: [_dropCtrl.text.trim()],
                  //         totalFare:
                  //         double.tryParse(_totalFareCtrl.text) ?? 0.0,
                  //         driverCommission:
                  //         double.tryParse(_driverCommCtrl.text) ??
                  //             0.0,
                  //         showPhoneNumber: _showPhoneNumber,
                  //         remarks: _remarksCtrl.text.trim(),
                  //         context: context,
                  //       );
                  //
                  //       context.read<AddBookingBloc>().add(booking);
                  //     },
                  //     child: state.isSubmitting
                  //         ? const SizedBox(
                  //       height: 24,
                  //       width: 24,
                  //       child:
                  //       CircularProgressIndicator(strokeWidth: 2.5),
                  //     )
                  //         : const Text(
                  //       "SUBMIT BOOKING",
                  //       style: TextStyle(
                  //           fontSize: 16, fontWeight: FontWeight.w600),
                  //     ),
                  //   ),
                  // ),

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
            hintStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
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
            hintStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            suffixIcon: const Icon(Icons.access_time),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget containerShadow({required Widget child, double height = 50}) {
    return Container(
      // width: 333,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
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

  Widget _buildRequirementChip(String label) {
    bool isSelected = _selectedRequirements.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedRequirements.remove(label);
            _updateTextField(label, false);
          } else {
            _selectedRequirements.add(label);
            _updateTextField(label, true);
          }
        });
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
          initialValue: value,
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

  void showAssignDriverBottomSheet(BuildContext context) {
    String? selectedValue = "1";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: DiskIndicatorReplacement(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Booking posted Successfully",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Choose how you want to assign this booking",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildOption(
                    title: "Assign to All Drivers",
                    subtitle: "Broadcasting to all nearby available drivers",
                    value: "1",
                    selectedValue: selectedValue,
                    onChanged: (val) =>
                        setModalState(() => selectedValue = val),
                  ),
                  const SizedBox(height: 16),
                  _buildOption(
                    title: "Personal Booking",
                    subtitle: "Keep this booking for yourself",
                    value: "2",
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
                        backgroundColor: const Color(0xFFFCB117),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        context.read<AddBookingBloc>().add(
                              UpdateAssignMethodEvent(
                                context: context,
                                assignType: selectedValue.toString(),
                              ),
                            );

                        // Trigger refresh of dashboard data
                        context
                            .read<DashboardBloc>()
                            .add(GetHomeDataEvent(context: context));

                        // 1. Close the bottom sheet
                        Navigator.pop(context);

                        // 2. Navigate back to Home tab
                        if (widget.onBack != null) {
                          widget.onBack!();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Done",
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

  @override
  void dispose() {
    _remarksCtrl.removeListener(_onRemarksChanged);
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
