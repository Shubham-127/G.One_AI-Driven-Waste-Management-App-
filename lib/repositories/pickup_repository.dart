// lib/repositories/pickup_repository.dart
import 'dart:async';
import '../models/pickup_schedule.dart';

class PickupRepository {
  PickupRepository._internal();
  static final PickupRepository _instance = PickupRepository._internal();
  factory PickupRepository() => _instance;
  static PickupRepository get instance => _instance;

  final List<PickupSchedule> _schedules = [];

  Future<List<PickupSchedule>> getSchedules() async {
    // simulate small delay like a real API
    await Future.delayed(Duration(milliseconds: 200));
    // return a copy so callers can't mutate internal list directly
    return List.unmodifiable(_schedules);
  }

  Future<void> addSchedule(PickupSchedule schedule) async {
    await Future.delayed(Duration(milliseconds: 150));
    // insert at top (most recent first)
    _schedules.insert(0, schedule);
  }

  Future<void> removeSchedule(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _schedules.removeWhere((s) => s.id == id);
  }

  Future<void> markCompleted(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    final idx = _schedules.indexWhere((s) => s.id == id);
    if (idx >= 0) {
      final old = _schedules[idx];
      _schedules[idx] = PickupSchedule(
        id: old.id,
        centerName: old.centerName,
        pickupDate: old.pickupDate,
        status: 'Completed',
      );
    }
  }
}
