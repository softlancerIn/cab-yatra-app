import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Custom_Widgets/custom_app_bar.dart';
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
      backgroundColor: const Color(0xffffffff),
      appBar: const AppBAR(
        title: "Manage Drivers",
        customShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
        showLeading: true,
        showAction: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          _openAddDriverBottomSheet(context);
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: BlocBuilder<DriverBloc, DriverState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.drivers.length,
            separatorBuilder: (_, __) => Divider(color: Colors.grey.shade400),
            itemBuilder: (context, index) {
              final driver = state.drivers[index];

              return GestureDetector(
                onTap: () {
                  print(driver.name);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: driver.image != null && driver.image!.isNotEmpty
                          ? NetworkImage(driver.image!)
                          : null,
                      child: driver.image == null || driver.image!.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),

                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driver.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text(driver.city,
                              style: TextStyle(color: Colors.grey.shade600)),
                          Text(driver.phone,
                              style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    //Delete Button
                    GestureDetector(
                      onTap:(){
                        print("Delete Driver");
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, color: Colors.white, size: 15),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
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
