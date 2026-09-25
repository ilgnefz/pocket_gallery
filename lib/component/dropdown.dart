import 'dart:async';

import 'package:flutter/material.dart';

class HoverDropdown extends StatefulWidget {
  final Widget child;
  final Widget menu;
  final DropdownTrigger trigger;
  final Offset offset;
  final double? menuWidth;
  final double? menuMaxHeight;
  final int hideDelay;
  final Duration animationDuration; // 新增：动画时长
  final Curve animationCurve; // 新增：动画曲线

  const HoverDropdown({
    super.key,
    required this.child,
    required this.menu,
    this.trigger = DropdownTrigger.hover,
    this.offset = const Offset(0, 4),
    this.menuWidth,
    this.menuMaxHeight = 300,
    this.hideDelay = 200,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
  });

  @override
  State<HoverDropdown> createState() => _HoverDropdownState();
}

enum DropdownTrigger { hover, click }

class _HoverDropdownState extends State<HoverDropdown>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  Timer? _hideTimer;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.animationDuration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.05), // 从上方轻微滑入
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  /// 打开菜单（带动画）
  void _openMenu() {
    if (_controller.value == 1.0) return;
    _hideTimer?.cancel();
    _controller.forward();
    _showOverlay();
  }

  /// 关闭菜单（带动画）
  void _closeMenu() {
    _hideTimer?.cancel();
    _controller.reverse().then((_) {
      _removeOverlay();
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height + widget.offset.dy,
          width: widget.menuWidth ?? size.width, // 关键：明确指定宽度
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: MouseRegion(
                onEnter: (_) => _hideTimer?.cancel(),
                onExit: (_) => _startHideTimer(),
                child: Material(
                  elevation: 8,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  shadowColor: Colors.black.withValues(alpha: .15),
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    // 关键修复：用 ConstrainedBox 限制菜单的最大宽高
                    constraints: BoxConstraints(
                      minWidth: widget.menuWidth ?? size.width,
                      maxWidth: widget.menuWidth ?? size.width,
                      maxHeight: widget.menuMaxHeight ?? 300,
                    ),
                    child: widget.menu,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _hideTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(milliseconds: widget.hideDelay), () {
      _closeMenu();
    });
  }

  void _onTriggerEnter() {
    if (widget.trigger == DropdownTrigger.hover) {
      _openMenu();
    }
  }

  void _onTriggerExit() {
    if (widget.trigger == DropdownTrigger.hover) {
      _startHideTimer();
    }
  }

  void _onTriggerTap() {
    if (widget.trigger == DropdownTrigger.click) {
      if (_controller.value == 1.0) {
        _closeMenu();
      } else {
        _openMenu();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onTriggerEnter(),
      onExit: (_) => _onTriggerExit(),
      child: GestureDetector(
        onTap: _onTriggerTap,
        behavior: HitTestBehavior.opaque,
        child: widget.child,
      ),
    );
  }
}
