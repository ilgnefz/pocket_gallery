import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:pocket_gallery/view/home.dart';
import 'package:signals/signals.dart';

import 'config/app.dart';
import 'config/theme.dart';

void main() async {
  await AppConfig.init();
  SignalsObserver.instance = null;
  // 提高图片缓存上限，避免连续预览高清原图时把临近缓存 LRU 掉；
  // 条目数(much + 数量)必须足够大，否则列表滑动时视口外图片会被提前逐出需重新加载
  final cache = PaintingBinding.instance.imageCache;
  cache.maximumSize = 1000;
  cache.maximumSizeBytes = 512 * 1024 * 1024;
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
      home: FutureHomeView(),
    );
  }
}
