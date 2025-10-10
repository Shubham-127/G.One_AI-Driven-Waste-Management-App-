// lib/screens/schedule_page.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/pickup_schedule.dart';
import '../repositories/pickup_repository.dart';


class SchedulePage extends StatefulWidget {
  static const routeName = '/schedule';
  final String? prefilledCenter;
  const SchedulePage({Key? key, this.prefilledCenter}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _repo = PickupRepository.instance;
  final _notesController = TextEditingController();

  // sample list of centers; replace with API later
  final List<String> _centers = [
    'Recycling Center A',
    'Biogas Plant B',
    'Waste-to-Energy Plant C',
    'Scrap Shop D'
  ];

  String? _selectedCenter;
  DateTime? _selectedDateTime;
  List<PickupSchedule> _schedules = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _selectedCenter = widget.prefilledCenter;
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() => _loading = true);
    final list = await _repo.getSchedules();
    setState(() {
      _schedules = list;
      _loading = false;
    });
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return;

    final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() => _selectedDateTime = combined);
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.toLocal();
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.day}-${d.month}-${d.year} $hh:$mm';
  }

  Future<void> _schedulePickup() async {
    if (_selectedCenter == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select a center')));
      return;
    }
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pick date & time')));
      return;
    }
    final id = Uuid().v4();
    final schedule = PickupSchedule(
      id: id,
      centerName: _selectedCenter!,
      pickupDate: _selectedDateTime!,
      status: 'Scheduled',
    );

    setState(() => _loading = true);
    await _repo.addSchedule(schedule);
    await _loadSchedules();
    // reset form
    setState(() {
      _selectedCenter = null;
      _selectedDateTime = null;
      _notesController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pickup scheduled')));
  }

  Future<void> _cancelSchedule(String id) async {
    await _repo.removeSchedule(id);
    await _loadSchedules();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pickup cancelled')));
  }

  Future<void> _completeSchedule(String id) async {
    await _repo.markCompleted(id);
    await _loadSchedules();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked as completed')));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Pickup'),
        backgroundColor: Colors.green, // keep consistent with your design
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSchedules,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Schedule a new pickup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            SizedBox(height: 8),
                            DropdownButtonFormField<String>(
  value: _selectedCenter, // ✅ use the state var
  decoration: InputDecoration(
    labelText: 'Choose center',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
  items: _centers
      .map((c) => DropdownMenuItem(child: Text(c), value: c))
      .toList(),
  onChanged: (v) => setState(() => _selectedCenter = v),
),

                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: Icon(Icons.calendar_today_outlined),
                                    label: Text(_selectedDateTime == null ? 'Pick Date & Time' : _formatDateTime(_selectedDateTime!)),
                                    onPressed: _pickDateTime,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _notesController,
                              decoration: InputDecoration(
                                labelText: 'Notes (optional)',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: _schedulePickup,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text('Schedule Pickup', style: TextStyle(fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 18),
                    Text('Upcoming Pickups', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(height: 8),
                    _schedules.isEmpty
                        ? Card(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: Text('No scheduled pickups.')),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _schedules.length,
                            separatorBuilder: (_, __) => SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final s = _schedules[index];
                              return Card(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                  child: Row(
                                    children: [
                                      Icon(Icons.recycling, color: Colors.green),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(s.centerName, style: TextStyle(fontWeight: FontWeight.w700)),
                                            SizedBox(height: 4),
                                            Text(_formatDateTime(s.pickupDate), style: TextStyle(color: Colors.grey[700])),
                                            SizedBox(height: 4),
                                            Text('Status: ${s.status}', style: TextStyle(color: s.status == 'Scheduled' ? Colors.blueAccent : Colors.grey[600])),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          if (s.status == 'Scheduled') ...[
                                            IconButton(
                                              onPressed: () => _completeSchedule(s.id),
                                              icon: Icon(Icons.check_circle_outline, color: Colors.green),
                                              tooltip: 'Mark completed',
                                            ),
                                            IconButton(
                                              onPressed: () => _cancelSchedule(s.id),
                                              icon: Icon(Icons.cancel_outlined, color: Colors.redAccent),
                                              tooltip: 'Cancel',
                                            ),
                                          ] else
                                            IconButton(
                                              onPressed: null,
                                              icon: Icon(Icons.lock, color: Colors.grey),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
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
