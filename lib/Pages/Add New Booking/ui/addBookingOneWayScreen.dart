import 'package:cab_taxi_app/widget/customTextField.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/custom/location_autocomplete_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../bloc/addBookingBloc.dart';
import '../bloc/addBookingEvent.dart';
import '../bloc/addBookingState.dart';
import '../../HomePageFlow/dashboard/bloc/dashboard_bloc.dart';

class AddBookingOneWayScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const AddBookingOneWayScreen({super.key, this.onBack});

  @override
  State<AddBookingOneWayScreen> createState() => _AddBookingOneWayScreenState();
}

class _AddBookingOneWayScreenState extends State<AddBookingOneWayScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBookingBloc()..add(LoadCarCategories(context)),
      child: _AddBookingOneWayScreenView(onBack: widget.onBack),
    );
  }
}

class _AddBookingOneWayScreenView extends StatefulWidget {
  final VoidCallback? onBack;
  const _AddBookingOneWayScreenView({this.onBack});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AddBookingBloc, AddBookingState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Fluttertoast.showToast(
              msg: "Booking created successfully!",
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            showAssignDriverBottomSheet(context);
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

                  LocationAutocompleteField(
                    controller: _pickupCtrl,
                    hint: "Pickup Location",
                  ),
                  const SizedBox(height: 16),
                  LocationAutocompleteField(
                    controller: _dropCtrl,
                    hint: "Drop Location",
                  ),

                  const SizedBox(height: 24),

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

                  Row(
                    children: [
                      Expanded(
                        child: CommonTextFormField(
                          hintText: "Total Fare",
                          controller: _totalFareCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CommonTextFormField(
                          hintText: "Driver Commission",
                          controller: _driverCommCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
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

                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        },
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
      height: height,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 12),
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

  void _updateTextField(String label, bool isAdding) {
    String currentText = _remarksCtrl.text.trim();
    List<String> parts = currentText
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (isAdding) {
      bool exists = parts.any((e) => e.toLowerCase() == label.toLowerCase());
      if (!exists) {
        parts.insert(0, label);
      }
    } else {
      parts.removeWhere((e) => e.toLowerCase() == label.toLowerCase());
    }

    _remarksCtrl.text = parts.join(", ");
    _remarksCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: _remarksCtrl.text.length),
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
                  const Icon(Icons.check_circle, size: 70, color: Colors.orange),
                  const SizedBox(height: 10),
                  const Text(
                    "Booking posted Successfully",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

                        context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));

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
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
