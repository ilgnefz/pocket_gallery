import 'package:flutter/material.dart';
import 'package:pocket_gallery/constant/num.dart';

class SidebarTitle extends StatelessWidget {
  const SidebarTitle({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    Widget child = Text(title, style: Theme.of(context).textTheme.titleSmall);

    if (action != null) {
      child = Row(mainAxisAlignment: .spaceBetween, children: [child, action!]);
    }

    return Container(
      height: AppNum.sidebarTitleH,
      padding: .symmetric(horizontal: AppNum.padding),
      alignment: .centerLeft,
      child: child,
    );
  }
}
