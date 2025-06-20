import 'package:flutter/material.dart';

class TotalScoreField extends StatelessWidget {
  final int totalScore;
  final List<int> completedPhases;
  final Key? fieldKey;

  const TotalScoreField({
    required this.totalScore,
    required this.completedPhases,
    this.fieldKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sortedPhases = List<int>.from(completedPhases)..sort();
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      message:
          sortedPhases.isEmpty
              ? 'No completed phases'
              : 'Completed phases: ${sortedPhases.join(', ')}',
      child: SizedBox(
        width: double.infinity,
        child: Text(
          '$totalScore',
          key: fieldKey,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
