import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/view/empty.dart';
import 'package:signals/signals_flutter.dart';

import 'image.dart';

const double _cacheWidth = 200;

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) {
        // FileStore.list();
        // FilterStore.search();
        // FilterStore.showOrientation();
        // FilterStore.folder();
        List<ImageFile> files = FileStore.sortList();
        if (files.isEmpty) return EmptyView();
        return GridView.builder(
          itemCount: files.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollCacheExtent: ScrollCacheExtent.viewport(.5),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: _cacheWidth,
            mainAxisSpacing: 8,
            crossAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            ImageFile image = files[index];
            return ImageView(
              key: ValueKey(image.id),
              image: image,
              cacheWidth: _cacheWidth.toInt(),
            );
          },
        );
      },
    );
  }
}
