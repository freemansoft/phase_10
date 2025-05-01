# phase_10_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Things that were hard

| Issue                                                                                                      | Resolution |
| ---------------------------------------------------------------------------------------------------------- | ---------- |
| Column widths                                                                                              | sort of    |
| Altnerating background colors for the header **column**                                                    | no         |
| Highlighting the text on click and managing TextEditingController so that the text went in the right order | yes        |
| New-Game functionality took a couple trys where I rolled back and then tried again                         | yes        |
| Hover over a player to show their completed phases                                                         | no         |

## Prompt logs from the inital session

[Chat JSON file exported from vs code.](chat_1.json).

- Saved with `ctrl-shift-p` `Chat export chat`.
- Can Reload into VSCode with `ctrl-p` `Chat: import chat`
- Makrdown version exists at [Chat md file](chat_1.md).

[Chat Markdown file exported from vs code.](chat_1.md)

- Saved with
- Cursor in chat view
- `right mouse` `copy all`
- Paste into chat_1.md

## Initial Prompt

Create Flutter application code using this prompt. The output should be a complete flutter application with all necessary files and folders.

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
