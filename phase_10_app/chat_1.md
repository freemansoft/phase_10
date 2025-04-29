freemansoft: Create Flutter application code using this prompt. The output should be a complete flutter application with all necessary files and folders.

Implement the a game scoring program for "phase 10".

- This is a flutter based score-keeping application that can be used when playing the card game "phase 10".
- The game is played by 8 players and consists of up to 12 "rounds" where players earn points and may complete a "phase".
- There is a "Player" class to hold each player's state including their name and their scores object and their phases object.
- There is a "Scores" class to hold all player's round scores and the total of the round scores
- There is a "Phases" class that holds all of the completed phases for a single player.
- Player, Scores, Phases classes should be in their own files.

- The program accepts a round score and an optional phase completion value.
- The program calculates the total score as the sum of the round scores for each player whenever a round score is updated and displays total
- the program allows editing of player names.

- The UI should be a horizontally scrolling table that displays each player in their own row.
- The top row is the header.
- The first column of each row is frozen, not scrolling
- The first column displays the player's name and total points scored by that player. The first column  should always be visible and should be part of the table. The player's name is editable.  The total score is calculated.
- The second group of columns containing 12 columns is the rounds section. The rounds section of the table should horizontally scrollable
- Each of the 12 "rounds" has two fields.The first field contains the phase number completed for that round. The second field in each column is an editable text field that captures the points scored in that round. The two fields in each cell can be arranged vertically or horizontally but should fit within the table cell.

- The round score field is an editable numeric input field.
- The round phase completed dropdown offers a blank option and the numbers 1 through 10 representing the 10 phases of "phase 10"
- A person's total score is updated whenever a score for one of the rounds  is updated.

- Use a third party table library like data_table_2.  All of the information should be in a single table.
- Use a table library that supports frozen columns and rows while letting the rest of the table scroll horizontally.
- State should be managed with riverpod 2 or riverpod 3 and use the "ref" syntax and not ScopedReader

- The round score entry fields should only accept numeric data

- The application should have an appbar with a title "Phase-10 Scoreboard" .
- There is a switch on the appbar to toggle between light and dark mode.
- There should be a button on the app bar that saves the data in a google sheet.
- The appbar and its functionality should be in a separate file from the scoring widget and from the main.dart
- The score table and its fields should be in a separate file from main.dart


GitHub Copilot: ````dart
// ...existing code...
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      initialValue: player.name,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      onChanged: (val) {
                        ref.read(playersProvider.notifier).updatePlayerName(playerIdx, val);
                      },
                    ),
                  ),
                  Text('Total: ${player.totalScore}'),
                ],
              ),
            ),
// ...existing code...
````

**You must also add the following to your `PlayersNotifier` in `players_provider.dart`:**

````dart
// ...existing code...
  void updatePlayerName(int playerIdx, String name) {
    final player = state[playerIdx];
    state[playerIdx] = Player(
      name: name,
      scores: player.scores,
      phases: player.phases,
    );
    state = [...state];
  }
// ...existing code...
````

**And update your `Player` class to accept `scores` and `phases` as optional parameters:**

````dart
// ...existing code...
  Player({required this.name, Scores? scores, Phases? phases})
      : scores = scores ?? Scores(),
        phases = phases ?? Phases();
// ...existing code...
````

This will make the player name editable in the table.

freemansoft: add outline borders to the editable round score entry fields

GitHub Copilot: ````dart
// ...existing code...
DataCell(
  Column(
    children: [
      DropdownButtonFormField<int>(
        value: player.phases.getPhase(roundIdx),
        items: [
          const DropdownMenuItem<int>(value: null, child: Text('')),
          ...List.generate(
            10,
            (i) => DropdownMenuItem<int>(
              value: i + 1,
              child: Text('${i + 1}'),
            ),
          ),
        ],
        onChanged: (val) {
          ref.read(playersProvider.notifier).updatePhase(playerIdx, roundIdx, val);
        },
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 4),
      SizedBox(
        width: 60,
        child: TextFormField(
          initialValue: player.scores.getScore(roundIdx)?.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            border: OutlineInputBorder(), // <-- Add this line
          ),
          onChanged: (val) {
            final score = int.tryParse(val) ?? 0;
            ref.read(playersProvider.notifier).updateScore(playerIdx, roundIdx, score);
          },
        ),
      ),
    ],
  ),
),
// ...existing code...
````

This adds an outline border to the editable round score entry fields.

freemansoft: add outline border to drop lists

