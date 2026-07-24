import 'package:flutter/material.dart';
import 'package:rf_viewer/service/storage.dart';
import 'package:rf_viewer/src/rust/frb_generated.dart';
import 'package:window_manager/window_manager.dart';

class AppConfig {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await RustLib.init();

    await StorageService.init();

    final Size size = Size(1000, 600);

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: size,
      minimumSize: size,
      center: true,
      title: 'RFViewer',
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
