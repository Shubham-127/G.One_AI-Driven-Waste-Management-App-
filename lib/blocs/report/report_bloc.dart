import 'package:flutter_bloc/flutter_bloc.dart';
import 'report_event.dart';
import 'report_state.dart';
import '../../../repositories/report_repository.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  ReportBloc(this.repository) : super(ReportInitial()) {
    on<SubmitReport>(_onSubmitReport);
  }

  Future<void> _onSubmitReport(SubmitReport event, Emitter<ReportState> emit) async {
    emit(ReportSubmitting());
    try {
      await repository.submitReport(event.report);
      emit(ReportSuccess());
      await Future.delayed(Duration(milliseconds: 500)); // brief pause for UI
      emit(ReportInitial());
    } catch (e) {
      emit(ReportFailure(e.toString()));
    }
  }
}
