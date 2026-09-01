import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:pocket_gallery/view/top/filter.dart';
import 'package:pocket_gallery/view/top/input.dart';
import 'package:signals/signals_flutter.dart';

class TopView extends StatelessWidget {
  const TopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      padding: .symmetric(horizontal: 12.0),
      child: Row(
        spacing: 8.0,
        crossAxisAlignment: .center,
        children: [
          SignalBuilder(
            builder: (_) => Text(
              '共有 ${FileStore.total()} 张图片',
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          IconButton(onPressed: refreshFolders, icon: Icon(Icons.refresh)),
          const Spacer(),
          TopInput(),
          SizedBox.shrink(),
          TopFilter(),
          IconButton(
            onPressed: addFolders,
            icon: Icon(Icons.create_new_folder_outlined),
          ),
          SignalBuilder(
            builder: (BuildContext context) => AnimatedRotation(
              turns: StatusStore.mode() == SideMenuMode.open ? 0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                onPressed: StatusStore.updateMode,
                icon: Icon(Icons.menu_open_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
