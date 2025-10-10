import 'package:equatable/equatable.dart';
import '../../../models/report.dart';

abstract class ReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitReport extends ReportEvent {
  final Report report;

  SubmitReport(this.report);

  @override
  List<Object?> get props => [report];
}
