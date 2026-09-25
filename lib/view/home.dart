import 'package:flutter/material.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/view/sidebar/sidebar.dart';
import 'package:pocket_gallery/view/top/top.dart';
import 'package:window_manager/window_manager.dart';

class FutureHomeView extends StatefulWidget {
  const FutureHomeView({super.key});

  @override
  State<FutureHomeView> createState() => _FutureHomeViewState();
}

class _FutureHomeViewState extends State<FutureHomeView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await loadImages();
      await refreshFolders();
      await getBlurHash();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragToResizeArea(
      child: Scaffold(
        body: Column(
          children: [
            TopView(),
            Expanded(child: SidebarView()),
          ],
        ),
      ),
    );
  }
}
