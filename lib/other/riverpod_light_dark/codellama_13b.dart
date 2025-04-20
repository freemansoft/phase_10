// None of the UI code was generated for the user interaction

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Sandbox',
      home: Scaffold(
        appBar: AppBar(title: Text('Phase 10 Sandbox')),
        body: RoundScores(),
      ),
    );
  }
}

class RoundScores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [PlayerScores(), RoundPlayerScores()]);
  }
}

class RoundPlayerScores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8, // Replace with your player count
      itemBuilder: (context, index) => PlayerScore(),
    );
  }
}

class RoundScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('TODO'); // Replace with your score display logic
  }
}

class PlayerScores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8, // Replace with your player count
      itemBuilder: (context, index) => PlayerScore(),
    );
  }
}

class PlayerScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('TODO'); // Replace with your score display logic
  }
}
