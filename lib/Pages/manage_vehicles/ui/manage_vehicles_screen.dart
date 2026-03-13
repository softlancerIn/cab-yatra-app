import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mange Vehicle",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        onPressed: () {
          _openAddVehicleBottomSheet(context);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 35),
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.vehicles.isEmpty) {
            return const Center(child: Text("No vehicles added yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = state.vehicles[index];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Center(
                            child: (vehicle.image != null && vehicle.image!.isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Image.network(vehicle.image!,
                                        fit: BoxFit.contain, width: 50, height: 50),
                                  )
                                : Image.asset('assets/images/manageVahical.png', width: 40),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicle.vehicleType,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Text(
                                vehicle.vehicleNumber,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                vehicle.vehicleYear,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showDeleteConfirmation(context, vehicle.id, vehicle.vehicleType);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(Icons.close, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int id, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Vehicle", style: TextStyle(fontFamily: 'Poppins')),
        content: Text("Are you sure you want to remove this $type?",
            style: const TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          TextButton(
            onPressed: () {
              context.read<VehicleBloc>().add(DeleteVehicle(id));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red, fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

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
            builder: (context, scrollController) {
              return const AddVehicleBottomSheet();
            });
      },
    );
  }
}
