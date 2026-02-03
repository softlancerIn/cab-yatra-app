import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class DriverImagePickerController extends GetxController {
  var selectedImagePath = ''.obs;

  var selectedImages = <String, String>{
    'aadhar_frontImage': '',
    'aadhar_backImage': '',
    'dl_image': '',
    'driver_image': '',
    'car_image': '',
    'car_rc_frontImage': '',
    'car_rc_backImage': '',
    'insurence_image': '',
  }.obs;

  // Future<void> pickImage(ImageSource source) async {
  //   // Check permissions before opening camera/gallery
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: source);
  //   if (image != null) {
  //     selectedImagePath.value = image.path;
  //   } else {
  //     selectedImagePath.value = '';
  //   }
  //   // if (await _checkPermissions()) {
  //   //
  //   // }
  // }

  Future<void> pickImage(String fieldName, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      selectedImages[fieldName] = image.path;
    } else {
      selectedImages[fieldName] = '';
    }
    selectedImages.refresh();
  }

  Future<bool> _checkPermissions() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
      if (!status.isGranted) {
        return false;
      }
    }

    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        return false;
      }
    }

    return true;
  }
}
