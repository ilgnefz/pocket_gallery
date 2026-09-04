import 'package:flutter/material.dart';
import 'package:pocket_gallery/constant/num.dart';

class SidebarWrap extends StatelessWidget {
  const SidebarWrap({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(top: 4.0, left: AppNum.padding, right: AppNum.padding),
      child: Wrap(spacing: 12.0, runSpacing: 4.0, children: children),
    );
  }
}
