import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/frosted.dart';

/// 显示 / 隐藏状态（受控）
enum SideMenuMode { open, closed }

/// 行为模式：占位(挤压内容区) 或 悬浮(覆盖在内容上)
enum SideMenuBehavior { push, overlay }

/// 侧边栏位置
enum SideMenuPosition { left, right }

class SidebarMenu extends StatefulWidget {
  final SideMenuMode mode;
  final ValueChanged<SideMenuMode>? onModeChanged;
  final SideMenuBehavior behavior;
  final SideMenuPosition position;
  final Widget menu;
  final Widget child;
  final double menuWidth;

  /// 鼠标移出侧边栏后触发此回调，由调用方决定是否关闭
  /// 示例：onDelay: () => setState(() => _mode = SideMenuMode.closed)
  final VoidCallback? onDelay;

  /// 延迟触发 onDelay 的时间(ms)
  final int delayMs;

  /// 鼠标移出侧边栏后是否自动隐藏(延迟 delayMs 后触发 onDelay)
  final bool autoHide;

  final double overlayMargin;
  final Duration animationDuration;
  final Curve animationCurve;

  const SidebarMenu({
    super.key,
    required this.mode,
    required this.menu,
    required this.child,
    this.onModeChanged,
    this.behavior = SideMenuBehavior.push,
    this.position = SideMenuPosition.left,
    this.menuWidth = 260,
    this.onDelay,
    this.delayMs = 500,
    this.autoHide = true,
    this.overlayMargin = 12,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeOutCubic,
  });

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _delayTimer;

  bool _pointerDown = false;

  bool get _isLeft => widget.position == SideMenuPosition.left;
  double get _menuWidth => widget.menuWidth;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.animationDuration,
      value: widget.mode == SideMenuMode.open ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant SidebarMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      widget.mode == SideMenuMode.open
          ? _controller.forward()
          : _controller.reverse();
    }
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
      _controller.reverseDuration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _delayTimer?.cancel();
    if (widget.onModeChanged != null) {
      widget.onModeChanged!(SideMenuMode.closed);
    } else {
      widget.onDelay?.call();
    }
  }

  /// 鼠标移出时启动延迟计时器
  void _startDelayTimer() {
    if (_pointerDown || !widget.autoHide) return;
    _delayTimer?.cancel();
    _delayTimer = Timer(Duration(milliseconds: widget.delayMs), () {
      if (widget.mode == SideMenuMode.open) {
        widget.onDelay?.call();
      }
    });
  }

  /// 鼠标移入时取消延迟计时器
  void _cancelDelayTimer() {
    _pointerDown = false;
    _delayTimer?.cancel();
  }

  double get _progress =>
      CurvedAnimation(parent: _controller, curve: widget.animationCurve).value;

  Widget _buildInteractiveMenu() {
    return Listener(
      onPointerDown: (_) => _pointerDown = true,
      onPointerUp: (_) => _pointerDown = false,
      onPointerCancel: (_) => _pointerDown = false,
      child: widget.menu,
    );
  }

  Widget _buildMenuBody(double progress) {
    final body = SizedBox(width: _menuWidth, child: _buildInteractiveMenu());
    final dx = (_isLeft ? -1.0 : 1.0) * _menuWidth * (1 - progress);
    return MouseRegion(
      onEnter: (_) => _cancelDelayTimer(),
      onExit: (_) => _startDelayTimer(),
      child: Transform.translate(offset: Offset(dx, 0), child: body),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final p = _progress;
        return widget.behavior == SideMenuBehavior.push
            ? _buildPush(p)
            : _buildOverlay(p);
      },
    );
  }

  Widget _buildPush(double p) {
    final animWidth = _menuWidth * p;
    final menuSlot = ClipRect(
      child: SizedBox(
        width: animWidth,
        child: OverflowBox(
          alignment: _isLeft ? Alignment.centerLeft : Alignment.centerRight,
          minWidth: _isLeft ? 0 : _menuWidth,
          maxWidth: _menuWidth,
          child: _buildMenuBody(p),
        ),
      ),
    );
    return Row(
      children: [
        if (_isLeft) menuSlot else const SizedBox.shrink(),
        Expanded(child: widget.child),
        if (!_isLeft) menuSlot else const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildOverlay(double p) {
    final currentWidth = _menuWidth * p;
    final menuOffset =
        (_isLeft ? -1.0 : 1.0) * (_menuWidth + widget.overlayMargin) * (1 - p);

    final showBarrier = p > 0;

    return Stack(
      children: [
        Positioned.fill(child: widget.child),

        if (showBarrier)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
              child: const SizedBox.expand(),
            ),
          ),

        Positioned(
          top: widget.overlayMargin,
          bottom: widget.overlayMargin,
          left: _isLeft ? widget.overlayMargin + menuOffset : null,
          right: _isLeft ? null : widget.overlayMargin - menuOffset,
          width: currentWidth,
          child: MouseRegion(
            onEnter: (_) => _cancelDelayTimer(),
            onExit: (_) => _startDelayTimer(),
            child: _buildInteractiveMenu(),
          ),
        ),
      ],
    );
  }
}

/// 一个内置样式的侧边栏外壳，给菜单加背景/阴影/圆角，并内置磨砂(毛玻璃)效果
class SidebarMenuSurface extends StatelessWidget {
  final Widget child;
  final BoxDecoration? decoration;
  final double blurSigma;
  final EdgeInsetsGeometry padding;

  const SidebarMenuSurface({
    super.key,
    required this.child,
    this.decoration,
    this.blurSigma = 12,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Frosted(
      decoration:
          decoration ?? BoxDecoration(color: Theme.of(context).cardColor),
      blurSigma: blurSigma,
      child: Padding(
        padding: padding,
        child: SafeArea(right: false, left: false, child: child),
      ),
    );
  }
}
