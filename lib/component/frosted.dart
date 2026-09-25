import 'dart:ui';

import 'package:flutter/material.dart';

/// 通用磨砂(毛玻璃)容器：实时模糊背后内容，叠加半透明背景
class Frosted extends StatelessWidget {
  const Frosted({
    super.key,
    required this.child,
    this.decoration,
    this.color,
    this.border,
    this.borderRadius,
    this.blurSigma = 12,
    this.filterQuality = FilterQuality.high,
  });

  /// 子组件
  final Widget child;

  /// 完整装饰（提供时优先于 color/borderRadius）
  final BoxDecoration? decoration;

  /// 背景色，叠加在模糊层之上模拟玻璃质感
  final Color? color;

  /// 边框，默认提供半透明白色细边框以勾勒玻璃边缘
  final Border? border;

  /// 圆角，同时决定模糊裁剪范围
  final BorderRadius? borderRadius;

  /// 模糊强度，越大越糊
  final double blurSigma;

  /// 模糊采样质量
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    final deco =
        decoration ??
        BoxDecoration(
          color: color ?? Colors.white.withValues(alpha: .8),
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
          border:
              border ??
              Border.all(color: Colors.white.withValues(alpha: .5), width: .5),
        );
    return ClipRRect(
      borderRadius: deco.borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(decoration: deco, child: child),
      ),
    );
  }
}
