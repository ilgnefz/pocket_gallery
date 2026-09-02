import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/image.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/src/rust/api/simple.dart';
import 'package:shadow_widget/shadow_widget.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.image, required this.cacheWidth});

  final ImageFile image;
  final int cacheWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            onTap: () => previewImage(context, image),
            onDoubleTap: () async {
              if (!await checkExist(image)) return;
              setWallpaper(path: image.path);
            },
            onSecondaryTap: () async => await likeImage(image),
            onLongPress: () async => await findImage(image),
            child: ShadowWidget(
              blurRadius: 4,
              child: Center(
                child: Image(
                  image: ResizeImage(
                    FileImageWithKey(File(image.path), image.id),
                    width: cacheWidth,
                  ),
                  fit: BoxFit.contain,
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
              ),
            ),
          ),
        ),
        Text(
          image.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13),
          textAlign: .center,
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
