import 'package:flutter/material.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/view/content/content.dart';
import 'package:pocket_gallery/view/siderbar/sidebar.dart';
import 'package:pocket_gallery/view/top/top.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await loadImages();
      await refreshFolders();
    });
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
