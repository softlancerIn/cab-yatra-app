import 'package:cab_taxi_app/Pages/HomePageFlow/custom/location_autocomplete_field.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:cab_taxi_app/cores/utils/helperFunctions.dart';
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
  final VoidCallback? onSuccess;
  const AddBookingRoundTripScreen({super.key, this.onBack, this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBookingBloc()..add(LoadCarCategories(context)),
      child: _AddBookingRoundTripScreenView(onBack: onBack, onSuccess: onSuccess),
    );
  }
}

class _AddBookingRoundTripScreenView extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSuccess;
  const _AddBookingRoundTripScreenView({this.onBack, this.onSuccess});

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
  final Set<String> _selectedRequirements = {}; // chip selections (independent)

  String _getCityName(String address) {
    if (address.isEmpty) return "";
    List<String> parts = address.split(',');
    if (parts.length >= 3) {
      return parts[parts.length - 3].trim();
    } else if (parts.isNotEmpty) {
      return parts[0].trim();
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    _clearForm();
  }

  void _clearForm() {
    _startDateCtrl.clear();
    _startTimeCtrl.clear();
    _pickupCtrl.clear();
    _dropCtrl.clear();
    noOfDays.clear();
    tripNotes.clear();
    _totalFareCtrl.clear();
    _driverCommCtrl.clear();
    _remarksCtrl.clear();
    _selectedRequirements.clear();
    _showPhoneNumber = false;
    if (mounted) setState(() {});
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, top: 8.0), // Reduced from 12/8
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
              _clearForm();
              context.read<AddBookingBloc>().add(LoadCarCategories(context));
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
                                      context.read<AddBookingBloc>().add(SelectCarCategory(val));
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
                    hint: "Enter Pickup location",
                  ),

                  const SizedBox(height: 8),
                  
                  _label("Number of days"),
                  CommonTextFormField(
                    controller: noOfDays,
                    hintText: "0",
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 8),
                  
                  _label("Enter Trip Note"),
                  CommonTextFormField(
                    controller: tripNotes,
                    hintText: "Fill details of your tour...",
                    maxLines: 5,
                    height: 120, // Increased for multiline as per Figma
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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

                  const SizedBox(height: 16),

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
                  StatefulBuilder(
                    builder: (context, setChipState) {
                      final requirements = ["Only Diesel", "With Carrier", "All Inclusive", "All Exclusive"];
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3.5,
                        ),
                        itemCount: requirements.length,
                        itemBuilder: (context, index) {
                          return _buildRequirementChip(requirements[index], setChipState);
                        },
                      );
                    },
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
                    text: "Post Booking",
                    onPressed: state.isSubmitting
                        ? null
                        : () async {
                            // Check payment details first
                            final bool hasPaymentDetails =
                                await HelperFunctions.validatePaymentDetails(
                                    context);
                            if (!hasPaymentDetails) return;

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

                             double totalAmountValue = double.tryParse(_totalFareCtrl.text) ?? 0.0;
                             double commissionValue = double.tryParse(_driverCommCtrl.text) ?? 0.0;
                             if (commissionValue >= totalAmountValue && totalAmountValue > 0) {
                               Fluttertoast.showToast(
                                   msg: "Commission must be less than Total amount");
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
                               destinationLocations: [tripNotes.text.trim()], // Sending trip notes as the destination for Round Trips
                               pickupCity: [_getCityName(_pickupCtrl.text.trim())],
                               destinationCity: [tripNotes.text.trim()],
                               totalFare:
                               double.tryParse(_totalFareCtrl.text) ?? 0.0,
                               driverCommission:
                               double.tryParse(_driverCommCtrl.text) ?? 0.0,
                               showPhoneNumber: _showPhoneNumber,
                               extra: _selectedRequirements.toList(),
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

  Widget _buildRequirementChip(String label, StateSetter setChipState) {
    bool isSelected = _selectedRequirements.contains(label);

    return GestureDetector(
      onTap: () {
        setChipState(() {
          if (isSelected) {
            _selectedRequirements.remove(label);
          } else {
            _selectedRequirements.add(label);
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
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
                  _showPhoneNumber = false;
                  // Reset bloc state
                  context.read<AddBookingBloc>().add(ResetBooking());
                  Navigator.pop(modalContext); // Close bottom sheet
                  // Navigate to Posted Booking page
                  if (widget.onSuccess != null) {
                    widget.onSuccess!();
                  } else if (widget.onBack != null) {
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
