import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/driverBloc.dart';
import '../bloc/driverState.dart';
import '../bloc/submitDriver.dart';
import 'addDriverScreen.dart';

class ManageDriversScreen extends StatefulWidget {
  const ManageDriversScreen({super.key});

  @override
  State<ManageDriversScreen> createState() => _ManageDriversScreenState();
}

class _ManageDriversScreenState extends State<ManageDriversScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DriverBloc>().add(LoadDrivers());
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
          "Mange Drivers",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child:
              Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        onPressed: () {
          _openAddDriverBottomSheet(context);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 35),
      ),
      body: BlocBuilder<DriverBloc, DriverState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.drivers.isEmpty) {
            return const Center(child: Text("No drivers added yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.drivers.length,
            itemBuilder: (context, index) {
              final driver = state.drivers[index];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              (driver.image != null && driver.image!.isNotEmpty)
                                  ? NetworkImage(driver.image!)
                                  : null,
                          child: (driver.image == null || driver.image!.isEmpty)
                              ? const Icon(Icons.person,
                                  size: 35, color: Colors.grey)
                              : null,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Text(
                                driver.city,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                driver.phone,
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
                            _showDeleteConfirmation(
                                context, driver.id, driver.name);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 1, thickness: 0.5, color: Colors.grey.shade200),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Driver",
            style: TextStyle(fontFamily: 'Poppins')),
        content: Text("Are you sure you want to remove $name?",
            style: const TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
          TextButton(
            onPressed: () {
              context.read<DriverBloc>().add(DeleteDriver(id));
              Navigator.pop(context);
            },
            child: const Text("Delete",
                style: TextStyle(color: Colors.red, fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  void _openAddDriverBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
            initialChildSize: 0.9, // 👈 70% se start
            minChildSize: 0.4,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return const AddDriverBottomSheet();
            });
      },
    );
  }
}
