import 'package:flutter/material.dart';

class DriverCard extends StatelessWidget {
  final String driverName;
  final String vehicleInfo;
  final String? imageUrl;
  final VoidCallback? onCallPressed;

  const DriverCard({
    super.key,
    required this.driverName,
    required this.vehicleInfo,
    this.imageUrl,
    this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Driver Image
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
              child: imageUrl == null
                  ? const Icon(Icons.person, size: 35, color: Colors.blue)
                  : null,
            ),
            const SizedBox(width: 16),

            // Driver Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    driverName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vehicleInfo,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14
                    ),
                  ),
                ],
              ),
            ),

            // Call Button
            IconButton(
              onPressed: onCallPressed,
              icon: const Icon(Icons.call, color: Colors.green, size: 28),
              style: IconButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}