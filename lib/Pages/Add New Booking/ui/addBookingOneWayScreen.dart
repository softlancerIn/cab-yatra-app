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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              textColor: Colors.white,
            );
            final bookingId = state.bookingResponse!.bookingId!;
            // Reset success state to prevent re-triggering
            context.read<AddBookingBloc>().add(ResetBooking());
            showAssignDriverBottomSheet(context, bookingId);
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

                  const SizedBox(height: 32),

                  LocationAutocompleteField(
                    controller: _pickupCtrl,
                    hint: "Enter Pickup Location",
                  ),
                  const SizedBox(height: 20),
                  LocationAutocompleteField(
                    controller: _dropCtrl,
                    hint: "Enter Drop Location",
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
                              subType: "1",
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
                              remarks: [..._selectedRequirements, if (_remarksCtrl.text.trim().isNotEmpty) _remarksCtrl.text.trim()].join(', '),
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
          color: isSelected ? const Color(0xFFFFB300) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFB300) : Colors.grey.shade300,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
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
    // Chips are managed separately, no need to update text field
    setState(() {});
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

  void showAssignDriverBottomSheet(BuildContext parentContext, int bookingId) {
    int selectedValue = 0;

    showModalBottomSheet(
      context: parentContext,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setState) {
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
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
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
                      const Icon(Icons.check_circle_rounded, size: 80, color: Color(0xFFFFB300)),
                      const SizedBox(height: 16),
                      const Text(
                        "Booking Posted!",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "How would you like to assign this booking?",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      if (state.hasError) ...[
                        const SizedBox(height: 12),
                        Text(
                          state.errorMessage ?? "An error occurred",
                          style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildAssignOption(
                        title: "Direct Assign",
                        subtitle: "Auto assign to the first available driver",
                        icon: Icons.flash_on,
                        isSelected: selectedValue == 0,
                        onTap: () => setState(() => selectedValue = 0),
                      ),
                      const SizedBox(height: 12),
                      _buildAssignOption(
                        title: "Manual Selection",
                        subtitle: "Choose your favorite driver personally",
                        icon: Icons.person_search,
                        isSelected: selectedValue == 1,
                        onTap: () => setState(() => selectedValue = 1),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
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
                                  context.read<AddBookingBloc>().add(
                                        UpdateAssignMethodEvent(
                                          context: context,
                                          assignType: selectedValue.toString(),
                                          bookingId: bookingId,
                                        ),
                                      );

                                  context.read<DashboardBloc>().add(GetHomeDataEvent(context: context));
                                },
                          child: state.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Confirm Selection",
                                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (state.hasError)
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel & Close"),
                          ),
                        ),
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

  Widget _buildAssignOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFB300).withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFB300) : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFFFB300) : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFFFFB300))
            else
              const Icon(Icons.circle_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

