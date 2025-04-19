import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentRound = 1;
  List<int> scores = [0, 0, 0, 0, 0, 0, 0, 0];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Scorekeeper'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SwitchTheme(),
            SizedBox(height: 20),
            Text('Round $currentRound', style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerScore(),
                RoundScore(),
                PhaseDropdown(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchTheme extends StatefulWidget {
  @override
  _SwitchThemeState createState() => _SwitchThemeState();
}

class _SwitchThemeState extends State<SwitchTheme> {
  bool isDarkMode = false;

  void changeTheme(bool dark) {
    setState(() {
      isDarkMode = dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Light Mode'),
        Switch(
          value: isDarkMode,
          onChanged: (value) => changeTheme(value),
        ),
        Text('Dark Mode'),
      ],
    );
  }
}

class PlayerScore extends StatefulWidget {
  @override
  _PlayerScoreState createState() => _PlayerScoreState();
}

class _PlayerScoreState extends State<PlayerScore> {
  String playerName = '';
  int totalPoints = 0;

  void updateTotalPoints(int points) {
    setState(() {
      totalPoints += points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          PlayerName(),
          TotalPoints(),
        ]),
        RoundScore(),
      ],
    );
  }
}

class PlayerName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Player Name');
  }
}

class TotalPoints extends StatefulWidget {
  @override
  _TotalPointsState createState() => _TotalPointsState();
}

class _TotalPointsState extends State<TotalPoints> {
  int totalPoints = 0;

  void updateTotalPoints(int points) {
    setState(() {
      totalPoints += points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('$totalPoints');
  }
}

class RoundScore extends StatefulWidget {
  @override
  _RoundScoreState createState() => _RoundScoreState();
}

class _RoundScoreState extends State<RoundScore> {
  int roundPoints = 0;
  String phaseCompleted = '';

  void updateRoundPoints(int points) {
    setState(() {
      roundPoints += points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundScore(),
        PhaseDropdown(),
      ],
    );
  }
}

class PhaseDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: '',
      items: [
        DropdownMenuItem(child: Text('Phase 1'), value: 'phase1',),
        DropdownMenuItem(child: Text('Phase 2'), value: 'phase2',),
        ...,
        DropdownMenuItem(child: Text('Phase 10'), value: 'phase10',),
      ],
    );
  }
}