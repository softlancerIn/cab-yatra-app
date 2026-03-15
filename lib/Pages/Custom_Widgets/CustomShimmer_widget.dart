import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerContainer extends StatelessWidget {
  final double width;
  final double height;

  const CustomShimmerContainer(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      // Base shimmer color
      highlightColor: Colors.white,
      // Highlight shimmer color
      direction: ShimmerDirection.ltr,
      // Shimmer direction (left to right)
      period: const Duration(seconds: 1),
      // Shimmer speed
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width, // Width set to 15
          height: height, // Height set to 15
          decoration: BoxDecoration(
            color: Colors.grey[300], // Background color of the container
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
        ),
      ),
    );
  }
}
