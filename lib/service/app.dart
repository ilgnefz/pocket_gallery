import 'dart:io';
import 'dart:isolate';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:pocket_gallery/constant/key.dart';
import 'package:pocket_gallery/database/dao.dart';
import 'package:pocket_gallery/service/notification.dart';
import 'package:pocket_gallery/service/storage.dart';
import 'package:pocket_gallery/src/rust/api/file.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/src/rust/frb_generated.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:pocket_gallery/view/content/preview.dart';

import 'database.dart';

Future<void> dragFolders(List<DropItem> list) async {
  List<String> folders = [];
  for (DropItem file in list) {
    FileSystemEntityType type = FileSystemEntity.typeSync(file.path);
    if (type == FileSystemEntityType.directory) {
      folders.add(file.path);
    }
  }
  await parseFolders(folders);
}

Future<void> addFolders() async {
  final List<String?> folders = await getDirectoryPaths();
  if (folders.isEmpty) return;
  // 并行扫描所有文件夹，并等待全部完成后再持久化，避免竞态
  await parseFolders(folders);
}

Future<void> parseFolders(List<String?> folders) async {
  final tasks = <Future<void>>[];
  for (String? folder in folders) {
    if (folder == null) continue;
    tasks.add(() async {
      final existImages = FileStore.list();
      var cancel = NotificationService.show(folder);
      final result = await Isolate.run(() async {
        await RustLib.init();
        return getAllImage(folder: folder, existImages: existImages);
      });
      cancel();
      // changed：路径被新文件占用，旧记录（旧 id）已过期，先移除
      final changedPaths = result.changed.map((e) => e.path).toSet();
      for (final p in changedPaths) {
        await FileStore.removeByPath(p);
      }
      await FileStore.addAll([...result.added, ...result.changed]);
      debugPrint('存储了 ${result.added.length + result.changed.length} 条数据到数据库');
    }());
  }
  await getBlurHash();
  await Future.wait(tasks);
  await StorageService.setStringList(AppKey.folders, FileStore.folders());
}

Future<void> refreshFolders() async {
  List<String> folders = FileStore.folders();
  await FileStore.removeNotExist();
  final existImages = FileStore.list();
  for (String folder in folders) {
    final result = await Isolate.run(() async {
      await RustLib.init();
      return getAllImage(
        folder: folder,
        existImages: existImages,
        recursive: false,
      );
    });
    // changed：路径被新文件占用，旧记录（旧 id）已过期，先移除
    final changedPaths = result.changed.map((e) => e.path).toSet();
    for (final p in changedPaths) {
      await FileStore.removeByPath(p);
    }
    await FileStore.addAll([...result.added, ...result.changed]);
    debugPrint('新添加了 ${result.added.length + result.changed.length} 张图片');
  }
}

Future<void> loadImages() async {
  StatusStore.updateLoading(true);
  FileStore.folderOrder.set(
    StorageService.getStringList(AppKey.foldersOrder),
    force: true,
  );
  List<ImageItemData> allItems = await DatabaseService.getItems();
  // 并行检查文件是否存在
  final exists = await Future.wait(
    allItems.map((item) => File(item.path).exists()),
  );
  final removeIds = <String>[];
  final files = <ImageFile>[];
  for (int i = 0; i < allItems.length; i++) {
    final item = allItems[i];
    if (!exists[i]) {
      removeIds.add(item.id);
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
        blurhash: item.blurhash,
        like: item.like,
      ),
    );
  }
  await Future.wait(removeIds.map((id) => DatabaseService.removeById(id)));
  await FileStore.addAll(files, false);
  debugPrint('读取了 ${files.length} 条数据');
  StatusStore.updateLoading(false);
}

Future<void> getBlurHash() async {
  debugPrint('开始获取图片的 blurhash');
  final targets = FileStore.list().where((e) => e.blurhash.isEmpty).toList();
  if (targets.isEmpty) return;
  // 受限并发：避免一次性解码过多大图吃满 CPU/内存
  const concurrency = 4;
  var index = 0;
  Future<void> worker() async {
    while (index < targets.length) {
      final file = targets[index++];
      final hash = await generateBlurhash(path: file.path);
      if (hash.isNotEmpty) await FileStore.updateBlurHash(file, hash);
    }
  }

  await Future.wait(List.generate(concurrency, (_) => worker()));
  debugPrint('结束获取图片的 blurhash');
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

Future<void> likeImage(ImageFile image, [bool isPreview = false]) async {
  if (!await checkExist(image)) return;
  await FileStore.updateLike(image, isPreview);
}

Future<void> removeFolder(String folder) async {
  await FileStore.removeFolder(folder);
  List<String> folders = StorageService.getStringList(AppKey.folders);
  folders.remove(folder);
  await StorageService.setStringList(AppKey.folders, folders);
}

Future<bool> checkExist(ImageFile image) async {
  if (!await File(image.path).exists()) {
    await FileStore.remove(image);
    return false;
  }
  return true;
}

void prev() {
  List<ImageFile> list = FileStore.sortList();
  int index = list.indexWhere(
    (element) => element.path == FileStore.preview()!.path,
  );
  index = index == 0 ? list.length - 1 : index - 1;
  FileStore.updatePreview(list[index]);
}

void next() {
  List<ImageFile> list = FileStore.sortList();
  int index = list.indexWhere(
    (element) => element.path == FileStore.preview()!.path,
  );
  index = index == list.length - 1 ? 0 : index + 1;
  FileStore.updatePreview(list[index]);
}
