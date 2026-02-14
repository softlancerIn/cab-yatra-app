import 'package:flutter/material.dart';

class AllReviewsPage extends StatelessWidget {
  const AllReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Reviews"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Replace with API review count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/images/driver_upload_logo.png",
                ),
              ),
              title: Text("User ${index + 1}"),
              subtitle: const Text(
                  "Great driving experience. Very professional and polite."),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 4),
                  Text("5.0"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
