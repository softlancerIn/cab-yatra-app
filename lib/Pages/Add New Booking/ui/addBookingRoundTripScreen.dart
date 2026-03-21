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
  }

  void _updateTextField(String label, bool isAdding) {
    // Chips are managed separately, no need to update text field
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      //  appBar: AppBAR(title: "Add New Booking"),
      body: BlocConsumer<AddBookingBloc, AddBookingState>(
        listenWhen: (previous, current) {
          return previous.isSuccess != current.isSuccess ||
              previous.hasError != current.hasError;
        },
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
            final bookingId = state.bookingResponse!.bookingId!;
            // Reset success state to prevent re-triggering
            context.read<AddBookingBloc>().add(ResetBooking());
            showAssignDriverBottomSheet(context, bookingId);
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
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 12),

                  state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.carCategories == null ||
                              state.carCategories!.data!.isEmpty
                          ? const Text("No categories available",
                              style: TextStyle(color: Colors.red))
                          : SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.carCategories!.data!.length,
                                itemBuilder: (context, index) {
                                  final car = state.carCategories!.data![index];
                                  final isSelected = state.selectedCarCategoryId == car.id;
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<AddBookingBloc>().add(SelectCarCategory(car.id!));
                                    },
                                    child: Container(
                                      width: 100,
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFFFB300).withOpacity(0.1) : Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFFFFB300) : Colors.grey.shade200,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/carMO.png",
                                            height: 35,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            car.name ?? "",
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              height: 1.1,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              color: isSelected ? const Color(0xFFFFB300) : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
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
                  const SizedBox(height: 32),

                  LocationAutocompleteField(
                    controller: _pickupCtrl,
                    hint: "Enter Pickup Location",
                  ),
                  
                  // LocationAutocompleteField(
                  //   controller: _dropCtrl,
                  //   hint: "Enter Drop Location",
                  // ),

                  const SizedBox(height: 20),
                  CommonTextFormField(
                    controller: noOfDays,
                    hintText: "No Of Days",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  CommonTextFormField(
                    controller: tripNotes,
                    hintText: "Trip Notes",
                    maxLines: 5,
                    height: 100,
                  ),
                  const SizedBox(height: 20),

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
                        keyboardType: TextInputType.number,
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
                    height: 50,
                    child: TextField(
                      controller: _remarksCtrl,
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
                              noOfDay: noOfDays.text.trim(),
                              tripNotes: tripNotes.text.trim(),
                              carCategoryId: state.selectedCarCategoryId!,
                              pickUpDate: _startDateCtrl.text,
                              pickUpTime: _startTimeCtrl.text,
                              pickUpLocations: [_pickupCtrl.text.trim()],
                              destinationLocations: [tripNotes.text.trim()],
                              totalFare:
                              double.tryParse(_totalFareCtrl.text) ?? 0.0,
                              driverCommission:
                              double.tryParse(_driverCommCtrl.text) ?? 0.0,
                              showPhoneNumber: _showPhoneNumber,
                              remarks: [..._selectedRequirements, if (_remarksCtrl.text.trim().isNotEmpty) _remarksCtrl.text.trim()].join(', '),
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

  void showAssignDriverBottomSheet(BuildContext parentContext, int bookingId) {
    String? selectedValue = "0";

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return BlocConsumer<AddBookingBloc, AddBookingState>(
              listenWhen: (previous, current) {
                return previous.updateAssignMethodModel != current.updateAssignMethodModel;
              },
              listener: (context, state) {
                if (state.updateAssignMethodModel != null) {
                  Fluttertoast.showToast(msg: "Booking assigned successfully!");
                  // Clear the form
                  _pickupCtrl.clear();
                  _dropCtrl.clear();
                  _startDateCtrl.clear();
                  _startTimeCtrl.clear();
                  _totalFareCtrl.clear();
                  _driverCommCtrl.clear();
                  _remarksCtrl.clear();
                  noOfDays.clear();
                  tripNotes.clear();
                  _selectedRequirements.clear();
                  _showPhoneNumber = false;
                  // Reset bloc state
                  context.read<AddBookingBloc>().add(ResetBooking());
                  Navigator.pop(modalContext); // Close bottom sheet
                  // Navigate to home page
                  if (widget.onBack != null) {
                    widget.onBack!();
                  }
                }
              },
              builder: (context, state) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: DiskIndicatorReplacement()),
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
                        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                      ),
                      if (state.hasError) ...[
                        const SizedBox(height: 12),
                        Text(
                          state.errorMessage ?? "An error occurred",
                          style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildOption(
                        title: "Direct Assign",
                        subtitle: "Auto assign to the first available driver",
                        value: "0",
                        selectedValue: selectedValue,
                        onChanged: (val) => setModalState(() => selectedValue = val),
                      ),
                      const SizedBox(height: 16),
                      _buildOption(
                        title: "Manual Selection",
                        subtitle: "Choose your preferred driver manually",
                        value: "1",
                        selectedValue: selectedValue,
                        onChanged: (val) => setModalState(() => selectedValue = val),
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
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  context.read<AddBookingBloc>().add(
                                        UpdateAssignMethodEvent(
                                          context: context,
                                          assignType: selectedValue.toString(),
                                          bookingId: bookingId,
                                        ),
                                      );

                                  // Trigger refresh of dashboard data
                                  context
                                      .read<DashboardBloc>()
                                  .add(GetHomeDataEvent(context: context));
                                },
                          child: state.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
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
                      if (state.hasError)
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel & Close"),
                          ),
                        ),
                    ],
                  ),
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
