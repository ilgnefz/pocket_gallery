import 'package:flutter/material.dart';
import 'package:pocket_gallery/view/sidebar/folder.dart';
import 'package:pocket_gallery/component/folder_item.dart';
import 'package:pocket_gallery/component/sidebar.dart';
import 'package:pocket_gallery/component/title.dart';
import 'package:pocket_gallery/constant/num.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:pocket_gallery/view/content/content.dart';
import 'package:pocket_gallery/view/sidebar/show.dart';
import 'package:pocket_gallery/view/sidebar/size_title.dart';
import 'package:signals/signals_flutter.dart';

import 'folder_title.dart';
import 'footer.dart';
import 'size.dart';
import 'sort.dart';
import 'sort_title.dart';

class SidebarView extends StatelessWidget {
  const SidebarView({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) => SidebarMenu(
        mode: StatusStore.mode(),
        behavior: StatusStore.pin() ? .push : .overlay,
        position: .right,
        autoHide: !StatusStore.pin(),
        onDelay: StatusStore.updateMode,
        menu: SidebarMenuSurface(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .8),
            borderRadius: .circular(8),
          ),
          child: LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              if (constraints.maxWidth < 240) return SizedBox.shrink();
              return Column(
                crossAxisAlignment: .start,
                children: [
                  SizeTitle(),
                  SizedBox(height: 4.0),
                  SizeView(),
                  SizedBox(height: 12.0),
                  SidebarTitle(title: '显示'),
                  ShowView(),
                  SizedBox(height: 12.0),
                  SortTitle(),
                  SortView(),
                  SizedBox(height: 12.0),
                  FolderTitle(),
                  SizedBox(height: 4.0),
                  Padding(
                    padding: .only(left: AppNum.padding),
                    child: SidebarFolderItem(folder: ''),
                  ),
                  SidebarFolders(),
                  SizedBox(height: 12.0),
                  FooterView(),
                ],
              );
            },
          ),
        ),
        // 【child】是主界面显示的东西（内容）
        child: ContentView(),
      ),
    );
  }
}
