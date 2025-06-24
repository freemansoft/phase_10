import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fs_score/provider/game_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final VoidCallback? onContinue;
  const SplashScreen({super.key, this.onContinue});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  int _selectedPlayers = 2;
  String _sheetStyle = 'Basic Sheet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game scoring aid',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Number of Players:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _selectedPlayers,
                  items: [
                    for (var i = 2; i <= 8; i++)
                      DropdownMenuItem(value: i, child: Text(i.toString())),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPlayers = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sheet Style:', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _sheetStyle,
                  items: const [
                    DropdownMenuItem(
                      value: 'Basic Sheet',
                      child: Text('Basic Sheet'),
                    ),
                    DropdownMenuItem(
                      value: 'Include Phases',
                      child: Text('Include Phases'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sheetStyle = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ref.read(gameProvider.notifier).setNumPlayers(_selectedPlayers);
                ref
                    .read(gameProvider.notifier)
                    .setEnablePhases(_sheetStyle == 'Include Phases');
                if (widget.onContinue != null) widget.onContinue!();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
