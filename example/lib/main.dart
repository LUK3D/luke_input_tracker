import 'package:flutter/material.dart';
import 'package:luke_input_tracker/luke_input_tracker.dart';
import 'package:luke_input_tracker_example/track_mouse.dart';

Future<void> main() async {
  await LukeInputTracker.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: TrackMouse(),
      ),
    );
  }
}
