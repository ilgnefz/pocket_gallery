import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_gallery/component/image.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/view/content/operate.dart';
import 'package:pocket_gallery/view/content/transition.dart';
import 'package:signals/signals_flutter.dart';

class ContentPreview extends StatefulWidget {
  const ContentPreview({super.key});

  @override
  State<ContentPreview> createState() => _ContentPreviewState();
}

class _ContentPreviewState extends State<ContentPreview> {
  bool _showCom = true;
  // 记录已预加载的当前张下标，避免 build 重复触发
  int _precacheIndex = -1;

  /// 把当前预览图前后各 [range] 张相邻图提前送入 ImageCache
  void _precacheNeighbors(List<ImageFile> list, int current, int range) {
    for (int offset = -range; offset <= range; offset++) {
      if (offset == 0) continue;
      final idx = (current + offset + list.length) % list.length;
      // 缓存键必须与预览实际渲染的 FileImageWithKey 一致，预加载才命中
      precacheImage(
        FileImageWithKey(
          File(list[idx].path),
          list[idx].id,
        ),
        context,
      );
    }
  }

  void _onHover(PointerHoverEvent event) {
    final height = context.size?.height ?? 0;
    // 直接由鼠标是否位于画面底部 1/4 区域决定显示与否
    final show = event.position.dy >= height * 3 / 4;
    if (mounted && show != _showCom) {
      setState(() => _showCom = show);
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    // 左/上 = 上一张，右/下 = 下一张
    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowUp) {
      prev();
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowDown) {
      next();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Material(
        color: Colors.transparent,
        child: SignalBuilder(
          builder: (BuildContext context) {
            ImageFile image = FileStore.preview()!;
            final list = FileStore.sortList();
            final current = list.indexWhere((e) => e.path == image.path);
            if (current != -1 && _precacheIndex != current) {
              _precacheIndex = current;
              _precacheNeighbors(list, current, 2);
            }
            return MouseRegion(
              onHover: _onHover,
              onExit: (_) {
                if (mounted) setState(() => _showCom = false);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: Navigator.of(context).pop,
                    child: InteractiveViewer(
                      // minScale: .5,
                      maxScale: 10,
                      // boundaryMargin: EdgeInsets.all(double.infinity),
                      child: Image(
                        image: FileImageWithKey(
                          File(image.path),
                          image.id,
                        ),
                        errorBuilder: (_, _, _) => ErrorWidget('图片加载失败'),
                        frameBuilder:
                            (_, child, frame, wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) return child;
                              return TransitionView(
                                image: image,
                                frame: frame,
                                isPreview: true,
                                child: child,
                              );
                            },
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _showCom ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Align(
                      alignment: .bottomCenter,
                      child: Padding(
                        padding: .only(bottom: 16),
                        child: OperateView(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
