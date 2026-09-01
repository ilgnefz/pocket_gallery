import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:signals/signals_flutter.dart';

class ContentPreview extends StatefulWidget {
  const ContentPreview({super.key});

  @override
  State<ContentPreview> createState() => _ContentPreviewState();
}

class _ContentPreviewState extends State<ContentPreview> {
  void prev() {
    List<ImageFile> list = FileStore.sortList();
    int index = list.indexWhere(
      (element) => element.path == FileStore.preview()!.path,
    );
    index = index == 0 ? list.length - 1 : index - 1;
    FileStore.updatePreview(list[index]);
  }

  void next() {
    List<ImageFile> list = FileStore.sortList();
    int index = list.indexWhere(
      (element) => element.path == FileStore.preview()!.path,
    );
    index = index == list.length - 1 ? 0 : index + 1;
    FileStore.updatePreview(list[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SignalBuilder(
        builder: (BuildContext context) => Stack(
          fit: StackFit.expand,
          children: [
            InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: Navigator.of(context).pop,
              child: InteractiveViewer(
                // minScale: .5,
                maxScale: 10,
                // boundaryMargin: EdgeInsets.all(double.infinity),
                child: Image.file(
                  File(FileStore.preview()!.path),
                  errorBuilder: (_, _, _) => ErrorWidget('图片加载失败'),
                  frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: frame != null
                          ? child
                          : SizedBox(
                              width: 120,
                              height: 120,
                              child: const CircularProgressIndicator(
                                strokeWidth: 8,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const .symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_left_rounded),
                    onPressed: prev,
                    color: Colors.white,
                    iconSize: 40,
                    style: ButtonStyle(visualDensity: VisualDensity.standard),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_right_rounded),
                    onPressed: next,
                    color: Colors.white,
                    iconSize: 40,
                    style: ButtonStyle(visualDensity: VisualDensity.standard),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
