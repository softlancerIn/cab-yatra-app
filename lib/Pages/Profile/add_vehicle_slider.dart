import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddVehicleSlider extends StatefulWidget {
  const AddVehicleSlider({super.key});

  @override
  State<AddVehicleSlider> createState() =>
      _AddVehicleSliderState();
}

class _AddVehicleSliderState
    extends State<AddVehicleSlider> {

  File? insuranceImage;
  File? rcFront;
  File? rcBack;
  File? carImage1;
  File? carImage2;

  final picker = ImagePicker();

  Future<void> pickImage(
      Function(File) onPicked) async {

    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (picked != null) {
      onPicked(File(picked.path));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          /// Header
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                "Add Car",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              IconButton(
                onPressed: () =>
                    Navigator.pop(context),
                icon: const Icon(Icons.close),
              )
            ],
          ),

          const SizedBox(height: 10),

          _field("Vehicle Type"),

          const SizedBox(height: 10),

          _field("Year Of Manufacture"),

          const SizedBox(height: 10),

          _field("Car Registration Number"),

          const SizedBox(height: 15),

          const Text("Upload Insurance"),

          const SizedBox(height: 8),

          GestureDetector(
            onTap: () =>
                pickImage((file) =>
                insuranceImage = file),
            child: _imageBox(
                insuranceImage,
                "+ Upload Insurance"),
          ),

          const SizedBox(height: 15),

          const Text("RC Front & Back"),

          const SizedBox(height: 8),

          Row(
            children: [

              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      pickImage((file) =>
                      rcFront = file),
                  child: _imageBox(
                      rcFront,
                      "+ RC Front"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      pickImage((file) =>
                      rcBack = file),
                  child:
                  _imageBox(rcBack, "+ RC Back"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Text("Vehicle Images"),

          const SizedBox(height: 8),

          Row(
            children: [

              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      pickImage((file) =>
                      carImage1 = file),
                  child: _imageBox(
                      carImage1,
                      "+ Car Image"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      pickImage((file) =>
                      carImage2 = file),
                  child: _imageBox(
                      carImage2,
                      "+ Car Image"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFFFFB100),
              ),
              onPressed: () {},
              child: const Text("Add +"),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _field(String hint) {

    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _imageBox(File? file, String text) {

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
            color: Colors.grey.shade300),
      ),
      child: file == null
          ? Center(child: Text(text))
          : ClipRRect(
        borderRadius:
        BorderRadius.circular(10),
        child: Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
