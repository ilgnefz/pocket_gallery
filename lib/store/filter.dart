import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:signals/signals.dart';

final counter = signal(0);
final doubleCounter = computed(() => counter.value * 2);
void increment() => counter.value++;

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

  static final layout = Signal(LayoutStyle.equalHeight);
  static void updateLayout(LayoutStyle value) => layout.value = value;
}
