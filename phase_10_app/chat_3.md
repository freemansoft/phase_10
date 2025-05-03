freemansoft: Create a unit test that

uses phase10Appbuilder
clicks in the name field for the first player and sets it to "joe"
verifies the first player total score field holds 0
clicks in the first player round 1 score field and enters 10
clicks in the first player round 2 score field and enters 15
verifies the first player total score field holds 25
uses the field id or key to find the field. The key includes the player number and round number in its name for the round entry fields. The key includes the player number for the total round score for a player

GitHub Copilot:
````dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phase_10_app/app.dart';

void main() {
  testWidgets('Phase10AppBuilder integration test', (WidgetTester tester) async {
    // Build the app using the builder
    await tester.pumpWidget(const Phase10AppBuilder());

    // Wait for the widget tree to settle
    await tester.pumpAndSettle();

    // Find the first player's name field by key and enter "joe"
    final nameFieldKey = const ValueKey('player_name_field_0');
    expect(find.byKey(nameFieldKey), findsOneWidget);
    await tester.enterText(find.byKey(nameFieldKey), 'joe');
    await tester.pumpAndSettle();

    // Verify the first player's total score field holds 0
    final totalScoreKey = const ValueKey('player_total_score_0');
    expect(find.byKey(totalScoreKey), findsOneWidget);
    expect(find.descendant(of: find.byKey(totalScoreKey), matching: find.text('0')), findsOneWidget);

    // Enter 10 in the first player's round 1 score field
    final round1ScoreKey = const ValueKey('round_score_p0_r0');
    expect(find.byKey(round1ScoreKey), findsOneWidget);
    await tester.enterText(find.byKey(round1ScoreKey), '10');
    await tester.pumpAndSettle();

    // Enter 15 in the first player's round 2 score field
    final round2ScoreKey = const ValueKey('round_score_p0_r1');
    expect(find.byKey(round2ScoreKey), findsOneWidget);
    await tester.enterText(find.byKey(round2ScoreKey), '15');
    await tester.pumpAndSettle();

    // Verify the first player's total score field holds 25
    expect(find.byKey(totalScoreKey), findsOneWidget);
    expect(find.descendant(of: find.byKey(totalScoreKey), matching: find.text('25')), findsOneWidget);
  });
}
````

freemansoft: Wrap phase10app in an appbuilder that includes the providerscope and remove the providerscope from main.dart

GitHub Copilot:
````dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'phase10app.dart';

// Wraps Phase10App with ProviderScope for use in tests and main
class Phase10AppBuilder extends StatelessWidget {
  const Phase10AppBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Phase10App(),
    );
  }
}
````

````dart
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const Phase10AppBuilder());
}
````

freemansoft: Create a flutter widget unit test that

- uses phase10Appbuilder
- clicks in the Text Field inside the player name field for the first player and sets it to "joe"
- verify the name in the text field inside the player name field for the first player has a value of "joe"
- verify the first player total score Text holds 0
- clicks in the text field inside the first player round 1 score field and enters 10
- clicks in the text field inside thefirst player round 2 score field and enters 15
- verifies the first player total score field holds 25
- uses the field id or key to find the field. The key includes the player number and round number in its name for the round entry fields. The key includes the player number for the total round score for a player
- fields being modified in a test are often the descendants of the widget found by id

GitHub Copilot:
````dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phase_10_app/app.dart';

void main() {
  testWidgets('ScoreTable widget test for player name and score fields', (WidgetTester tester) async {
    // Build the app using the builder
    await tester.pumpWidget(const Phase10AppBuilder());
    await tester.pumpAndSettle();

    // Find the PlayerNameField for the first player
    final nameFieldKey = const ValueKey('player_name_field_0');
    final nameFieldFinder = find.byKey(nameFieldKey);
    expect(nameFieldFinder, findsOneWidget);

    // Find the TextFormField inside PlayerNameField and enter "joe"
    final nameTextFieldFinder = find.descendant(
      of: nameFieldFinder,
      matching: find.byType(TextFormField),
    );
    expect(nameTextFieldFinder, findsOneWidget);
    await tester.tap(nameTextFieldFinder);
    await tester.enterText(nameTextFieldFinder, 'joe');
    await tester.pumpAndSettle();

    // Verify the name in the text field is "joe"
    final nameTextFieldWidget = tester.widget<TextFormField>(nameTextFieldFinder);
    expect(nameTextFieldWidget.controller?.text, 'joe');

    // Verify the first player's total score Text holds 0
    final totalScoreKey = const ValueKey('player_total_score_0');
    final totalScoreFinder = find.byKey(totalScoreKey);
    expect(totalScoreFinder, findsOneWidget);
    expect(
      (tester.widget<Text>(totalScoreFinder)).data,
      '0',
    );

    // Enter 10 in the first player's round 1 score field (round 0)
    final round1ScoreKey = const ValueKey('round_score_p0_r0');
    final round1ScoreFinder = find.byKey(round1ScoreKey);
    expect(round1ScoreFinder, findsOneWidget);
    final round1TextFieldFinder = find.descendant(
      of: round1ScoreFinder,
      matching: find.byType(TextFormField),
    );
    expect(round1TextFieldFinder, findsOneWidget);
    await tester.tap(round1TextFieldFinder);
    await tester.enterText(round1TextFieldFinder, '10');
    await tester.pumpAndSettle();

    // Enter 15 in the first player's round 2 score field (round 1)
    final round2ScoreKey = const ValueKey('round_score_p0_r1');
    final round2ScoreFinder = find.byKey(round2ScoreKey);
    expect(round2ScoreFinder, findsOneWidget);
    final round2TextFieldFinder = find.descendant(
      of: round2ScoreFinder,
      matching: find.byType(TextFormField),
    );
    expect(round2TextFieldFinder, findsOneWidget);
    await tester.tap(round2TextFieldFinder);
    await tester.enterText(round2TextFieldFinder, '15');
    await tester.pumpAndSettle();

    // Verify the first player's total score Text holds 25
    expect(
      (tester.widget<Text>(totalScoreFinder)).data,
      '25',
    );
  });
}
````