GitHub Copilot: ````dart
// ...existing code...
DropdownButtonFormField<int?>(
  value: phase,
  isExpanded: true,
  hint: const Text('Phase'),
  items: [
    const DropdownMenuItem<int?>(
      value: null,
      child: Text(''),
    ),
    ...List.generate(
      10,
      (i) => DropdownMenuItem<int?>(
        value: i + 1,
        child: Text('${i + 1}'),
      ),
    ),
  ],
  onChanged: (val) {
    ref
        .read(playersProvider.notifier)
        .updatePhase(playerIdx, round, val);
  },
  decoration: const InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      vertical: 6,
      horizontal: 8,
    ),
    border: OutlineInputBorder(), // <-- Add outline border here
  ),
),
// ...existing code...
````

**Replace your `DropdownButton<int?>` with `DropdownButtonFormField<int?>` and add the `decoration` property as shown above.**
This will give the dropdowns an outline border to match the score entry fields.

freemansoft: set the dropdown minimum width to 70 pixels

GitHub Copilot: ````dart
// ...existing code...
SizedBox(
  width: 70, // <-- Set minimum width for dropdown
  child: DropdownButtonFormField<int?>(
    value: phase,
    isExpanded: true,
    hint: const Text('Phase'),
    items: [
      const DropdownMenuItem<int?>(
        value: null,
        child: Text(''),
      ),
      ...List.generate(
        10,
        (i) => DropdownMenuItem<int?>(
          value: i + 1,
          child: Text('${i + 1}'),
        ),
      ),
    ],
    onChanged: (val) {
      ref
          .read(playersProvider.notifier)
          .updatePhase(playerIdx, round, val);
    },
    decoration: const InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      border: OutlineInputBorder(),
    ),
  ),
),
// ...existing code...
````

Wrap your `DropdownButtonFormField` with a `SizedBox(width: 70, ...)` to set its minimum width to 70 pixels.

freemansoft: set teh data table column minimum width to 70 pixels

GitHub Copilot: ````dart
// ...existing code...
...List.generate(
  12,
  (round) => DataColumn2(
    label: Text('Round ${round + 1}'),
    size: ColumnSize.S,
    minWidth: 70, // <-- Set minimum width for each round column
  ),
),
// ...existing code...
````

Add `minWidth: 70,` to each `DataColumn2` for the round columns to set the minimum width to 70 pixels.

freemansoft: the drop list should aways be wide enough to show 2 digits

GitHub Copilot: ````dart
// ...existing code...
SizedBox(
  width: 70, // Ensures dropdown is wide enough for 2 digits
  child: DropdownButtonFormField<int?>(
    value: phase,
    isExpanded: true,
    hint: const Text('Phase'),
    items: [
      const DropdownMenuItem<int?>(
        value: null,
        child: Text(''),
      ),
      ...List.generate(
        10,
        (i) => DropdownMenuItem<int?>(
          value: i + 1,
          child: Text('${i + 1}'),
        ),
      ),
    ],
    onChanged: (val) {
      ref
          .read(playersProvider.notifier)
          .updatePhase(playerIdx, round, val);
    },
    decoration: const InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      border: OutlineInputBorder(),
    ),
  ),
),
// ...existing code...
````

**Replace your `DropdownButtonFormField<int?>` with the above, wrapped in a `SizedBox(width: 70, ...)` to ensure it always shows 2 digits.**

freemansoft: add an outline box to the total text

GitHub Copilot: ````dart
// ...existing code...
Container(
  margin: const EdgeInsets.only(top: 4),
  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(4),
  ),
  child: Text('Total: ${player.totalScore}'),
),
// ...existing code...
````

Replace your `Text('Total: ${player.totalScore}')` with the above `Container` to add an outline box around the total text.

freemansoft: alternate the background color of each row in the table

