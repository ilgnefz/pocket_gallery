import 'package:flutter/material.dart';
import 'package:pocket_gallery/constant/num.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:signals/signals_flutter.dart';

class SizeView extends StatelessWidget {
  const SizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) => Slider(
        min: 180,
        max: AppNum.sizeMax,
        value: FileStore.size(),
        padding: .symmetric(horizontal: AppNum.padding),
        onChanged: (value) => FileStore.updateSize(value),
      ),
    );
  }
}
