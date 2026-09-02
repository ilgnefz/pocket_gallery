import 'dart:io';

import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/service/database.dart';
import 'package:pocket_gallery/service/sort.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:signals/signals_flutter.dart';

import 'filter.dart';

class FileStore {
  static final list = Signal(<ImageFile>[]);

  static Future<void> updateLike(ImageFile image) async {
    final currentList = list.value;
    int index = currentList.indexWhere((e) => e.path == image.path);
    if (index != -1) {
      currentList[index].like = !currentList[index].like;
      list.set(currentList, force: true);
      await DatabaseService.updateLike(image.id, !image.like);
    }
  }

  // static void add(ImageFile value) => list.add(value);

  static Future<void> addAll(List<ImageFile> value) async {
    list.addAll(value);
    for (var item in value) {
      await DatabaseService.insert(item);
    }
  }

  static Future<void> remove(ImageFile value) async {
    list.remove(value);
    await DatabaseService.removeById(value.id);
  }

  static Future<void> removeFolder(String folder) async {
    list.removeWhere((e) => e.folder == folder);
    await DatabaseService.removeFolder(folder);
    if (FilterStore.folder() == folder) FilterStore.updateFolder('');
  }

  static Future<void> removeNotExist() async {
    final removeTargets = <ImageFile>[];
    for (var item in list()) {
      if (!await File(item.path).exists()) {
        removeTargets.add(item);
      }
    }
    for (var item in removeTargets) {
      await DatabaseService.removeById(item.id);
    }
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
              FilterStore.showOrientation().isAll ||
              e.orientation == FilterStore.showOrientation(),
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
    switch (FilterStore.sort()) {
      case SortType.none:
        break;
      case SortType.nameAscending:
        list.sort((a, b) => SortService.compareExtend(a.name, b.name));
        break;
      case SortType.nameDescending:
        list.sort((a, b) => SortService.compareExtend(b.name, a.name));
        break;
      case SortType.sizeAscending:
        list.sort((a, b) => a.size.compareTo(b.size));
        break;
      case SortType.sizeDescending:
        list.sort((a, b) => b.size.compareTo(a.size));
        break;
      case SortType.orientationAscending:
        list.sort(
          (a, b) => (a.width * a.height).compareTo((b.width * b.height)),
        );
        break;
      case SortType.orientationDescending:
        list.sort(
          (a, b) => (b.width * b.height).compareTo((a.width * a.height)),
        );
        break;
    }
    return list;
  });

  static final total = computed(() => sortList().length);

  static final folders = computed(() {
    Set<String> folders = {};
    for (var item in list()) {
      folders.add(item.folder);
    }
    return folders.toList();
  });

  static final preview = Signal<ImageFile?>(null);
  static void updatePreview(ImageFile value) => preview.value = value;
}
