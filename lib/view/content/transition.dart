import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';

class TransitionView extends StatelessWidget {
  const TransitionView({
    super.key,
    required this.image,
    required this.frame,
    required this.child,
    this.isPreview = false,
  });

  final ImageFile image;
  final int? frame;
  final Widget child;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (image.blurhash.isNotEmpty)
          AspectRatio(
            aspectRatio: image.width / image.height,
            child: BlurHash(hash: image.blurhash),
          ),
        AnimatedOpacity(
          opacity: frame != null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: child,
        ),
        if (frame == null && image.blurhash.isEmpty)
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(strokeWidth: isPreview ? 8 : 2),
          ),
      ],
    );
  }
}