GitHub Copilot: ````dart
// ...existing code...
rows: List<DataRow2>.generate(players.length, (playerIdx) {
  final player = players[playerIdx];
  final isEven = playerIdx % 2 == 0;
  return DataRow2(
    color: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        return isEven
            ? Colors.grey.withOpacity(0.08)
            : Colors.transparent;
      },
    ),
    cells: [
      // ...existing code...
// ...existing code...
````

This will alternate the background color of each row in the table. Even rows will have a subtle grey background, odd rows will be transparent. Adjust the color as needed for your theme.

freemansoft: convert colors.red to MaterialStateProperty<Color>

GitHub Copilot: ````dart
// ...existing code...
return DataRow2(
  color: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      return isEven
          ? Colors.red.withAlpha(20)
          : Colors.blue.withAlpha(20);
    },
  ),
  cells: [
// ...existing code...
````

This change uses `MaterialStateProperty.resolveWith<Color?>` for the `color` property, as recommended for DataRow2.

freemansoft: set the light theme background color to white

GitHub Copilot: ````dart
// ...existing code...
return MaterialApp(
  title: 'Phase-10 Scoreboard',
  theme: ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white, // Set background to white
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  ),
  // ...existing code...
);
// ...existing code...
````

Add or update the `scaffoldBackgroundColor: Colors.white` in your light theme in `main.dart` to set the background color to white.

freemansoft: set the data table sizing behavior so that the drop lists are fully visible

GitHub Copilot: ````dart
// ...existing code...
return DataTable2(
  columnSpacing: 12,
  horizontalMargin: 12,
  minWidth: 1100, // Increased to allow more space for dropdowns
  fixedLeftColumns: 1,
  fixedTopRows: 1,
  isHorizontalScrollBarVisible: true,
  isVerticalScrollBarVisible: true,
  dataRowHeight: 60,
  columns: [
    const DataColumn2(
      label: Text('Player / Total'),
      size: ColumnSize.L,
      fixedWidth: 120, // Slightly wider for clarity
    ),
    ...List.generate(
      12,
      (round) => DataColumn2(
        label: Text('Round ${round + 1}'),
        size: ColumnSize.M, // Use medium size for more width
        minWidth: 90,       // Ensure dropdowns are fully visible
      ),
    ),
  ],
// ...existing code...
````

**Key changes:**
- Set `minWidth` of the table to `1100` (or higher if needed).
- Set each round column to `ColumnSize.M` and `minWidth: 90` for more space.
- Increased the fixed column width for the player/total column for clarity.

This ensures the dropdowns are always fully visible in the table. Adjust `minWidth` as needed for your UI.

freemansoft: Remove the string Total from the total score field

GitHub Copilot: ````dart
// ...existing code...
Container(
  width: 120,
  margin: const EdgeInsets.only(top: 1),
  padding: const EdgeInsets.symmetric(
    vertical: 2,
    horizontal: 8,
  ),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(4),
  ),
  child: Text(
    '${player.totalScore}', // Removed the string 'Total: '
    style: const TextStyle(fontWeight: FontWeight.bold),
  ),
),
// ...existing code...
````

freemansoft: align the total score centered in the column

GitHub Copilot: ````dart
// ...existing code...
Container(
  width: 120,
  margin: const EdgeInsets.only(top: 1),
  padding: const EdgeInsets.symmetric(
    vertical: 2,
    horizontal: 8,
  ),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(4),
  ),
  alignment: Alignment.center, // <-- Center the content horizontally
  child: Text(
    '${player.totalScore}',
    style: const TextStyle(fontWeight: FontWeight.bold),
    textAlign: TextAlign.center, // <-- Center the text
  ),
),
// ...existing code...
````

freemansoft: Align the player names to be centered

GitHub Copilot: ````dart
// ...existing code...
SizedBox(
  width: 120,
  child: TextFormField(
    initialValue: player.name,
    textAlign: TextAlign.center, // <-- Center the player name text
    decoration: const InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      border: OutlineInputBorder(),
    ),
    style: const TextStyle(fontWeight: FontWeight.bold),
    onChanged: (val) {
      ref
          .read(playersProvider.notifier)
          .updatePlayerName(playerIdx, val);
    },
  ),
),
// ...existing code...
````

freemansoft: highlight a column when the column header is clicked on

GitHub Copilot: ````dart
// ...existing code...
class ScoreTable extends ConsumerStatefulWidget {
  const ScoreTable({super.key});

  @override
  ConsumerState<ScoreTable> createState() => _ScoreTableState();
}

