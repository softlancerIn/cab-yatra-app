import 'package:equatable/equatable.dart';
import 'dart:io';
class PersonalInfoState extends Equatable {
  final String name;
  final String company;
  final String phone;
  final String licenseNumber;
  final String licenseNumber2;
  final String type;
  final File? image;
  final String? networkImage;
  final String rating;
  final String ratingCount;
  final bool isSubmitting;
  final bool isLoading;

  const PersonalInfoState({
    this.name = 'Name',
    this.company = 'Remark',
    this.phone = '11111111',
    this.type = 'agent',
    this.licenseNumber2="Licence Number (optional)",
    this.licenseNumber="Licence Number (optional)",
    this.image,
    this.networkImage,
    this.rating = '0.0',
    this.ratingCount = '0',
    this.isSubmitting = false,
    this.isLoading = false,
  });

  PersonalInfoState copyWith({
    String? name,
    String? company,
    String? phone,
    String? licenseNumber,
    String? licenseNumber2,
    String? type,
    File? image,
    String? networkImage,
    String? rating,
    String? ratingCount,
    bool? isSubmitting,
    bool? isLoading,
  }) {
    return PersonalInfoState(
      name: name ?? this.name,
      company: company ?? this.company,
      type: type ?? this.type,
      image: image ?? this.image,
      networkImage: networkImage ?? this.networkImage,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoading: isLoading ?? this.isLoading,
        phone: phone ?? this.phone,
      licenseNumber2: licenseNumber2??this.licenseNumber2,
      licenseNumber: licenseNumber??this.licenseNumber
    );
  }

  @override
  List<Object?> get props =>
      [name, company, type, image, networkImage, rating, ratingCount, isSubmitting, isLoading,licenseNumber,licenseNumber2];
}
