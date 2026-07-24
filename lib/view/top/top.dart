import 'dart:isolate';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:rf_viewer/src/rust/api/file.dart';
import 'package:rf_viewer/src/rust/api/model.dart';
import 'package:rf_viewer/src/rust/frb_generated.dart';
import 'package:rf_viewer/store/file.dart';
import 'package:rf_viewer/store/status.dart';
import 'package:rf_viewer/view/top/filter.dart';
import 'package:rf_viewer/view/top/input.dart';
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
          IconButton(
            onPressed: () {
              StatusStore.updateLoading(true);
              SchedulerBinding.instance.addPostFrameCallback((_) async {
                List<ImageFile> files = await Isolate.run(() async {
                  await RustLib.init();
                  return getAllImage(
                    folders: FileStore.folders(),
                    existFiles: [],
                  );
                });
                FileStore.addAll(files);
                StatusStore.updateLoading(false);
              });
            },
            icon: Icon(Icons.refresh),
          ),
          const Spacer(),
          TopInput(),
          SizedBox.shrink(),
          TopFilter(),
          IconButton(
            onPressed: () async {
              final List<String?> folders = await getDirectoryPaths();
              if (folders.isNotEmpty) {
                StatusStore.updateLoading(true);
                await SchedulerBinding.instance.endOfFrame;
                List<ImageFile> existFiles = FileStore.list();
                List<ImageFile> files = await Isolate.run(() async {
                  await RustLib.init();
                  return getAllImage(
                    folders: folders as List<String>,
                    existFiles: existFiles,
                  );
                });
                FileStore.addAll(files);
                StatusStore.updateLoading(false);
              }
            },
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
