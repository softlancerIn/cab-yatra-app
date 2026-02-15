import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:cab_taxi_app/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ManageVehicleScreen extends StatefulWidget {
  const ManageVehicleScreen({super.key});

  @override
  State<ManageVehicleScreen> createState() =>
      _ManageVehicleScreenState();
}

class _ManageVehicleScreenState
    extends State<ManageVehicleScreen> {

  List<Map<String, String>> vehicles = [
    {
      "name": "Sedan",
      "number": "UH14HP9876",
      "year": "2025",
    },
    {
      "name": "Sedan",
      "number": "UH14HP9876",
      "year": "2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Manage Vehicles",
      ),
      backgroundColor: const Color(0xFFF4F4F4),

      body: ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        itemCount: vehicles.length,
        separatorBuilder: (context, index) =>
        const Divider(height: 1, thickness: 1),
        itemBuilder: (context, index) {

          final vehicle = vehicles[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),

            leading: const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.directions_car,
                color: Color(0xFFFFB100),
                size: 28,
              ),
            ),

            title: Text(
              vehicle['name']!,
              style: const TextStyle(
                  fontWeight: FontWeight.w600),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle['number']!,
                  style:
                  const TextStyle(color: Colors.grey),
                ),
                Text(
                  vehicle['year']!,
                  style:
                  const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            trailing: GestureDetector(
              onTap: () {
                setState(() {
                  vehicles.removeAt(index);
                });
              },
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black,
                child: Icon(Icons.close,
                    color: Colors.white, size: 14),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFB100),
        onPressed: () {
          // Add vehicle logic here
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
