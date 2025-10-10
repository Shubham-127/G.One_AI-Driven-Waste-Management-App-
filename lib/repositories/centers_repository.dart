// lib/repositories/centers_repository.dart
import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/center.dart';

class CentersRepository {
  CentersRepository._internal();
  static final CentersRepository _instance = CentersRepository._internal();
  factory CentersRepository() => _instance;
  static CentersRepository get instance => _instance;

  final List<CenterModel> _centers = [
  CenterModel(
    id: Uuid().v4(),
    name: 'Recycling Center A',
    type: 'Recycling',
    address: 'Sector 5, Gurugram',
    latitude: 28.4590, // near Gurugram
    longitude: 77.0270,
    phone: '080-1234-0001',
  ),
  CenterModel(
    id: Uuid().v4(),
    name: 'Biogas Plant B',
    type: 'Biogas',
    address: 'Energy Park Road, Delhi',
    latitude: 28.6150, // near Delhi
    longitude: 77.2100,
    phone: '080-1234-0002',
  ),
  CenterModel(
    id: Uuid().v4(),
    name: 'Waste-to-Energy Plant C',
    type: 'W-to-E',
    address: 'Industrial Estate, Gurugram',
    latitude: 28.4605, 
    longitude: 77.0280,
    phone: '080-1234-0003',
  ),
  CenterModel(
    id: Uuid().v4(),
    name: 'Scrap Shop D',
    type: 'Scrap Shop',
    address: 'Old Market Road, Delhi',
    latitude: 28.6145,
    longitude: 77.2080,
    phone: '080-1234-0004',
  ),
];


  Future<List<CenterModel>> fetchCenters() async {
    await Future.delayed(Duration(milliseconds: 250)); // simulate latency
    return List.unmodifiable(_centers);
  }

  // Optional: find a center by id
  Future<CenterModel?> getById(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    try {
      return _centers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
