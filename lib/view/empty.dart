import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('暂无任何图片', style: TextStyle(fontSize: 20)));
  }
}
