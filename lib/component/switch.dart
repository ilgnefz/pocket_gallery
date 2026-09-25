import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';

class SlidingSwitch extends StatelessWidget {
  const SlidingSwitch({
    super.key,
    required this.initialValue,
    required this.children,
    required this.onValueChanged,
  });

  final int initialValue;
  final Map<int, Widget> children;
  final void Function(int) onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomSlidingSegmentedControl<int>(
        height: 32,
        initialValue: initialValue + 1,
        children: children,
        customSegmentSettings: CustomSegmentSettings(
          mouseCursor: SystemMouseCursors.click,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(8),
        ),
        thumbDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInToLinear,
        onValueChanged: onValueChanged,
      ),
    );
  }
}
