import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_gallery/constant/num.dart';
import 'package:pocket_gallery/component/image.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/src/rust/api/simple.dart';
import 'package:shadow_widget/shadow_widget.dart';
import 'package:signals/signals_flutter.dart';

import 'transition.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.image, required this.style});

  final ImageFile image;
  final LayoutStyle style;

  @override
  Widget build(BuildContext context) {
    BoxFit fit = style.isEqualHeight ? BoxFit.cover : BoxFit.contain;

    Widget child = SignalBuilder(
      builder: (BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // 解码尺寸固定为滑块上限：滑块变化只改布局不改缓存 key，
          // 图片不重新加载；侧边栏 push 动画同样不影响
          double dpr = MediaQuery.of(context).devicePixelRatio;
          double nominalWidth = style.isEqualHeight
              ? AppNum.sizeMax * image.width / image.height
              : AppNum.sizeMax;
          int w = (nominalWidth * dpr).ceil();
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
                return TransitionView(image: image, frame: frame, child: child);
              },
            ),
          );
        },
      ),
    );

    child = style.isEqualHeight
        ? child
        : ShadowWidget(blurRadius: 4, child: Center(child: child));

    child = Material(
      color: Colors.transparent,
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: () => previewImage(context, image),
        onDoubleTap: () async {
          if (!await checkExist(image)) return;
          setWallpaper(path: image.path);
        },
        onSecondaryTap: () async => await likeImage(image),
        onLongPress: () async => await findImage(image),
        child: child,
      ),
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
