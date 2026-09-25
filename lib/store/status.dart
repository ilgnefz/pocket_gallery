import 'package:pocket_gallery/component/sidebar.dart';
import 'package:pocket_gallery/constant/key.dart';
import 'package:pocket_gallery/service/storage.dart';
import 'package:signals/signals.dart';

class StatusStore {
  static final mode = Signal(() {
    SideMenuMode mode = SideMenuMode.closed;
    bool isOpen = StorageService.getBool(AppKey.open) ?? false;
    if (pin.value && isOpen) mode = SideMenuMode.open;
    return mode;
  }());
  static void updateMode() {
    bool isOpen = mode.value == SideMenuMode.open;
    mode.value = isOpen ? SideMenuMode.closed : SideMenuMode.open;
    StorageService.setBool(AppKey.open, !isOpen);
  }

  static final loading = Signal(false);
  static void updateLoading(bool value) => loading.value = value;

  static final group = Signal(StorageService.getBool(AppKey.group) ?? false);
  static Future<void> updateGroup() async {
    group.value = !group.value;
    await StorageService.setBool(AppKey.group, group.value);
  }

  static final sort = Signal(false);
  static void updateSort() => sort.value = !sort.value;

  static final pin = Signal(StorageService.getBool(AppKey.pin) ?? false);
  static void updatePin() {
    pin.value = !pin.value;
    StorageService.setBool(AppKey.pin, pin.value);
  }
}
