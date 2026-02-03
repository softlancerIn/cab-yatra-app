import 'package:flutter/material.dart';

class ApplyFilterDialog extends StatelessWidget {
  const ApplyFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Title
            Center(
              child: Text(
                "Apply Filter",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Select Vehicle
            _label("Select vehical"),
            _dropdownField(
              title: "Select Vehicle",
              onTap: () {
                // Vehicle select logic
              },
            ),

            const SizedBox(height: 16),

            /// Pickup Location
            _label("Pickup Location"),
            _inputField(
              hint: "Add",
              onTap: () {
                // Pickup location logic
              },
            ),

            const SizedBox(height: 16),

            /// Drop Location
            _label("Drop Location"),
            _inputField(
              hint: "Add",
              onTap: () {
                // Drop location logic
              },
            ),

            const SizedBox(height: 24),

            /// Buttons
            Row(
              children: [

                /// Clear Filter
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E4959),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // clear filter logic
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Clear Filter",
                        style: TextStyle(fontSize: 14,color: Colors.white,),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// Done
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // APPLY FILTER LOGIC HERE
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Label widget
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Dropdown field
  Widget _dropdownField({required String title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black54),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  /// Input field
  Widget _inputField({required String hint, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          hint,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
