import 'package:equatable/equatable.dart';
import '../model/cmsModel.dart';

class CmsState extends Equatable {

  final bool isLoading;
  final CmsModel? cms;
  final String? error;

  const CmsState({
    this.isLoading = false,
    this.cms,
    this.error,
  });

  CmsState copyWith({
    bool? isLoading,
    CmsModel? cms,
    String? error,
  }) {
    return CmsState(
      isLoading: isLoading ?? this.isLoading,
      cms: cms ?? this.cms,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, cms, error];
}