import 'package:rf_viewer/enum/enum.dart';
import 'package:rf_viewer/src/rust/api/model.dart';
import 'package:rf_viewer/store/filter.dart';
import 'package:signals/signals_flutter.dart';

class FileStore {
  static final list = Signal(<ImageFile>[]);

  static void add(ImageFile value) => list.add(value);

  static void addAll(List<ImageFile> value) => list.addAll(value);

  static void remove(String folder) {
    list.removeWhere((e) => e.folder == folder);
    if (FilterStore.folder() == folder) FilterStore.updateFolder('');
  }

  static void clear() => list.clear();

  static final filterList = computed(() {
    List<ImageFile> result = list()
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
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.nameDescending:
        list.sort((a, b) => b.name.compareTo(a.name));
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
