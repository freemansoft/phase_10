# phase_10 AI coding test bed

This repo holds code generated by various models without any editing other than one include file that is commented out. All of the solutions are single dart files that can be run in VSCode or on the command line.

## Our desires

I want to build a program that can act as a score sheet for the "phase 10" card game. This does not implement any of the game rules. It is just a fancy piece of paper

## Dart files.

Each file contains the output of a copilot or other LLM.  The context was adjusted to exclude the workspace so that previous files should not affect the output of a given AI prompt.

## Our prompt

This is exactly the prompt used


Create a flutter main.dart to implement the following game program in Flutter.

A game score-keeping application built in flutter for the card game "phase 10".

The application should have an appbar and a switch to support light and dark mode.

The program should capture individual phase/round scores for 8 players for up to 12 rounds, and calculate the total score for each player as the sum of the round scores. It should also display the sum of the round scores and a place for an editable player name

The UI should be a horizontally scrollable tabular UI that displays the player's name and total points in the first column of each row.   The table should scroll like a spreadsheet where the player's name and total are fixed while the rest of the spreadsheet can scroll horizontally. Use a Flutter table type that can freeze the first column.

The first column of the UI should show the total score for each player and the player's name at the start of each row. The player's name should be editable. The total score field holds the sum of the scores in that row.

The next 12 columns hold the information for an individual round. There are two fields for each round. The individual round information fields contain the points for that round and a droplist containing the phase completed in that round, if any.   The score attribute is a numeric input field. The phase completed dropdown should offer a blank value and the numbers 1 through 10

## Variations

* For Gemeni flash the "Create a" had to be changed to "update a"
* The same for gpt_4.1 pre
* Gemeni 2.0 flash wouldn't generate another copy because it found stuff that already did what I asked when asking for light dark
* Sometimes I had to say "ignore all the existing files"
* gemini 2.0 trying to add light and dark invalid code
*