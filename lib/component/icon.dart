import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BaseIcon extends StatelessWidget {
  const BaseIcon({super.key, this.icon, this.svg, this.size, this.color})
    : assert(icon != null || svg != null);

  final IconData? icon;
  final String? svg;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Color iconColor = color ?? Theme.of(context).iconTheme.color!;
    return icon != null
        ? Icon(icon, size: size, color: color)
        : SvgPicture.asset(
            svg!,
            width: size ?? 20.0,
            height: size ?? 20.0,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          );
  }
}

class ClickIcon extends StatelessWidget {
  const ClickIcon({
    super.key,
    this.icon,
    this.svg,
    this.size,
    this.iconSize,
    this.color,
    this.onTap,
  });

  final IconData? icon;
  final String? svg;
  final double? size;
  final double? iconSize;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: InkWell(
          onTap: onTap,
          mouseCursor: SystemMouseCursors.click,
          borderRadius: BorderRadius.circular(4),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            width: size ?? 28,
            height: size ?? 28,
            alignment: Alignment.center,
            child: BaseIcon(
              icon: icon,
              svg: svg,
              size: iconSize ?? (icon == null ? 18 : 20),
              color: color ?? Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ),
    );
  }
}

class BoxIcon extends StatelessWidget {
  const BoxIcon({
    super.key,
    this.icon,
    this.svg,
    this.size,
    this.iconSize,
    this.color,
    this.borderRadius,
    this.onTap,
  });

  final IconData? icon;
  final String? svg;
  final double? size;
  final double? iconSize;
  final Color? color;
  final BorderRadius? borderRadius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        mouseCursor: SystemMouseCursors.click,
        child: Container(
          width: size ?? 44,
          height: size ?? 36,
          alignment: Alignment.center,
          color: Colors.transparent,
          child: BaseIcon(
            icon: icon,
            svg: svg,
            size: iconSize ?? (icon == null ? 18 : 20),
            color: color ?? Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}
