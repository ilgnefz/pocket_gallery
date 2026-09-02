import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

import 'config/app.dart';
import 'config/theme.dart';
import 'view/home.dart';

// TODO: 文件改变内容不改变名称，更新信息

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
      title: 'PocketGallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.light(context),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: HomeView(),
    );
  }
}
