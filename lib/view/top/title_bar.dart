import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/constant/icon.dart';
import 'package:pocket_gallery/constant/image.dart';
import 'package:window_manager/window_manager.dart';

class TitleBarView extends StatefulWidget {
  const TitleBarView({super.key, this.child});

  final Widget? child;

  @override
  State<TitleBarView> createState() => _TitleBarViewState();
}

class _TitleBarViewState extends State<TitleBarView> {
  final double size = 12.0;
  bool isMax = false;
  // late TitleBarTheme? theme;

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
    // final theme = Theme.of(context).extension<TitleBarTheme>();
    // final Color? color = theme?.iconColor;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) => windowManager.startDragging(),
      onDoubleTap: maximizeOrUnmaximize,
      child: Container(
        width: double.infinity,
        height: 32.0,
        // color: Colors.grey[100],
        padding: .only(left: 12.0),
        child: Row(
          children: [
            Image.asset(AppImages.logo, height: 20.0),
            const SizedBox(width: 8),
            Text('PocketGallery', style: TextStyle(fontSize: 13)),
            widget.child == null
                ? const Spacer()
                : Expanded(child: widget.child!),
            TitleBarIcon(
              svg: AppIcons.minimize,
              color: Colors.black,
              onPressed: minimize,
            ),
            TitleBarIcon(
              svg: isMax ? AppIcons.unmaximize : AppIcons.maximize,
              color: Colors.black,
              onPressed: maximizeOrUnmaximize,
            ),
            TitleBarIcon(
              svg: AppIcons.close,
              color: Colors.black,
              onPressed: close,
            ),
          ],
        ),
      ),
    );
  }
}

class TitleBarIcon extends StatelessWidget {
  const TitleBarIcon({
    super.key,
    required this.svg,
    required this.color,
    required this.onPressed,
  });

  final String svg;
  final Color? color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: onPressed,
        child: Container(
          width: 48,
          alignment: Alignment.center,
          child: BaseIcon(svg: svg, size: 12.0, color: color),
        ),
      ),
    );
  }
}
