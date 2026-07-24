import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rf_viewer/service/storage.dart';
import 'package:rf_viewer/src/rust/api/file.dart';
import 'package:rf_viewer/src/rust/api/model.dart';
import 'package:rf_viewer/src/rust/frb_generated.dart';
import 'package:rf_viewer/store/file.dart';
import 'package:rf_viewer/store/status.dart';
import 'package:rf_viewer/view/content/content.dart';
import 'package:rf_viewer/view/siderbar/sidebar.dart';
import 'package:rf_viewer/view/top/top.dart';
import 'package:window_manager/window_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WindowListener {
  final String folderKey = 'folder';

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    Future.delayed(Duration.zero, () async {
      await windowManager.setPreventClose(true);
    });
    List<String> folders = StorageService.getStringList(folderKey);
    if (folders.isNotEmpty) {
      StatusStore.updateLoading(true);
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        List<ImageFile> files = await Isolate.run(() async {
          await RustLib.init();
          return getAllImage(folders: folders, existFiles: []);
        });
        FileStore.addAll(files);
        StatusStore.updateLoading(false);
      });
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    List<String> folders = FileStore.folders();
    await StorageService.setStringList(folderKey, folders);
    await windowManager.destroy();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopView(),
          Expanded(
            child: Row(
              children: [
                Expanded(child: ContentView()),
                SidebarView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