class _ScoreTableState extends ConsumerState<ScoreTable> {
  int? highlightedColumn;

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 1200,
      fixedLeftColumns: 1,
      fixedTopRows: 1,
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      dataRowHeight: 60,
      columns: [
        const DataColumn2(
          label: Text('Player / Total'),
          size: ColumnSize.L,
          fixedWidth: 100,
        ),
        ...List.generate(
          12,
          (round) => DataColumn2(
            label: InkWell(
              onTap: () {
                setState(() {
                  highlightedColumn = round;
                });
              },
              child: Container(
                color: highlightedColumn == round
                    ? Colors.yellow.withOpacity(0.3)
                    : Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Text('Round ${round + 1}'),
              ),
            ),
            size: ColumnSize.S,
          ),
        ),
      ],
      rows: List<DataRow2>.generate(players.length, (playerIdx) {
        final player = players[playerIdx];
        final isEven = playerIdx % 2 == 0;
        return DataRow2(
          color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return isEven
                  ? Colors.red.withAlpha(20)
                  : Colors.blue.withAlpha(20);
            },
          ),
          cells: [
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      initialValue: player.name,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      onChanged: (val) {
                        ref
                            .read(playersProvider.notifier)
                            .updatePlayerName(playerIdx, val);
                      },
                    ),
                  ),
                  Container(
                    width: 120,
                    margin: const EdgeInsets.only(top: 1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${player.totalScore}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            ...List<DataCell>.generate(12, (round) {
              final phase = player.phases.getPhase(round);
              final score = player.scores.getScore(round);
              return DataCell(
                Container(
                  color: highlightedColumn == round
                      ? Colors.yellow.withOpacity(0.15)
                      : Colors.transparent,
                  child: SizedBox(
                    width: 90,
                    child: Column(
                      children: [
                        DropdownButtonFormField<int?>(
                          value: phase,
                          isExpanded: true,
                          hint: const Text('Phase'),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('None'),
                            ),
                            ...List.generate(
                              10,
                              (i) => DropdownMenuItem<int?>(
                                value: i + 1,
                                child: Text('${i + 1}'),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            ref
                                .read(playersProvider.notifier)
                                .updatePhase(playerIdx, round, val);
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          initialValue: score?.toString() ?? '',
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Score',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            final parsed = int.tryParse(val);
                            ref
                                .read(playersProvider.notifier)
                                .updateScore(playerIdx, round, parsed);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
// ...existing code...
````

**This update highlights a column when its header is clicked by:**
- Making `ScoreTable` a `ConsumerStatefulWidget`.
- Tracking the highlighted column index in `highlightedColumn`.
- Wrapping each column header in an `InkWell` and coloring both the header and all cells in that column when selected.

freemansoft: validate that each round score ends in 0 or 5 if a number has been entered

GitHub Copilot: ````dart
// ...existing code...
TextFormField(
  initialValue: score?.toString() ?? '',
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    hintText: 'Score',
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      vertical: 6,
      horizontal: 8,
    ),
    border: OutlineInputBorder(),
  ),
  onChanged: (val) {
    final parsed = int.tryParse(val);
    ref
        .read(playersProvider.notifier)
        .updateScore(playerIdx, round, parsed);
  },
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
  validator: (val) {
    if (val == null || val.isEmpty) return null;
    final n = int.tryParse(val);
    if (n == null) return null;
    if (n % 5 != 0) {
      return 'Score must end in 0 or 5';
    }
    return null;
  },
),
// ...existing code...
````

**Add the `validator` property as shown above to your `TextFormField` for round scores.**
This will show an error if a number is entered that does not end in 0 or 5.

freemansoft: When I hover over the player name in the first column it shows an overlay that lists all the completed phases

GitHub Copilot: ````dart
// ...existing code...
DataCell(
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 120,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) {
            final completedPhases = player.phases.completedPhases();
            if (completedPhases.isNotEmpty) {
              final overlay = Overlay.of(context);
              final overlayEntry = OverlayEntry(
                builder: (context) => Positioned(
                  left: event.position.dx,
                  top: event.position.dy,
                  child: Material(
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Completed Phases: ${completedPhases.join(', ')}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              );
              overlay.insert(overlayEntry);
              Future.delayed(const Duration(seconds: 2), () {
                overlayEntry.remove();
              });
            }
          },
          child: TextFormField(
            initialValue: player.name,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontWeight: FontWeight.bold),
            onChanged: (val) {
              ref
                  .read(playersProvider.notifier)
                  .updatePlayerName(playerIdx, val);
            },
            readOnly: false,
          ),
        ),
      ),
      // ...existing code for total score...
// ...existing code...
````

**You must implement a `completedPhases()` method in your `Phases` class:**

````dart
// ...existing code...
List<int> completedPhases() {
  // Return a list of completed phase numbers (non-null, non-zero)
  return phases.where((p) => p != null && p > 0).cast<int>().toList();
}
// ...existing code...
````

This will show an overlay listing all completed phases when you hover over the player name.

freemansoft: add a hover handler over the total score field that shows the completed phases

GitHub Copilot: ````dart
// ...existing code...
Container(
  width: 120,
  margin: const EdgeInsets.only(top: 1),
  padding: const EdgeInsets.symmetric(
    vertical: 2,
    horizontal: 8,
  ),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(4),
  ),
  alignment: Alignment.center,
  child: MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (event) {
      final completedPhases = player.phases.completedPhases();
      if (completedPhases.isNotEmpty) {
        final overlay = Overlay.of(context);
        final overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            left: event.position.dx,
            top: event.position.dy,
            child: Material(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Completed Phases: ${completedPhases.join(', ')}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        );
        overlay.insert(overlayEntry);
        Future.delayed(const Duration(seconds: 2), () {
          overlayEntry.remove();
        });
      }
    },
    child: Text(
      '${player.totalScore}',
      style: const TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  ),
),
// ...existing code...
````

This wraps the total score field in a `MouseRegion` and shows an overlay with the completed phases when hovered.

freemansoft: add a 10 second alert that shows all the completed phases when a phase droplist has changed

GitHub Copilot: ````dart
// ...existing code...
DropdownButtonFormField<int?>(
  value: phase,
  isExpanded: true,
  hint: const Text('Phase'),
  items: [
    const DropdownMenuItem<int?>(
      value: null,
      child: Text('None'),
    ),
    ...List.generate(
      10,
      (i) => DropdownMenuItem<int?>(
        value: i + 1,
        child: Text('${i + 1}'),
      ),
    ),
  ],
  onChanged: (val) {
    ref
        .read(playersProvider.notifier)
        .updatePhase(playerIdx, round, val);

    // Show a 10 second alert with all completed phases
    final completedPhases = player.phases.completedPhases();
    if (completedPhases.isNotEmpty) {
      final snackBar = SnackBar(
        content: Text('Completed Phases: ${completedPhases.join(', ')}'),
        duration: const Duration(seconds: 10),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  },
  decoration: const InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      vertical: 6,
      horizontal: 8,
    ),
    border: OutlineInputBorder(),
  ),
),
// ...existing code...
````

This will show a 10-second alert (SnackBar) listing all completed phases whenever a phase dropdown value is changed.

freemansoft: When I click in a name field I want the whole name to be selected

GitHub Copilot: ````dart
// ...existing code...
SizedBox(
  width: 120,
  child: Focus(
    onFocusChange: (hasFocus) {
      if (hasFocus) {
        // Select all text when focused
        Future.delayed(Duration.zero, () {
          final focusNode = FocusScope.of(context);
          if (focusNode.focusedChild?.context != null) {
            final editable = focusNode.focusedChild!.context!.widget;
            if (editable is EditableText) {
              editable.controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: editable.controller.text.length,
              );
            }
          }
        });
      }
    },
    child: TextFormField(
      initialValue: player.name,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 8,
        ),
        border: OutlineInputBorder(),
      ),
      style: const TextStyle(fontWeight: FontWeight.bold),
      onChanged: (val) {
        ref
            .read(playersProvider.notifier)
            .updatePlayerName(playerIdx, val);
      },
      onTap: () {
        // Select all text on tap
        Future.delayed(Duration.zero, () {
          final controller = PrimaryScrollController.of(context);
          if (controller != null) {
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          }
        });
      },
    ),
  ),
),
// ...existing code...
````

**Or, for a simpler and more robust solution, use a `TextEditingController` and select all on tap:**

````dart
// ...inside your DataCell for player name...
final nameController = TextEditingController(text: player.name);

SizedBox(
  width: 120,
  child: TextFormField(
    controller: nameController,
    textAlign: TextAlign.center,
    decoration: const InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      border: OutlineInputBorder(),
    ),
    style: const TextStyle(fontWeight: FontWeight.bold),
    onChanged: (val) {
      ref
          .read(playersProvider.notifier)
          .updatePlayerName(playerIdx, val);
    },
    onTap: () {
      nameController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: nameController.text.length,
      );
    },
  ),
),
// ...existing code...
````

**This will select the whole name when the field is clicked.**

freemansoft: change the name entry text field so that all the text is selected when a user clicks in the field to edit the name

GitHub Copilot: ````dart
// ...existing code...
SizedBox(
  width: 120,
  child: Builder(
    builder: (context) {
      final controller = TextEditingController(text: player.name);
      return TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 8,
          ),
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(fontWeight: FontWeight.bold),
        onChanged: (val) {
          ref
              .read(playersProvider.notifier)
              .updatePlayerName(playerIdx, val);
        },
        onTap: () {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        },
      );
    },
  ),
),
// ...existing code...
````

This change ensures that when a user clicks in the name field, all the text is selected for easy editing.

freemansoft: The text in the name field is now being shown or typed in backwords or reverse

GitHub Copilot: This happens because a new `TextEditingController` is created every build with `text: player.name`. When you set the controller's text like this, the cursor is placed at the start, and Flutter may reverse the text as you type.

**Solution:**
You should not create a new `TextEditingController` on every build. Instead, use the `controller` only for initial value, or better, manage a list of controllers outside the builder, or use `initialValue` without a controller.

**Quick fix:**
Remove the `controller` and use `initialValue`:

````dart
// ...existing code...
return TextFormField(
  initialValue: player.name,
  textAlign: TextAlign.center,
  decoration: const InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      vertical: 6,
      horizontal: 8,
    ),
    border: OutlineInputBorder(),
  ),
  style: const TextStyle(fontWeight: FontWeight.bold),
  onChanged: (val) {
    ref
        .read(playersProvider.notifier)
        .updatePlayerName(playerIdx, val);
  },
  onTap: () {
    // Select all text on tap
    // This only works with a controller, so you can omit this or use a FocusNode solution if needed
  },
);
// ...existing code...
````

