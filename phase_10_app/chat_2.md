freemansoft: Move the payer, scores and phases files to a model directory

GitHub Copilot: ````plaintext
// Move the following files to a new directory named `model`:

// Before:
// lib/player.dart
// lib/scores.dart
// lib/phases.dart

// After:
// lib/model/player.dart
// lib/model/scores.dart
// lib/model/phases.dart

// Update all import statements throughout your project from, for example:
import 'player.dart';
// to:
import 'model/player.dart';
````

freemansoft: Move the PlayerNotifier to the provider folder

GitHub Copilot: ````plaintext
// Move the file containing PlayerNotifier to the provider directory.

// For example, if you have:
// lib/player_notifier.dart

// Move it to:
// lib/provider/player_notifier.dart

// Update all import statements throughout your project from:
import 'player_notifier.dart';
// to:
import 'provider/player_notifier.dart';
````