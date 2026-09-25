import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_gallery/component/frosted.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/src/rust/api/simple.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:signals/signals_flutter.dart';

class OperateView extends StatelessWidget {
  const OperateView({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) {
        ImageFile image = FileStore.preview()!;
        return Frosted(
          color: Colors.white.withValues(alpha: .35),
          borderRadius: .circular(40),
          child: Row(
            mainAxisSize: .min,
            children: [
              BoxIcon(
                icon: Icons.arrow_back_ios_new_rounded,
                iconSize: 20,
                onTap: prev,
              ),
              // BoxIcon(
              //   icon: Icons.info_outline_rounded,
              //   iconSize: 20,
              //   onTap: () {
              //     debugPrint('${image.width} * ${image.height} --- ${image.size}');
              //   },
              // ),
              BoxIcon(
                icon: Icons.desktop_mac_rounded,
                iconSize: 20,
                onTap: () => setWallpaper(path: image.path),
              ),
              BoxIcon(
                icon: image.like
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconSize: 20,
                onTap: () async => await likeImage(image, true),
              ),
              BoxIcon(
                icon: Icons.copy_rounded,
                iconSize: 20,
                onTap: () => Clipboard.setData(ClipboardData(text: image.path)),
              ),
              BoxIcon(
                icon: Icons.folder_open_rounded,
                iconSize: 20,
                onTap: () async => await findImage(image),
              ),
              BoxIcon(
                icon: Icons.arrow_forward_ios_rounded,
                iconSize: 20,
                onTap: next,
              ),
            ],
          ),
        );
      },
    );
  }
}
