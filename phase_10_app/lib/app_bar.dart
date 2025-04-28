import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          icon: const Icon(Icons.save),
          tooltip: 'Save to Google Sheets',
          onPressed: () {
            // TODO: Implement Google Sheets integration
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Save to Google Sheets not implemented'),
              ),
            );
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
