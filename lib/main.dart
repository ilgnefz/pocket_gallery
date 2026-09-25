import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:pocket_gallery/view/home.dart';
import 'package:signals/signals.dart';

import 'config/app.dart';
import 'config/theme.dart';

// TODO: 文件改变内容不改变名称，更新信息

void main() async {
  await AppConfig.init();
  SignalsObserver.instance = null;
  // 提高图片缓存上限，避免连续预览高清原图时把临近缓存 LRU 掉
  final cache = PaintingBinding.instance.imageCache;
  cache.maximumSize = 24;
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
