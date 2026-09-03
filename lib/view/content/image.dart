import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/image.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/src/rust/api/simple.dart';
import 'package:shadow_widget/shadow_widget.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.image, required this.style});

  final ImageFile image;
  final LayoutStyle style;

  @override
  Widget build(BuildContext context) {
    BoxFit fit = style.isEqualHeight ? BoxFit.cover : BoxFit.contain;

    Widget child = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int w = (constraints.maxWidth * MediaQuery.of(context).devicePixelRatio)
            .ceil();
        return SizedBox.expand(
          child: Image(
            image: ResizeImage(
              FileImageWithKey(File(image.path), image.id),
              width: w,
            ),
            fit: fit,
            errorBuilder: (_, _, _) => ErrorWidget('图片加载失败'),
            frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: frame != null
                    ? child
                    : const CircularProgressIndicator(strokeWidth: 2),
              );
            },
          ),
        );
      },
    );

    child = style.isEqualHeight
        ? child
        : ShadowWidget(blurRadius: 4, child: Center(child: child));

    child = InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => previewImage(context, image),
      onDoubleTap: () async {
        if (!await checkExist(image)) return;
        setWallpaper(path: image.path);
      },
      onSecondaryTap: () async => await likeImage(image),
      onLongPress: () async => await findImage(image),
      child: child,
    );

    if (style.isEqualWidth) {
      child = Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: child),
          Text(
            image.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13),
            textAlign: .center,
          ),
        ],
      );
    }

    return child;
  }
}
