import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rf_viewer/src/rust/api/model.dart';
import 'package:rf_viewer/src/rust/api/simple.dart';
import 'package:rf_viewer/store/file.dart';
import 'package:rf_viewer/view/content/preview.dart';
import 'package:shadow_widget/shadow_widget.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key, required this.image, required this.cacheWidth});

  final ImageFile image;
  final int cacheWidth;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                FileStore.updatePreview(widget.image);
                return ContentPreview();
              },
            ),
            onDoubleTap: () => setWallpaper(path: widget.image.path),
            onSecondaryTap: () async =>
                await Process.run('explorer.exe', ['/select,', widget.image.path]),
            child: ShadowWidget(
              blurRadius: 4,
              child: Center(
                child: Image.file(
                  File(widget.image.path),
                  fit: BoxFit.contain,
                  cacheWidth: widget.cacheWidth,
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
          widget.image.name,
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
