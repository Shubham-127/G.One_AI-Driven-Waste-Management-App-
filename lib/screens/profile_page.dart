import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/Profile';


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String username = "Shubham";

  final int weeklyPoints = 757;

  final int level = 3;

  final int consecutiveDays = 5; 
 // streak
  final List<Map<String, String>> workHistory = [
    {"date": "2025-09-21", "task": "Recycled 5 items"},
    {"date": "2025-09-20", "task": "Collected organic waste"},
    {"date": "2025-09-19", "task": "Participated in clean-up drive"},
  ];

  final List<Map<String, String>> badges = [
    {"name": "Recycling Novice", "icon": "♻️"},
    {"name": "Plastic Hero", "icon": "🛍️"},
    {"name": "Eco Warrior", "icon": "🌱"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Gamification'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Level $level",
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Text(
                        "Weekly Points: $weeklyPoints",
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Streak Info
              Card(
                color: Colors.green[50],
                child: ListTile(
                  leading: Icon(Icons.whatshot, color: Colors.orange),
                  title: Text("Current Streak"),
                  subtitle:
                      Text("$consecutiveDays days of active contributions"),
                ),
              ),
              const SizedBox(height: 16),

              // Progress to next level
              Text(
                "Progress to Next Level",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: weeklyPoints / 200,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
                minHeight: 12,
              ),
              const SizedBox(height: 24),

              // Badges Section
              Text(
                "Achievements / Badges",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100, // fixed height for horizontal badges
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: badges.length,
                  itemBuilder: (context, index) {
                    final badge = badges[index];
                    return Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            badge["icon"]!,
                            style: TextStyle(fontSize: 28),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            badge["name"]!,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Work History
              Text(
                "Work History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: workHistory.length,
                itemBuilder: (context, index) {
                  final item = workHistory[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text(item["task"]!),
                      subtitle: Text(item["date"]!),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Settings Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Settings tapped")),
                    );
                  },
                  icon: Icon(Icons.settings),
                  label: Text("Settings", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
