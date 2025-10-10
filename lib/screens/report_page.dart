import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/report.dart';
import '../blocs/report/report_bloc.dart';
import '../blocs/report/report_event.dart';
import '../blocs/report/report_state.dart';

class ReportPage extends StatefulWidget {
  static const routeName = '/report';

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _descController = TextEditingController();
  File? _photo;
  LatLng? _pickedLocation;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take Photo'),
              onTap: () async {
                Navigator.of(context).pop();
                final picked =
                    await _picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  setState(() {
                    _photo = File(picked.path);
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final picked =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() {
                    _photo = File(picked.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLocation() async {
    LatLng? selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(
            initialLocation: LatLng(28.6139, 77.2090)), // Default Delhi
      ),
    );

    if (selected != null) {
      setState(() {
        _pickedLocation = selected;
      });
    }
  }

  void _submit() {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a short description')));
      return;
    }

    final id = Uuid().v4();
    final report = Report(
      id: id,
      description: desc,
      latitude: _pickedLocation?.latitude ?? 28.6139,
      longitude: _pickedLocation?.longitude ?? 77.2090,
      createdAt: DateTime.now(),
      photoPath: _photo?.path,
    );

    context.read<ReportBloc>().add(SubmitReport(report));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Dumping'),
        elevation: 0,
      ),
      body: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportSuccess) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Report Submitted'),
                content: Text(
                    'Thank you. Your report has been recorded and assigned to the local Green Champions.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'))
                ],
              ),
            );
          } else if (state is ReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed: ${state.message}')));
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Report Details',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                        'Location: ${_pickedLocation != null ? "${_pickedLocation!.latitude}, ${_pickedLocation!.longitude}" : "Not selected"}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _descController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText:
                              'Describe the dumping / location / notes',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 12),
                      if (_photo != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _photo!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickPhoto,
                            icon: Icon(Icons.camera_alt_outlined),
                            label: Text('Attach Photo',style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),),
                          ),
                          SizedBox(width: 8),
                          TextButton(
                              onPressed: _pickLocation,
                              child: Text('Pick Location'))
                        ],
                      ),
                      SizedBox(height: 8),
                      BlocBuilder<ReportBloc, ReportState>(
                        builder: (context, state) {
                          final submitting = state is ReportSubmitting;
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: submitting ? null : _submit,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0),
                                child: submitting
                                    ? SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ))
                                    : Text('Submit Report', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14),
              Text(
                  'By reporting, you help Green Champions keep the area clean.',
                  style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }
}

/// Location Picker using Google Maps
class LocationPickerPage extends StatefulWidget {
  final LatLng initialLocation;
  LocationPickerPage({required this.initialLocation});

  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late LatLng _selected;
  

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: Text('Save', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: widget.initialLocation, zoom: 14),

        markers: {
          Marker(markerId: MarkerId('picked'), position: _selected)
        },
        onTap: (pos) {
          setState(() {
            _selected = pos; // updates pin on tap
          });
        },
      ),
    );
  }
}
