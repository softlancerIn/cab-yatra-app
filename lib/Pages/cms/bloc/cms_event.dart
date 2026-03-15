import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CmsEvent extends Equatable {
  const CmsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCms extends CmsEvent {
  final BuildContext context;

  const LoadCms(this.context);

  @override
  List<Object?> get props => [context];
}