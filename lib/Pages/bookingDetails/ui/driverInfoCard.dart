import 'package:flutter/material.dart';

class DriverInfoCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String subtitle;
  final double rating;
  final int reviewCount;

  const DriverInfoCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xADEFEFEF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          /// Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imagePath,
              height: 64,
              width: 64,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          /// Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                /// Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 8),

                /// Rating Row
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        size: 18,
                        color: index < rating.round()
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '($reviewCount review)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