**If you want to keep the "select all on tap" feature, you need to manage controllers outside the builder.**
But for most use cases, using `initialValue` is correct and will fix the reversed/backwards typing issue.

freemansoft: I want the text to be entered correctly and all the text to be highlighted when I click in the field.  What changes should I make to the texteditingcontroller and ontap

GitHub Copilot: To ensure the text is entered correctly **and** all text is selected on click, you should:

1. **Do not set both `initialValue` and `controller`** on the same `TextFormField`. Use only the `controller`.
2. **Create the `TextEditingController` only once per player** (not on every build), or at least set its `.text` only when the value changes, not every build.
3. **Select all text in the `onTap` handler** using the controller.

**Quick fix for your current code:**

Replace this block:
```dart
final controller = TextEditingController(
  text: player.name,
);
return TextFormField(
  initialValue: player.name,
  controller: controller,
  ...
  onTap: () {
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  },
);
```

With this:
```dart
final controller = TextEditingController(text: player.name);
return TextFormField(
  controller: controller,
  textAlign: TextAlign.center,
  decoration: const InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      vertical: 6,
      horizontal: 8,
    ),
    border: OutlineInputBorder(),
  ),
  style: const TextStyle(fontWeight: FontWeight.bold),
  onChanged: (val) {
    ref
        .read(playersProvider.notifier)
        .updatePlayerName(playerIdx, val);
  },
  onTap: () {
    // Select all text on tap
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  },
);
```

