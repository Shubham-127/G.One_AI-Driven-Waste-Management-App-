import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'report_page.dart';
import 'scanner_page.dart';
import 'training_page.dart';
import 'schedule_page.dart';
import 'nearest_centers_page.dart';

// STEP 1: The UI for your dashboard is now in its own clean widget.
class DashboardContent extends StatelessWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String username = 'Guest';
        if (state is Authenticated) username = state.username;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero header with illustration and summary
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(Icons.local_shipping_rounded, size: 44, color: primary),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome, $username', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          SizedBox(height: 6),
                          Text('Report dumping, schedule pickups, and climb the leaderboard by recycling.', style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, ReportPage.routeName),
                                icon: Icon(Icons.report_gmailerrorred),
                                label: Text('Report Dumping', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(minimumSize: Size(140, 40)),
                              ),
                              OutlinedButton.icon(
                               onPressed: () => Navigator.pushNamed(context, SchedulePage.routeName),
                                icon: Icon(Icons.calendar_today_outlined),
                                label: Text('Schedule Pickup'),
                                style: OutlinedButton.styleFrom(
                                foregroundColor: primary,
                                  side: BorderSide(color: primary.withOpacity(0.18)),
                                 minimumSize: Size(140, 40),
                               ),
                              )

                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text('Leaderboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Column(
                    children: [
                      _leaderRow(1, 'Shubham', 757, Colors.deepPurple),
                      Divider(),
                      _leaderRow(2, 'Dhanush', 546, Colors.grey),
                      Divider(),
                      _leaderRow(3, 'rahul', 290, Colors.orange),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Leaderboard page - coming soon'))),
                          child: Text('View full leaderboard'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
                // Tips card
                Text('Tips & Guides', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Waste Management Tips', style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        Text('Sort wet and dry at source. Compost wet waste. Drop recyclables at nearby centers. Earn points for compliance.', style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                           runSpacing: 8,
                          children: [
                            ElevatedButton(
                             onPressed: () {
                              Navigator.push(
                               context,
                                MaterialPageRoute(builder: (context) => const TrainingPage()),
                         );
                         },
                               child: const Text('Start Training', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),),
                         ),

                            SizedBox(width: 12),
                            OutlinedButton.icon(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const NearestCentersPage()),
  ),
  icon: Icon(Icons.location_on_outlined),
  label: Text('Nearest centers'),
  style: OutlinedButton.styleFrom(foregroundColor: primary),
),

                            
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // You can move the _leaderRow method here too to keep the code organized
  Widget _leaderRow(int rank, String name, int points, Color medalColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: medalColor,
          child: Text(rank.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 12),
        Expanded(child: Text(name, style: TextStyle(fontWeight: FontWeight.w600))),
        Text('$points pts', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// This is your main page, now acting as a container for the other pages.
class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  // STEP 2: The _pages list now correctly uses the new DashboardContent widget.
  final List<Widget> _pages = [
    DashboardContent(),
    ScannerPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // STEP 3: The Scaffold is now clean and correct.
    return Scaffold(
      appBar: AppBar(
        title: Text('G.One'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
          )
        ],
      ),
      // The body now shows the selected page from the list.
      body: _pages[_currentIndex],
      // The bottomNavigationBar is in its dedicated property.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scanner'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

