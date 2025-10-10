// lib/models/center.dart
class CenterModel {
  final String id;
  final String name;
  final String type; // Recycling / Biogas / W-to-E / Scrap
  final String address;
  final double latitude;
  final double longitude;
  final String phone;

  CenterModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
  });
}
