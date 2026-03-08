import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class DriverImageProvider extends ChangeNotifier {
  File? dlFront;
  File? dlBack;
  File? aadharFront;
  File? aadharBack;

  Future<void> pickImage(Function(File) onPicked) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      onPicked(File(picked.path));
      notifyListeners();
    }
  }
}
