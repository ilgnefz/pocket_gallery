import 'dart:io';
import 'dart:isolate';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_gallery/db/dao.dart';
import 'package:pocket_gallery/service/notification.dart';
import 'package:pocket_gallery/service/storage.dart';
import 'package:pocket_gallery/src/rust/api/file.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/src/rust/frb_generated.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:pocket_gallery/view/content/preview.dart';

import 'database.dart';

Future<void> addFolders() async {
  final List<String?> folders = await getDirectoryPaths();
  if (folders.isNotEmpty) {
    List<ImageFile> files = [];
    for (String? folder in folders) {
      if (folder == null) continue;
      final existImages = FileStore.list();
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        var cancel = NotificationService.show(folder);
        files = await Isolate.run(() async {
          await RustLib.init();
          return getAllImage(folder: folder, existImages: existImages);
        });
        cancel();
        await FileStore.addAll(files);
        debugPrint('存储了 ${files.length} 条数据到数据库');
      });
    }
    await Future.delayed(Duration(milliseconds: 300));
    await StorageService.setStringList('folder', FileStore.folders());
  }
}

Future<void> refreshFolders() async {
  List<String> folders = FileStore.folders();
  await FileStore.removeNotExist();
  final existImages = FileStore.list();
  for (String folder in folders) {
    List<ImageFile> files = await Isolate.run(() async {
      await RustLib.init();
      return getAllImage(
        folder: folder,
        existImages: existImages,
        recursive: false,
      );
    });
    await FileStore.addAll(files);
    debugPrint('新添加了 ${files.length} 张图片');
  }
}

Future<void> loadImages() async {
  StatusStore.updateLoading(true);
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
  await FileStore.addAll(files, false);
  debugPrint('读取了 ${files.length} 条数据');
  StatusStore.updateLoading(false);
}

Future<void> previewImage(BuildContext context, ImageFile image) async {
  if (!await checkExist(image)) return;
  if (!context.mounted) return;
  return showDialog(
    context: context,
    builder: (context) {
      FileStore.updatePreview(image);
      return ContentPreview();
    },
  );
}

Future<void> findImage(ImageFile image) async {
  if (!await checkExist(image)) return;
  await Process.run('explorer.exe', ['/select,', image.path]);
}

Future<void> likeImage(ImageFile image) async {
  if (!await checkExist(image)) return;
  await FileStore.updateLike(image);
}

Future<void> removeFolder(String folder) async {
  await FileStore.removeFolder(folder);
  List<String> folders = StorageService.getStringList('folder');
  folders.remove(folder);
  await StorageService.setStringList('folder', folders);
}

Future<bool> checkExist(ImageFile image) async {
  if (!await File(image.path).exists()) {
    await FileStore.remove(image);
    return false;
  }
  return true;
}
