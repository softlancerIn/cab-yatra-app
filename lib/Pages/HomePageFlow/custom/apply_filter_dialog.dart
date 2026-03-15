import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/dashboard/bloc/dashboard_bloc.dart';
import 'package:cab_taxi_app/Pages/HomePageFlow/custom/location_autocomplete_field.dart';

class ApplyFilterDialog extends StatefulWidget {
  const ApplyFilterDialog({super.key});

  @override
  State<ApplyFilterDialog> createState() => _ApplyFilterDialogState();
}

class _ApplyFilterDialogState extends State<ApplyFilterDialog> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  String? _selectedVehicle;

  final List<String> _vehicles = [
    'hatchback',
    'Sedan',
    'SUV',
    'Innova',
    'Traveller'
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<DashboardBloc>().state;
    _pickupController.text = state.pickupLocationFilter ?? '';
    _dropController.text = state.dropLocationFilter ?? '';
    _selectedVehicle = state.selectedVehicleType;
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              const Center(
                child: Text(
                  "Apply Filter",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Select Vehicle
              _label("Select vehical"),
              _dropdownField(
                title: _selectedVehicle ?? "Select Vehicle",
                onTap: () {
                  _showVehiclePicker();
                },
              ),

              const SizedBox(height: 16),

              /// Pickup Location
              _label("Pickup Location"),
              LocationAutocompleteField(
                controller: _pickupController,
                hint: "Add Pickup Location",
              ),

              const SizedBox(height: 16),

              /// Drop Location
              _label("Drop Location"),
              LocationAutocompleteField(
                controller: _dropController,
                hint: "Add Drop Location",
              ),

              const SizedBox(height: 24),

              /// Buttons
              Row(
                children: [
                  /// Clear Filter
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF3E4959)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context
                              .read<DashboardBloc>()
                              .add(const ClearFilterEvent());
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Clear Filter",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3E4959),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Done
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<DashboardBloc>().add(UpdateFilterEvent(
                                vehicleType: _selectedVehicle,
                                pickupLocation: _pickupController.text.isEmpty
                                    ? null
                                    : _pickupController.text,
                                dropLocation: _dropController.text.isEmpty
                                    ? null
                                    : _dropController.text,
                              ));
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVehiclePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Vehicle Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ..._vehicles.map((v) => ListTile(
                    title: Text(v),
                    onTap: () {
                      setState(() {
                        _selectedVehicle = v;
                      });
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  /// Label widget
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Dropdown field
  Widget _dropdownField({required String title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black54),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  /// Input field
  Widget _inputField(
      {required TextEditingController controller, required String hint}) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
