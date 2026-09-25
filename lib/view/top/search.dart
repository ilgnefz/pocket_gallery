import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/frosted.dart';
import 'package:pocket_gallery/component/icon.dart';

import 'input.dart';

class SearchButton extends StatefulWidget {
  const SearchButton({super.key});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  OverlayEntry? _entry;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _open() {
    if (_entry != null) return;
    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (_) => _BottomSearch(
        controller: _controller,
        focusNode: _focusNode,
        onDismiss: _close,
      ),
    );
    overlay.insert(_entry!);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    _focusNode.unfocus();
  }

  void _toggle() {
    if (_entry != null) {
      _close();
    } else {
      _open();
    }
  }

  @override
  void dispose() {
    _close();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClickIcon(icon: Icons.search_rounded, onTap: _toggle);
  }
}

class _BottomSearch extends StatefulWidget {
  const _BottomSearch({
    required this.controller,
    required this.focusNode,
    required this.onDismiss,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onDismiss;

  @override
  State<_BottomSearch> createState() => _BottomSearchState();
}

class _BottomSearchState extends State<_BottomSearch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));

  bool _hidden = false;
  Timer? _hideTimer;
  Offset? _dragStart;
  double _lastY = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ac.forward();
      widget.focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _ac.dispose();
    super.dispose();
  }

  void _onScrollActivity() {
    _hideTimer?.cancel();
    if (!_hidden) setState(() => _hidden = true);
    _hideTimer = Timer(const Duration(milliseconds: 350), () {
      if (mounted && _hidden) setState(() => _hidden = false);
    });
  }

  void _onPointerDown(Offset position) {
    _dragStart = position;
    _lastY = position.dy;
  }

  void _onPointerMove(Offset position) {
    final start = _dragStart;
    if (start == null) return;
    final dx = position.dx - start.dx;
    final dy = position.dy - start.dy;
    if (dx.abs() < kTouchSlop && dy.abs() < kTouchSlop) return;
    if ((position.dy - _lastY).abs() > 2) {
      _onScrollActivity();
    }
    _lastY = position.dy;
  }

  void _onPointerEnd() {
    _dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (e) {
              _onPointerDown(e.position);
              // 延迟到本次点击事件处理完成后再失焦，避免在顶部组件
              // InkWell 的 tap 触发前移除/重建 Overlay 而中断点击。
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) widget.focusNode.unfocus();
              });
            },
            onPointerMove: (e) => _onPointerMove(e.position),
            onPointerUp: (_) => _onPointerEnd(),
            onPointerCancel: (_) => _onPointerEnd(),
            onPointerSignal: (e) {
              if (e is PointerScrollEvent) _onScrollActivity();
            },
            child: const SizedBox.expand(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: _slide,
            child: AnimatedOpacity(
              opacity: _hidden ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: _hidden,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Material(
                    elevation: 8,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    child: Frosted(
                      color: Colors.white.withValues(alpha: .6),
                      borderRadius: BorderRadius.circular(8),
                      blurSigma: 12,
                      child: TopInput(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        onDismiss: widget.onDismiss,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