**But:**
Creating a new controller every build is not ideal. For best results, manage a list of controllers outside the builder (e.g., in your widget's state) and reuse them.
If you want a quick fix, the above will work, but you may see the cursor jump if the widget rebuilds often.

**Summary:**
- Use only `controller`, not `initialValue` with `controller`.
- Set the selection in `onTap`.
- For production, manage controllers outside the builder to avoid cursor jumps.

freemansoft: Lets start over with the player name field editing.

GitHub Copilot: Certainly! Here’s a robust and Flutter-recommended way to handle player name editing so that:

- The text is entered and displayed correctly.
- All text is selected when the user clicks/taps into the field.
- No reversed/backwards text issues occur.

**How to do it:**

1. **Use a TextEditingController for each player.**
2. **Store controllers in a State class (if using StatefulWidget) or in a local variable if you’re OK with recreating them (not recommended for large tables).**
3. **Set the controller’s text only when the player name changes, not on every build.**
4. **Select all text in the onTap handler.**

---

### Example: Minimal Solution for Your Table

Replace your player name field with this code:

````dart
// ...inside your DataCell for player name...
Builder(
  builder: (context) {
    final controller = TextEditingController(text: player.name);
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 8,
        ),
        border: OutlineInputBorder(),
      ),
      style: const TextStyle(fontWeight: FontWeight.bold),
      onChanged: (val) {
        ref.read(playersProvider.notifier).updatePlayerName(playerIdx, val);
      },
      onTap: () {
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
      },
    );
  },
),
````

---

**Note:**
- This works for small tables. For a large table, you should manage controllers in a `StatefulWidget` to avoid creating new controllers every build.
- If you want to avoid the controller being recreated on every build, store a `List<TextEditingController>` in your widget’s state and update their `.text` when the player name changes.

Let me know if you want the advanced version with persistent controllers!

freemansoft: show me the advanced version with persistent controllers and stateful widgets

GitHub Copilot: ````dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'players_provider.dart';

class ScoreTable extends ConsumerStatefulWidget {
  const ScoreTable({super.key});

  @override
  ConsumerState<ScoreTable> createState() => _ScoreTableState();
}

class _ScoreTableState extends ConsumerState<ScoreTable> {
  final Map<int, TextEditingController> _nameControllers = {};

