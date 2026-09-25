import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/component/title.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:signals/signals_flutter.dart';

class SizeTitle extends StatelessWidget {
  const SizeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) {
        return SidebarTitle(
          title: '尺寸',
          action: AnimatedRotation(
            turns: StatusStore.pin() ? 0 : 0.25,
            duration: const Duration(milliseconds: 300),
            child: ClickIcon(
              icon: Icons.push_pin_rounded,
              iconSize: 16,
              onTap: StatusStore.updatePin,
            ),
          ),
        );
      },
    );
  }
}
