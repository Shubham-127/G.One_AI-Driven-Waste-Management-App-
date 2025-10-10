// lib/models/pickup_schedule.dart
class PickupSchedule {
  final String id;
  final String centerName;
  final DateTime pickupDate;
  final String status; // Scheduled / Completed / Cancelled

  PickupSchedule({
    required this.id,
    required this.centerName,
    required this.pickupDate,
    required this.status,
  });
}
