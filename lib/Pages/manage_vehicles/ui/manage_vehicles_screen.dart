
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Custom_Widgets/custom_app_bar.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';
import 'add_vehicle_bottom_sheet.dart';

class ManageVehiclesScreen extends StatefulWidget {
  const ManageVehiclesScreen({super.key});

  @override
  State<ManageVehiclesScreen> createState() => _ManageVehiclesScreenState();
}

class _ManageVehiclesScreenState extends State<ManageVehiclesScreen> {

  @override
  void initState() {
    super.initState();

    context.read<VehicleBloc>().add(LoadVehicles());
    context.read<VehicleBloc>().add(LoadCarCategories(context));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const AppBAR(
        title: "Manage Vehicle",
        showLeading: true,
        showAction: false,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 35),
        onPressed: () => _openAddVehicleBottomSheet(context),
      ),

      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {

          /// LOADING
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// EMPTY
          if (state.vehicles.isEmpty) {
            return const Center(
              child: Text(
                "No vehicles added yet.",
                style: TextStyle(fontFamily: "Poppins"),
              ),
            );
          }

          /// VEHICLE LIST
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.vehicles.length,
            itemBuilder: (context, index) {

              final vehicle = state.vehicles[index];

              /// Resolve category name
              String displayType = vehicle.vehicleType;

              if (displayType.startsWith("Category ID:") &&
                  state.carCategories?.data != null) {

                final idStr =
                displayType.replaceAll("Category ID:", "").trim();

                try {

                  final category = state.carCategories!.data!
                      .firstWhere((c) => c.id.toString() == idStr);

                  displayType = category.name ?? displayType;

                } catch (_) {}
              }

              return Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [

                        /// VEHICLE IMAGE
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: (vehicle.image?.isNotEmpty ?? false)
                                ? Image.network(
                              vehicle.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Image.asset(
                                    "assets/images/manageVahical.png",
                                    width: 40,
                                  ),
                            )
                                : Image.asset(
                              "assets/images/manageVahical.png",
                              width: 40,
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        /// VEHICLE INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              /// VEHICLE TYPE
                              Text(
                                displayType,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF333333),
                                ),
                              ),

                              /// REGISTRATION NUMBER
                              Text(
                                vehicle.vehicleNumber,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontFamily: 'Poppins',
                                ),
                              ),

                              /// YEAR
                              Text(
                                vehicle.vehicleYear,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// DELETE BUTTON
                        GestureDetector(
                          onTap: () {
                            _showDeleteConfirmation(
                              context,
                              vehicle.id,
                              displayType,
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey.shade200,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// DELETE CONFIRMATION
  void _showDeleteConfirmation(
      BuildContext context, int id, String type) {

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text(
            "Delete Vehicle",
            style: TextStyle(fontFamily: 'Poppins'),
          ),

          content: Text(
            "Are you sure you want to remove this $type?",
            style: const TextStyle(fontFamily: 'Poppins'),
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                context.read<VehicleBloc>().add(DeleteVehicle(id));
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ADD VEHICLE BOTTOM SHEET
  void _openAddVehicleBottomSheet(BuildContext context) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {

        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) {

            return const AddVehicleBottomSheet();
          },
        );
      },
    );
  }
}