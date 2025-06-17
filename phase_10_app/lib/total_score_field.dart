import 'package:flutter/material.dart';

class TotalScoreField extends StatelessWidget {
  final int totalScore;
  final Key? fieldKey;

  const TotalScoreField({required this.totalScore, this.fieldKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$totalScore',
      key: fieldKey,
      style: const TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
