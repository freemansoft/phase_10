import 'package:flutter/material.dart';

class PhaseCheckboxDropdown extends StatelessWidget {
  final int? selectedPhase;
  final ValueChanged<int?> onChanged;
  final int playerIdx;
  final int round;
  final List<int?> completedPhases;
  final Key? fieldKey;

  const PhaseCheckboxDropdown({
    this.fieldKey,
    required this.selectedPhase,
    required this.onChanged,
    required this.playerIdx,
    required this.round,
    required this.completedPhases,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int?>(
      key: fieldKey,
      tooltip: 'Select completed phase(s)',
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          selectedPhase != null ? 'Phase $selectedPhase' : 'None',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder:
          (context) => [
            const PopupMenuItem<int?>(value: null, child: Text('None')),
            ...List.generate(10, (i) {
              final phaseNum = i + 1;
              return CheckedPopupMenuItem<int?>(
                value: phaseNum,
                checked: completedPhases.contains(phaseNum),
                child: Text('Phase $phaseNum'),
              );
            }),
          ],
      onSelected: (val) {
        onChanged(val);
      },
    );
  }
}
