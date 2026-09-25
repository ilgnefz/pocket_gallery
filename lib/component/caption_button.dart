import 'package:flutter/material.dart';

import 'icon.dart';

class CaptionButton extends StatelessWidget {
  const CaptionButton({
    super.key,
    required this.svg,
    required this.color,
    required this.onPressed,
  });

  final String svg;
  final Color? color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: onPressed,
        child: Container(
          width: 48,
          alignment: Alignment.center,
          child: BaseIcon(svg: svg, size: 12.0, color: color),
        ),
      ),
    );
  }
}
