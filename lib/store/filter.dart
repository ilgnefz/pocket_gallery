import 'package:pocket_gallery/constant/key.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/service/storage.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:signals/signals.dart';

class FilterStore {
  // static final controller = Signal(TextEditingController());
  // static final text = computed(() => controller.value.text);
  static final search = Signal('');
  static void updateSearch(String value) => search.value = value;

  static final orientation = Signal(ImageOrientation.all);
  static void updateOrientation(ImageOrientation value) =>
      orientation.value = value;

  static final sort = Signal(SortType.none);
  static void updateSort(SortType value) => sort.value = value;

  static final folder = Signal('');
  static void updateFolder(String value) => folder.value = value;

  static final show = Signal(ShowType.all);
  static void updateShow(ShowType value) => show.value = value;

  static final layout = Signal(
    LayoutStyle.values[StorageService.getInt(AppKey.layout) ?? 0],
  );
  static Future<void> updateLayout(LayoutStyle value) async {
    layout.value = value;
    await StorageService.setInt(AppKey.layout, value.index);
  }
}
