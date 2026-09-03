import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pocket_gallery/component/flexible_aspect_ratio_grid.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/store/filter.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:pocket_gallery/view/empty.dart';
import 'package:pocket_gallery/view/loading.dart';
import 'package:signals/signals_flutter.dart';

import 'image.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) {
        if (StatusStore.loading()) return LoadingView();
        List<ImageFile> files = FileStore.sortList();
        if (files.isEmpty) return EmptyView();

        LayoutStyle style = FilterStore.layout();

        EdgeInsets padding = const .only(left: 12.0, right: 12.0, bottom: 12.0);

        if (style.isEqualHeight) {
          return FlexibleAspectRatioGrid.builder(
            padding: padding,
            itemCount: files.length,
            targetHeight: 240,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            scrollCacheExtent: ScrollCacheExtent.viewport(.5),
            aspectRatioBuilder: (_, index) =>
                files[index].width / files[index].height,
            itemBuilder: (context, index) {
              ImageFile image = files[index];
              return ImageView(
                key: ValueKey(image.id),
                image: image,
                style: style,
              );
            },
          );
        }

        return GridView.builder(
          itemCount: files.length,
          padding: padding,
          scrollCacheExtent: ScrollCacheExtent.viewport(.5),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 240,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            ImageFile image = files[index];
            return ImageView(
              key: ValueKey(image.id),
              image: image,
              style: style,
            );
          },
        );
      },
    );
  }
}
