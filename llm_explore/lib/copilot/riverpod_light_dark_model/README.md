# phase_10_2

This is a variation of the `riverpod light dark` but where I told it the state classes.

## Generated files

| File                       | compiles | run issues    |
| -------------------------- | -------- | ------------- |
| main_claud_3_5_sonnet.dart | yes      | blank         |
| main_gemini_2_0_flash.dart | yes      | runs but ugly |
| main_gpt_41.dart           | yes      | blank         |
| main_gpt_4o.dart           | yes      | blank         |

## LLM Context

I used this pubspec.yaml as the context

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.6.1
  data_table_2: ^2.6.0
  hooks_riverpod: ^2.6.1
  horizontal_data_table: ^4.3.1
  google_sign_in: ^6.2.1
  googleapis: ^12.0.0
  googleapis_auth: ^1.4.1

```

## Prompt

Create Flutter main.dart to implement the a game scoring program. Update main.dart to implement this.

- This is a flutter based score-keeping application that can be used when playing the card game "phase 10".
- The game is played by 8 players and consists of up to 12 rounds.
- For each round the program accepts a round score and an optional phase completion value.
- The program calculates the total of the round scores for each player whenever a round score is updated and displays total

- There is a player object to hold each player's state including their name and their scores object and their phases object.
- There is a scores object to hold all player's round scores and the total of the round scores
- There is a phases object that holds all of the completed phases for a single player.

- The UI should be a horizontally scrolling table that displays each player in their own row.
- The first column is frozen and the following colums scroll.
- Use a third party table library
- State should be managed with riverpod 2 or riverpod 3 and use the "ref" syntax and not ScopedReader

- The first column of each row displays the player's name and total points scored by that player. It should always be visible.
- The second section containing 12 columns is the rounds section. The rounds section of the table should horizontally scrollable
- Each of the 12 round columns has two fields. The first field contains the phase number completed for that round. The second field in each column is an editable text field that captures the points scored in that round. The two fields in each cell can be arranged vertically hor horizontally.
- The round score field is an editable numeric input field.
- The round phase completed dropdown offers a blank option and the numbers 1 through 10
- A person's total score is updated whenever a score for one of the rounds  is updated.

- Use a table library that supports frozen columns and rows while letting the rest of the table scroll horizontally.
- Round score entry fields should only accept numeric data

- The application should have an appbar with a title "Phase-10 Scoreboard" .
- There is a switch on the appbar to toggle between light and dark mode.
- There should be a button that saves the data in a google sheet.



