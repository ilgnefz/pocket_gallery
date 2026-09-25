import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/caption_button.dart';
import 'package:pocket_gallery/constant/icon.dart';
import 'package:pocket_gallery/constant/image.dart';
import 'package:pocket_gallery/constant/num.dart';
import 'package:window_manager/window_manager.dart';

class TitleBarView extends StatefulWidget {
  const TitleBarView({
    super.key,
    this.leading = const [],
    this.child,
    this.trailing = const [],
  });

  final List<Widget> leading;
  final Widget? child;
  final List<Widget> trailing;

  @override
  State<TitleBarView> createState() => _TitleBarViewState();
}

class _TitleBarViewState extends State<TitleBarView> {
  final double size = 12.0;
  bool isMax = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      isMax = await windowManager.isMaximized();
      setState(() {});
    });
  }

  void minimize() async => await windowManager.minimize();

  void maximizeOrUnmaximize() async {
    isMax ? await windowManager.unmaximize() : await windowManager.maximize();
    isMax = !isMax;
    setState(() {});
  }

  void close() async => await windowManager.close();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) => windowManager.startDragging(),
      onDoubleTap: maximizeOrUnmaximize,
      child: Container(
        width: double.infinity,
        height: AppNum.titleBarH,
        padding: .only(left: AppNum.padding),
        child: Row(
          children: [
            Flexible(
              child: Row(
                mainAxisSize: .max,
                children: [
                  Image.asset(AppImage.logo, height: 20.0),
                  const SizedBox(width: 8),
                  Text('PocketGallery', style: TextStyle(fontSize: 13)),
                  ...widget.leading,
                ],
              ),
            ),
            if (widget.child != null) Flexible(child: widget.child!),
            Flexible(
              child: Row(
                mainAxisSize: .max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ...widget.trailing,
                  CaptionButton(
                    svg: AppIcon.minimize,
                    color: Colors.black,
                    onPressed: minimize,
                  ),
                  CaptionButton(
                    svg: isMax ? AppIcon.unmaximize : AppIcon.maximize,
                    color: Colors.black,
                    onPressed: maximizeOrUnmaximize,
                  ),
                  CaptionButton(
                    svg: AppIcon.close,
                    color: Colors.black,
                    onPressed: close,
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
