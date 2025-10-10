import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportSubmitting extends ReportState {}

class ReportSuccess extends ReportState {}

class ReportFailure extends ReportState {
  final String message;

  ReportFailure(this.message);

  @override
  List<Object?> get props => [message];
}
