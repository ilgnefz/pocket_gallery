import 'package:flutter/material.dart';
import 'package:pocket_gallery/service/database.dart';
import 'package:pocket_gallery/service/storage.dart';
import 'package:pocket_gallery/src/rust/frb_generated.dart';
import 'package:window_manager/window_manager.dart';

class AppConfig {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await RustLib.init();

    DatabaseService.init();

    await StorageService.init();

    final Size size = Size(1000, 600);

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: size,
      minimumSize: size,
      center: true,
      title: 'PocketGallery',
      // titleBarStyle: TitleBarStyle.hidden,
      // backgroundColor: Colors.transparent,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.maximize();
      await windowManager.show();
      await windowManager.focus();
      // await windowManager.setAsFrameless();
      // await windowManager.setHasShadow(true);
    });
  }
}
