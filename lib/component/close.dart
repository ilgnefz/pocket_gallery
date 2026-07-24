import 'package:flutter/material.dart';

class CloseIcon extends StatelessWidget {
  const CloseIcon({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: .circular(10)),
        child: Icon(Icons.close_rounded, size: 18, color: Colors.grey),
      ),
    );
  }
}
