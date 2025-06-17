import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phase_10_app/provider/players_provider.dart';

final themeProvider = StateProvider<bool>((ref) => false);

class Phase10AppBar extends ConsumerWidget implements PreferredSizeWidget {
  Phase10AppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return AppBar(
      title: const Text('Phase-10 Scoreboard'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'New Game',
          onPressed: () async {
            bool clearNames = false;
            final result = await showDialog<bool>(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder:
                      (context, setState) => AlertDialog(
                        title: const Text('Start New Game?'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Are you sure you want to start a new game? All scores and phases will be reset.',
                            ),
                            const SizedBox(height: 16),
                            CheckboxListTile(
                              value: clearNames,
                              onChanged: (val) {
                                setState(() {
                                  clearNames = val ?? false;
                                });
                              },
                              title: const Text('Clear the player names'),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('New Game'),
                          ),
                        ],
                      ),
                );
              },
            );
            if (result == true) {
              ref
                  .read(playersProvider.notifier)
                  .resetGame(clearNames: clearNames);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Game reset!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
        Row(
          children: [
            const Icon(Icons.light_mode),
            Switch(
              value: isDark,
              onChanged: (val) => ref.read(themeProvider.notifier).state = val,
            ),
            const Icon(Icons.dark_mode),
          ],
        ),
      ],
    );
  }
}
