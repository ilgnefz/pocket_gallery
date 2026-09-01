import 'package:flutter/material.dart';

class SidebarChip extends StatefulWidget {
  const SidebarChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final void Function() onTap;

  @override
  State<SidebarChip> createState() => _SidebarChipState();
}

class _SidebarChipState extends State<SidebarChip> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: widget.onTap,
        child: ColoredBox(
          color: Colors.white,
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.selected || isHover
                  ? Theme.of(context).primaryColor
                  : Colors.black,
              // fontWeight: widget.selected ? .bold : .normal,
            ),
          ),
        ),
      ),
    );
  }
}
