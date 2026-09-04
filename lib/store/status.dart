import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:pocket_gallery/constant/key.dart';
import 'package:pocket_gallery/service/storage.dart';
import 'package:signals/signals.dart';

class StatusStore {
  static final mode = Signal(SideMenuMode.open);
  static void updateMode() => mode.value = mode.value == SideMenuMode.open
      ? SideMenuMode.compact
      : SideMenuMode.open;

  static final loading = Signal(false);
  static void updateLoading(bool value) => loading.value = value;

  static final group = Signal(StorageService.getBool(AppKey.group) ?? false);
  static Future<void> updateGroup() async {
    group.value = !group.value;
    await StorageService.setBool(AppKey.group, group.value);
  }

  static final sort = Signal(false);
  static void updateSort() => sort.value = !sort.value;
}
