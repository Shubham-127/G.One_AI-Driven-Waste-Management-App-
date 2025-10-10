import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../models/center.dart';
import '../repositories/centers_repository.dart';
import 'schedule_page.dart';

class NearestCentersPage extends StatefulWidget {
  static const routeName = '/nearestCenters';
  const NearestCentersPage({Key? key}) : super(key: key);

  @override
  State<NearestCentersPage> createState() => _NearestCentersPageState();
}

class _NearestCentersPageState extends State<NearestCentersPage> {
  final _repo = CentersRepository.instance;
  List<CenterModel> _centers = [];
  bool _loading = true;
  String _filterType = 'All';

  // user location
  double? _userLat, _userLng;

  @override
  void initState() {
    super.initState();
    _loadCenters();
    _determinePosition();
  }

  /// Load list of centers
  Future<void> _loadCenters() async {
    setState(() => _loading = true);
    final list = await _repo.fetchCenters();
    setState(() {
      _centers = list;
      _loading = false;
    });
  }

  /// Get user location
  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _userLat = pos.latitude;
      _userLng = pos.longitude;
    });
  }

  /// All center types
  List<String> _allTypes() {
    final types = {'All'};
    for (var c in _centers) types.add(c.type);
    return types.toList();
  }

  /// Filtered centers list
  List<CenterModel> get _filtered {
    if (_filterType == 'All') return _centers;
    return _centers.where((c) => c.type == _filterType).toList();
  }

  /// Distance calculator (km)
  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // pi/180
    final a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a)); // 2*R*asin
  }

  /// Open in Google Maps
  Future<void> _openInMaps(CenterModel center) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${center.latitude},${center.longitude}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Call phone number
  Future<void> _callCenter(String phone) async {
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  /// Bottom sheet with center details
void _showCenterDetails(CenterModel center) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(center.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            SizedBox(height: 6),
            Text('${center.type} • ${center.address}',
                style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // close sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SchedulePage(prefilledCenter: center.name),
                        ),
                      );
                    },
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text('Request Pickup', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _openInMaps(center),
                    icon: Icon(Icons.map_outlined),
                    label: Text('Open in Maps'),
                  ),
                  SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _callCenter(center.phone),
                    icon: Icon(Icons.phone_outlined),
                    label: Text('Call'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final types = _allTypes();
    return Scaffold(
      appBar: AppBar(
          title: Text('Nearest Centers'), backgroundColor: Colors.green),
      body: RefreshIndicator(
        onRefresh: _loadCenters,
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: types.map((t) {
                        final selected = t == _filterType;
                        return ChoiceChip(
                          label: Text(t),
                          selected: selected,
                          onSelected: (_) => setState(() => _filterType = t),
                          selectedColor: Colors.green.shade100,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final center = _filtered[index];
                        final distText = (_userLat != null && _userLng != null)
                            ? '${_distanceKm(_userLat!, _userLng!, center.latitude, center.longitude).toStringAsFixed(2)} km'
                            : '—'; // show — until location is ready
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.location_on_outlined,
                                color: Colors.green),
                            title: Text(center.name),
                            subtitle: Text(
                                '${center.type} • ${center.address}\nDistance: $distText'),
                            isThreeLine: true,
                            trailing: Icon(Icons.chevron_right),
                            onTap: () => _showCenterDetails(center),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
