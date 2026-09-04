import 'dart:io';

import 'package:pocket_gallery/constant/key.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/service/database.dart';
import 'package:pocket_gallery/service/sort.dart';
import 'package:pocket_gallery/service/storage.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:signals/signals_flutter.dart';

import 'filter.dart';
import 'status.dart';

class FileStore {
  static final list = Signal(<ImageFile>[]);
  // 文件夹的展示顺序（可持久化），图片默认排序也依赖它
  static final folderOrder = Signal(<String>[]);

  static Future<void> reorderFolder(int oldIndex, int newIndex) async {
    final folders = List<String>.of(folderOrder());
    // if (newIndex > oldIndex) newIndex -= 1;
    final f = folders.removeAt(oldIndex);
    folders.insert(newIndex, f);
    folderOrder.set(folders, force: true);
    await StorageService.setStringList(AppKey.foldersOrder, folders);
  }

  static Future<void> updateLike(ImageFile image) async {
    final currentList = list.value;
    int index = currentList.indexWhere((e) => e.path == image.path);
    if (index != -1) {
      final target = currentList[index];
      target.like = !target.like;
      list.set(currentList, force: true);
      await DatabaseService.updateLike(target.id, target.like);
    }
  }

  // static void add(ImageFile value) => list.add(value);

  static Future<void> addAll(
    List<ImageFile> value, [
    bool saveToDB = true,
  ]) async {
    if (value.isEmpty) return;
    if (saveToDB) {
      for (var item in value) {
        await DatabaseService.insert(item);
      }
    }
    // 按文件夹归并插入：新文件插入到同名文件夹已有文件之后，
    // 全新文件夹整体追加到末尾，避免每次刷新后新文件堆积到列表最后。
    final result = List<ImageFile>.of(list());
    final byFolder = <String, List<ImageFile>>{};
    final newFolders = <String>[];
    for (var f in value) {
      if (!byFolder.containsKey(f.folder)) {
        byFolder[f.folder] = [];
        newFolders.add(f.folder);
      }
      byFolder[f.folder]!.add(f);
    }
    for (final folder in newFolders) {
      final newFiles = byFolder[folder]!;
      int insertAt = result.length;
      for (int i = result.length - 1; i >= 0; i--) {
        if (result[i].folder == folder) {
          insertAt = i + 1;
          break;
        }
      }
      result.insertAll(insertAt, newFiles);
    }
    list.set(result, force: true);
    // 维护文件夹顺序：新出现的文件夹追加到已有顺序之后
    final order = List<String>.of(folderOrder());
    var changed = false;
    for (final folder in newFolders) {
      if (!order.contains(folder)) {
        order.add(folder);
        changed = true;
      }
    }
    if (changed) folderOrder.set(order, force: true);
  }

  static Future<void> remove(ImageFile value) async {
    list.remove(value);
    await DatabaseService.removeById(value.id);
  }

  static Future<void> removeFolder(String folder) async {
    list.removeWhere((e) => e.folder == folder);
    await DatabaseService.removeFolder(folder);
    if (FilterStore.folder() == folder) FilterStore.updateFolder('');
    // 同步清理文件夹顺序并持久化，避免残留脏数据
    final order = List<String>.of(folderOrder())..remove(folder);
    folderOrder.set(order, force: true);
    await StorageService.setStringList(AppKey.foldersOrder, order);
  }

  static Future<void> removeNotExist() async {
    final items = list();
    // 并行检查文件是否存在，避免大图库时逐个 await 阻塞
    final exists = await Future.wait(
      items.map((item) => File(item.path).exists()),
    );
    final removeTargets = <ImageFile>[];
    for (int i = 0; i < items.length; i++) {
      if (!exists[i]) removeTargets.add(items[i]);
    }
    await Future.wait(
      removeTargets.map((item) => DatabaseService.removeById(item.id)),
    );
    list.removeWhere(removeTargets.contains);
  }

  // static void clear() => list.clear();

  static final filterList = computed(() {
    List<ImageFile> result = list()
        .where((e) {
          switch (FilterStore.show()) {
            case ShowType.all:
              return true;
            case ShowType.like:
              return e.like;
            case ShowType.unlike:
              return !e.like;
          }
        })
        .where((e) => e.name.contains(FilterStore.search()))
        .where(
          (e) =>
              FilterStore.orientation().isAll ||
              e.orientation == FilterStore.orientation(),
        )
        .where(
          (e) =>
              FilterStore.folder().isEmpty || e.folder == FilterStore.folder(),
        )
        .toList();
    return result;
  });

  static final sortList = computed(() {
    final list = List<ImageFile>.of(filterList());
    final sort = FilterStore.sort();

    // 无显式排序：按文件夹顺序(folderOrder)分组排列，组内保持原有相对顺序
    if (sort == SortType.none) {
      if (folderOrder().isNotEmpty) {
        final ordered = <ImageFile>[];
        for (final f in folderOrder()) {
          ordered.addAll(list.where((e) => e.folder == f));
        }
        ordered.addAll(list.where((e) => !folderOrder().contains(e.folder)));
        return ordered;
      }
      return list;
    }

    // 提取排序比较器
    int Function(ImageFile, ImageFile) comparator;
    switch (sort) {
      case SortType.none:
        // 前面已提前 return，此分支仅为满足 switch 穷尽性
        comparator = (a, b) => 0;
        break;
      case SortType.nameAscending:
        comparator = (a, b) => SortService.compareExtend(a.name, b.name);
        break;
      case SortType.nameDescending:
        comparator = (a, b) => SortService.compareExtend(b.name, a.name);
        break;
      case SortType.dateAscending:
        comparator = (a, b) => a.modified.compareTo(b.modified);
        break;
      case SortType.dateDescending:
        comparator = (a, b) => b.modified.compareTo(a.modified);
        break;
      case SortType.sizeAscending:
        comparator = (a, b) => a.size.compareTo(b.size);
        break;
      case SortType.sizeDescending:
        comparator = (a, b) => b.size.compareTo(a.size);
        break;
      case SortType.orientationAscending:
        comparator = (a, b) =>
            (a.width * a.height).compareTo((b.width * b.height));
        break;
      case SortType.orientationDescending:
        comparator = (a, b) =>
            (b.width * b.height).compareTo((a.width * a.height));
        break;
    }

    // 分组排序：按文件夹分组，组内各自排序，文件夹之间仍按 folderOrder
    if (StatusStore.group()) {
      final ordered = <ImageFile>[];
      for (final f in folderOrder()) {
        final group = list.where((e) => e.folder == f).toList()
          ..sort(comparator);
        ordered.addAll(group);
      }
      final rest = list.where((e) => !folderOrder().contains(e.folder)).toList()
        ..sort(comparator);
      ordered.addAll(rest);
      return ordered;
    }

    // 全体一起排序
    list.sort(comparator);
    return list;
  });

  static final total = computed(() => sortList().length);

  static final folders = computed(() {
    final set = <String>{};
    for (var item in list()) {
      set.add(item.folder);
    }
    if (set.isEmpty) return <String>[];
    final order = folderOrder().where(set.contains).toList();
    // 用 Set 判重，避免 order.contains 造成 O(n²)
    final known = order.toSet();
    order.addAll(set.where((e) => !known.contains(e)));
    return order;
  });

  static final preview = Signal<ImageFile?>(null);
  static void updatePreview(ImageFile value) => preview.value = value;
}
