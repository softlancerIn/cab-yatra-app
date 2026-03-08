import 'package:equatable/equatable.dart';
import 'dart:io';

import '../model/getTransectionModel.dart';
class TransectionsState extends Equatable {

  final bool isSubmitting;
  final bool isLoading;
  final GetTransectionModel?getTransectionModel;

  const TransectionsState({

    this.isSubmitting = false,
    this.isLoading = false,
    this.getTransectionModel
  });

  TransectionsState copyWith({

    bool? isSubmitting,
    bool? isLoading,
    GetTransectionModel?getTransectionModel,
  }) {
    return TransectionsState(

      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoading: isLoading ?? this.isLoading,
      getTransectionModel: getTransectionModel ?? this.getTransectionModel,

    );
  }

  @override
  List<Object?> get props =>
      [isSubmitting, isLoading,getTransectionModel];
}