  @override
  void dispose() {
    for (final controller in _nameControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);

    // Keep controllers in sync with player names
    for (int i = 0; i < players.length; i++) {
      final player = players[i];
      if (!_nameControllers.containsKey(i)) {
        _nameControllers[i] = TextEditingController(text: player.name);
      } else if (_nameControllers[i]!.text != player.name) {
        _nameControllers[i]!.text = player.name;
      }
    }

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 1200,
      fixedLeftColumns: 1,
      fixedTopRows: 1,
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      dataRowHeight: 74,
      columns: [
        const DataColumn2(
          label: Text('Player / Total'),
          size: ColumnSize.L,
          fixedWidth: 100,
        ),
        ...List.generate(
          12,
          (round) => DataColumn2(
            label: Text('Round ${round + 1}'),
            size: ColumnSize.S,
          ),
        ),
      ],
      rows: List<DataRow2>.generate(players.length, (playerIdx) {
        final player = players[playerIdx];
        final isEven = playerIdx % 2 == 0;
        final nameController = _nameControllers[playerIdx]!;

        return DataRow2(
          color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return isEven
                  ? Colors.red.withAlpha(20)
                  : Colors.blue.withAlpha(20);
            },
          ),
          cells: [
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      controller: nameController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      onChanged: (val) {
                        ref
                            .read(playersProvider.notifier)
                            .updatePlayerName(playerIdx, val);
                      },
                      onTap: () {
                        nameController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: nameController.text.length,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 120,
                    margin: const EdgeInsets.only(top: 1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${player.totalScore}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            ...List<DataCell>.generate(12, (round) {
              final phase = player.phases.getPhase(round);
              final score = player.scores.getScore(round);
              return DataCell(
                SizedBox(
                  width: 90,
                  child: Column(
                    children: [
                      DropdownButtonFormField<int?>(
                        value: phase,
                        isExpanded: true,
                        hint: const Text('Phase'),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('None'),
                          ),
                          ...List.generate(
                            10,
                            (i) => DropdownMenuItem<int?>(
                              value: i + 1,
                              child: Text('${i + 1}'),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          ref
                              .read(playersProvider.notifier)
                              .updatePhase(playerIdx, round, val);

                          // Show a 10 second alert with all completed phases
                          final completedPhases =
                              player.phases.completedPhasesList();
                          if (completedPhases.isNotEmpty) {
                            final snackBar = SnackBar(
                              content: Text(
                                '${player.name}: ${completedPhases.join(', ')}',
                              ),
                              duration: const Duration(seconds: 10),
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(snackBar);
                          }
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      TextFormField(
                        initialValue: score?.toString() ?? '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Score',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          ref
                              .read(playersProvider.notifier)
                              .updateScore(playerIdx, round, parsed);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
````

**Key points:**
- The widget is now a `ConsumerStatefulWidget`.
- A persistent `TextEditingController` is created for each player and kept in sync with the player name.
- All text is selected on tap.
- No reversed/backwards text issue, and controllers are properly disposed.

freemansoft: Move the round score text field configuration to its on class and file

GitHub Copilot: ````dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundScoreField extends StatelessWidget {
  final int? score;
  final ValueChanged<int?> onChanged;

  const RoundScoreField({
    super.key,
    required this.score,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: score?.toString() ?? '',
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Score',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 8,
        ),
        border: OutlineInputBorder(),
      ),
      onChanged: (val) {
        final parsed = int.tryParse(val);
        onChanged(parsed);
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
````

**Now update your score_table.dart to use this new widget:**

````dart
import 'round_score_field.dart';
// ...existing code...
...List<DataCell>.generate(12, (round) {
  final phase = player.phases.getPhase(round);
  final score = player.scores.getScore(round);
  return DataCell(
    SizedBox(
      width: 90,
      child: Column(
        children: [
          DropdownButtonFormField<int?>(
            // ...existing dropdown config...
          ),
          RoundScoreField(
            score: score,
            onChanged: (parsed) {
              ref
                  .read(playersProvider.notifier)
                  .updateScore(playerIdx, round, parsed);
            },
          ),
        ],
      ),
    ),
  );
}),
// ...existing code...
````

freemansoft: Make the RoundScoreField highlight all the text when a user clicks in the field and make sure the text appears in the correct order as enterfd

GitHub Copilot: ````dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundScoreField extends StatefulWidget {
  final int? score;
  final ValueChanged<int?> onChanged;

  const RoundScoreField({
    super.key,
    required this.score,
    required this.onChanged,
  });

  @override
  State<RoundScoreField> createState() => _RoundScoreFieldState();
}

class _RoundScoreFieldState extends State<RoundScoreField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.score?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant RoundScoreField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = widget.score?.toString() ?? '';
    if (_controller.text != newText) {
      _controller.text = newText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Score',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 8,
        ),
        border: OutlineInputBorder(),
      ),
      onChanged: (val) {
        final parsed = int.tryParse(val);
        widget.onChanged(parsed);
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onTap: () {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      },
    );
  }
}
````

This ensures the text is always entered in the correct order and all text is selected when the field is clicked.

freemansoft: add an ontap to RoundScores so that all the text is selected when the user taps into the field

GitHub Copilot: ````dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundScoreField extends StatefulWidget {
  final int? score;
  final ValueChanged<int?> onChanged;

  const RoundScoreField({
    super.key,
    required this.score,
    required this.onChanged,
  });

  @override
  State<RoundScoreField> createState() => _RoundScoreFieldState();
}

class _RoundScoreFieldState extends State<RoundScoreField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.score?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant RoundScoreField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = widget.score?.toString() ?? '';
    if (_controller.text != newText) {
      _controller.text = newText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Score',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 8,
        ),
        border: OutlineInputBorder(),
      ),
      onChanged: (val) {
        final parsed = int.tryParse(val);
        widget.onChanged(parsed);
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onTap: () {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      },
    );
  }
}
````

freemansoft: Move the name entry text fields and their associated nameControllers TextEditingController to their own PlanerNameField class

GitHub Copilot: ````dart
import 'package:flutter/material.dart';

class PlayerNameField extends StatefulWidget {
  final String name;
  final ValueChanged<String> onChanged;

  const PlayerNameField({
    super.key,
    required this.name,
    required this.onChanged,
  });

  @override
  State<PlayerNameField> createState() => _PlayerNameFieldState();
}

class _PlayerNameFieldState extends State<PlayerNameField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  void didUpdateWidget(covariant PlayerNameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name && _controller.text != widget.name) {
      _controller.text = widget.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 8,
        ),
        border: OutlineInputBorder(),
      ),
      style: const TextStyle(fontWeight: FontWeight.bold),
      onChanged: widget.onChanged,
      onTap: () {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      },
    );
  }
}
````

**Now update your score_table.dart to use this new widget:**

````dart
import 'player_name_field.dart';
// ...existing code...
DataCell(
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 120,
        child: PlayerNameField(
          name: player.name,
          onChanged: (val) {
            ref.read(playersProvider.notifier).updatePlayerName(playerIdx, val);
          },
        ),
      ),
      Container(
        width: 120,
        margin: const EdgeInsets.only(top: 1),
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${player.totalScore}',
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  ),
),
// ...existing code...
````

This moves the name entry field and its controller logic into a reusable `PlayerNameField` widget.

freemansoft: remove the unneedd _name_controllers from scores_table.dart

GitHub Copilot: ````dart
// ...existing code...
class _ScoreTableState extends ConsumerState<ScoreTable> {
  // Removed: final Map<int, TextEditingController> _nameControllers = {};

  @override
  void dispose() {
    // Removed: for (final controller in _nameControllers.values) { controller.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);

    // Removed: name controller sync logic

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 1200,
      fixedLeftColumns: 1,
      fixedTopRows: 1,
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      dataRowHeight: 74,
      columns: [
        const DataColumn2(
          label: Text('Player / Total'),
          size: ColumnSize.L,
          fixedWidth: 100,
        ),
        ...List.generate(
          12,
          (round) => DataColumn2(
            label: Text('Round ${round + 1}'),
            size: ColumnSize.S,
          ),
        ),
      ],
      rows: List<DataRow2>.generate(players.length, (playerIdx) {
        final player = players[playerIdx];
        final isEven = playerIdx % 2 == 0;

        return DataRow2(
          color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            return isEven
                ? Colors.red.withAlpha(20)
                : Colors.blue.withAlpha(20);
          }),
          cells: [
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: PlayerNameField(
                      name: player.name,
                      onChanged: (val) {
                        ref
                            .read(playersProvider.notifier)
                            .updatePlayerName(playerIdx, val);
                      },
                    ),
                  ),
                  Container(
                    width: 120,
                    margin: const EdgeInsets.only(top: 1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${player.totalScore}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            ...List<DataCell>.generate(12, (round) {
              final phase = player.phases.getPhase(round);
              final score = player.scores.getScore(round);
              return DataCell(
                SizedBox(
                  width: 90,
                  child: Column(
                    children: [
                      DropdownButtonFormField<int?>(
                        value: phase,
                        isExpanded: true,
                        hint: const Text('Phase'),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('None'),
                          ),
                          ...List.generate(
                            10,
                            (i) => DropdownMenuItem<int?>(
                              value: i + 1,
                              child: Text('${i + 1}'),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          ref
                              .read(playersProvider.notifier)
                              .updatePhase(playerIdx, round, val);

                          // Show a 10 second alert with all completed phases
                          final completedPhases =
                              player.phases.completedPhasesList();
                          if (completedPhases.isNotEmpty) {
                            final snackBar = SnackBar(
                              content: Text(
                                '${player.name}: ${completedPhases.join(', ')}',
                              ),
                              duration: const Duration(seconds: 10),
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(snackBar);
                          }
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      RoundScoreField(
                        score: score,
                        onChanged: (parsed) {
                          ref
                              .read(playersProvider.notifier)
                              .updateScore(playerIdx, round, parsed);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
// ...existing code...
````

freemansoft: change the toast duration to 2 seconds

GitHub Copilot: ````dart
// ...existing code...
onChanged: (val) {
  ref
      .read(playersProvider.notifier)
      .updatePhase(playerIdx, round, val);

  // Show a 2 second alert with all completed phases
  final completedPhases = player.phases.completedPhasesList();
  if (completedPhases.isNotEmpty) {
    final snackBar = SnackBar(
      content: Text(
        '${player.name}: ${completedPhases.join(', ')}',
      ),
      duration: const Duration(seconds: 2), // Changed to 2 seconds
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(snackBar);
  }
},
// ...existing code...
````