import 'package:flutter/material.dart';

class SidebarTitle extends StatelessWidget {
  const SidebarTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: .bold),
    );
  }
}
