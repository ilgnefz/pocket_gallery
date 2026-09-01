import 'dart:io';
import 'dart:isolate';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_gallery/db/dao.dart';
import 'package:pocket_gallery/service/notification.dart';
import 'package:pocket_gallery/src/rust/api/file.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/src/rust/frb_generated.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/view/content/preview.dart';

import 'database.dart';

Future<void> addFolders() async {
  final List<String?> folders = await getDirectoryPaths();

  if (folders.isNotEmpty) {
    List<ImageFile> files = [];
    for (String? folder in folders) {
      if (folder == null) continue;
      // StatusStore.updateLoading(true);
      final existImages = FileStore.list();
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        var cancel = NotificationService.show(folder);
        files = await Isolate.run(() async {
          await RustLib.init();
          return getAllImage(folder: folder, existImages: existImages);
        });
        FileStore.addAll(files);
        // StatusStore.updateLoading(false);
        cancel();
        int count = 0;
        for (ImageFile file in files) {
          await DatabaseService.insert(file);
          count++;
        }
        debugPrint('存储了 $count 条数据到数据库');
      });
    }
  }
}

Future<void> refreshFolders() async {
  List<String> folders = FileStore.folders();
  for (String folder in folders) {
    final existImages = FileStore.list();
    List<ImageFile> files = await Isolate.run(() async {
      await RustLib.init();
      return getAllImage(folder: folder, existImages: existImages);
    });
    FileStore.addAll(files);
    debugPrint('新添加了 ${files.length} 张图片');
  }
}

Future<void> loadImages() async {
  List<ImageItemData> allItems = await DatabaseService.getItems();
  List<ImageFile> files = [];
  for (final item in allItems) {
    if (!await File(item.path).exists()) {
      await DatabaseService.removeById(item.id);
      continue;
    }
    files.add(
      ImageFile(
        id: item.id,
        name: item.name,
        folder: item.folder,
        path: item.path,
        width: item.width,
        height: item.height,
        orientation: ImageOrientation.values[item.orientation],
        modified: int.parse(item.modified),
        size: item.size,
        like: item.like,
      ),
    );
  }
  FileStore.addAll(files);
  debugPrint('读取了 ${files.length} 条数据');
}

void previewImage(BuildContext context, ImageFile image) => showDialog(
  context: context,
  builder: (context) {
    FileStore.updatePreview(image);
    return ContentPreview();
  },
);

Future<void> findImage(ImageFile image) async =>
    await Process.run('explorer.exe', ['/select,', image.path]);

Future<void> likeImage(ImageFile image) async {
  FileStore.updateLike(image);
  await DatabaseService.updateLike(image.id, !image.like);
}

Future<void> removeFolder(String folder) async {
  FileStore.remove(folder);
  await DatabaseService.removeFolder(folder);
}
