import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

import 'config/app.dart';
import 'config/theme.dart';
import 'view/home.dart';

void main() async {
  await AppConfig.init();
  SignalsObserver.instance = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFViewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.light(context),
      home: HomeView(),
    );
  }
}
