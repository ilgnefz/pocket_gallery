import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:signals/signals.dart';

class StatusStore {
  static final mode = Signal(SideMenuMode.open);
  static void updateMode() => mode.value = mode.value == SideMenuMode.open
      ? SideMenuMode.compact
      : SideMenuMode.open;
}
