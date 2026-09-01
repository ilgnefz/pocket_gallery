import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/service/storage.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/view/content/content.dart';
import 'package:pocket_gallery/view/siderbar/sidebar.dart';
import 'package:pocket_gallery/view/top/top.dart';
import 'package:window_manager/window_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    Future.delayed(Duration.zero, () async {
      await windowManager.setPreventClose(true);
      await loadImages();
      await refreshFolders();
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    List<String> folders = FileStore.folders();
    await StorageService.setStringList('folder', folders);
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
