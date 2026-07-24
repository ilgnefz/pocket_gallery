import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: .center,
          child: SizedBox(
            width: 250,
            height: 250,
            child: CircularProgressIndicator(
              strokeWidth: 24,
              backgroundColor: Colors.grey[100],
            ),
          ),
        ),
        Align(
          alignment: .center,
          child: Text(
            '加载中',
            style: TextStyle(
              fontSize: 48,
              fontWeight: .bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
