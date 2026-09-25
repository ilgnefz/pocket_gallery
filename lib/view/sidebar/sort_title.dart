import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/component/title.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:signals/signals_flutter.dart';

class SortTitle extends StatelessWidget {
  const SortTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) {
        return SidebarTitle(
          title: '排序',
          action: ClickIcon(
            icon: StatusStore.group()
                ? Icons.folder_open_outlined
                : Icons.folder_off_outlined,
            // size: 20,
            iconSize: 16,
            onTap: StatusStore.updateGroup,
          ),
        );
      },
    );
  }
}
