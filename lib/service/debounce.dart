import 'dart:async';
import 'dart:ui';

class DebounceService {
  static Timer? _timer;

  static const Duration _fixedDelay = Duration(milliseconds: 100);

  DebounceService._();

  static void run(VoidCallback action) {
    // 取消之前的定时器
    cancel();

    // 设置新的定时器，固定100毫秒延迟
    _timer = Timer(_fixedDelay, action);
  }

  static void cancel() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }
}
