import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  // List of videos: titles + YouTube IDs + start time
  final List<Map<String, dynamic>> videos = [
    {
      'title': 'How to Segregate Waste at Home',
      'id': 'dDifDHegF_o', // ✅ Only ID
      'startAt': 60,       // start at 60s
    },
    {
      'title': 'Composting Basics',
      'id': 'egyNJ7xPyoQ', // ✅ Only ID
      'startAt': 38,       // start at 38s
    },
  ];

  final List<YoutubePlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var video in videos) {
      final controller = YoutubePlayerController(
        initialVideoId: video['id'],
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          startAt: video['startAt'], // ✅ Start time handled here
        ),
      );
      _controllers.add(controller);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Management Training'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final controller = _controllers[index];
          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    video['title'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  YoutubePlayer(
                    controller: controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.green,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
