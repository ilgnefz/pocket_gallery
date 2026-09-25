import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/component/sidebar.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:pocket_gallery/view/top/orientation.dart';
import 'package:pocket_gallery/view/top/style.dart';
import 'package:signals/signals_flutter.dart';

import 'search.dart';
import 'title_bar.dart';

class TopView extends StatelessWidget {
  const TopView({super.key});

  @override
  Widget build(BuildContext context) {
    return TitleBarView(
      leading: [
        SizedBox(width: 12.0),
        // SignalBuilder(
        //   builder: (_) => Text(
        //     '共 ${FileStore.total()} 项',
        //     style: TextStyle(fontSize: 14.0),
        //   ),
        // ),
        SizedBox(width: 8.0),
        ClickIcon(icon: Icons.add_rounded, onTap: addFolders),
        SizedBox(width: 8.0),
        ClickIcon(icon: Icons.refresh_rounded, onTap: refreshFolders),
        SizedBox(width: 8.0),
        const SearchButton(),
      ],
      trailing: [
        OrientationDropdown(),
        SizedBox(width: 8.0),
        StyleView(),
        SizedBox(width: 8.0),
        SignalBuilder(
          builder: (BuildContext context) => AnimatedRotation(
            turns: StatusStore.mode() == SideMenuMode.open ? 0 : 0.5,
            duration: const Duration(milliseconds: 300),
            child: ClickIcon(
              onTap: StatusStore.updateMode,
              icon: Icons.menu_open_rounded,
            ),
          ),
        ),
        SizedBox(width: 12.0),
      ],
      // child: Center(child: ShowTabBar()),
      child: Center(
        child: SignalBuilder(
          builder: (_) => Text(
            '共 ${FileStore.total()} 项',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
