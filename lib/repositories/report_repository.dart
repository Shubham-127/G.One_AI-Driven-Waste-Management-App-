import 'dart:async';
// import 'package:uuid/uuid.dart';
import '../models/report.dart';

class ReportRepository {
  // In-memory mock list
  final List<Report> _reports = [];

  Future<void> submitReport(Report report) async {
    // simulate network delay and occasional error
    await Future.delayed(Duration(seconds: 1));
    final rand = DateTime.now().millisecondsSinceEpoch % 10;
    if (rand == 0) {
      throw Exception('Network error (mock)');
    }
    _reports.add(report);
  }

  Future<List<Report>> fetchReports() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_reports);
  }
}
