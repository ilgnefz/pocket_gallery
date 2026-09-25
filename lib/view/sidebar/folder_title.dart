import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/component/title.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:signals/signals_flutter.dart';

class FolderTitle extends StatelessWidget {
  const FolderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) => SidebarTitle(
        title: '文件夹 (${FileStore.folders().length})',
        action: ClickIcon(
          icon: StatusStore.sort()
              ? Icons.check
              : Icons.format_list_numbered_rounded,
          iconSize: 16,
          onTap: StatusStore.updateSort,
        ),
      ),
    );
  }
}
