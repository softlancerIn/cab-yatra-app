import 'package:cab_taxi_app/Pages/Custom_Widgets/custom_app_bar.dart';
import 'package:cab_taxi_app/widget/primary_button.dart';
import 'package:flutter/material.dart';

class ManageDriversScreen extends StatefulWidget {
  const ManageDriversScreen({super.key});

  @override
  State<ManageDriversScreen> createState() =>
      _ManageDriversScreenState();
}

class _ManageDriversScreenState
    extends State<ManageDriversScreen> {

  List<Map<String, String>> drivers = [
    {
      "name": "Raju Kumar",
      "city": "Noida",
      "phone": "8989989898"
    },
    {
      "name": "Raju Kumar",
      "city": "Noida",
      "phone": "8989989898"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Manage Drivers",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF4F4F4),

      body: ListView.separated(
        itemCount: drivers.length,
        separatorBuilder: (context, index) =>
        const Divider(height: 1, thickness: 1),
        itemBuilder: (context, index) {

          final driver = drivers[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),

            leading: const CircleAvatar(
              radius: 28,
              backgroundImage:
              AssetImage('assets/images/profile_image.png'),
            ),

            title: Text(
              driver['name']!,
              style: const TextStyle(
                  fontWeight: FontWeight.w600),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver['city']!,
                  style:
                  const TextStyle(color: Colors.grey),
                ),
                Text(
                  driver['phone']!,
                  style:
                  const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            trailing: GestureDetector(
              onTap: () {
                setState(() {
                  drivers.removeAt(index);
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

      /// Floating Add Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: 'Add Driver',
          onPressed: () {
            // Add driver logic here
          },
        ),
      ),
    );
  }
}