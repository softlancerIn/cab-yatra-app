import 'package:equatable/equatable.dart';


import 'package:flutter/cupertino.dart';

abstract class TransectionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}






class LoadTransections extends TransectionsEvent {
  final BuildContext context;
  LoadTransections(this.context);

  @override
  List<Object?> get props => [context];
}
