import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/service/debounce.dart';
import 'package:pocket_gallery/store/filter.dart';
import 'package:signals/signals_flutter.dart';

class StyleView extends StatelessWidget {
  const StyleView({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) => ClickIcon(
        svg: FilterStore.layout().icon,
        onTap: () => DebounceService.run(() {
          LayoutStyle value = FilterStore.layout().isEqualHeight
              ? LayoutStyle.equalWidth
              : LayoutStyle.equalHeight;
          FilterStore.updateLayout(value);
        }),
      ),
    );
  }
}
