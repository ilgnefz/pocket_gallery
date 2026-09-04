import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/constant/num.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/store/filter.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:pocket_gallery/view/siderbar/wrap.dart';
import 'package:signals/signals_flutter.dart';

import 'chip.dart';
import 'folder.dart';
import 'folder_item.dart';
import 'footer.dart';
import 'title.dart';

class SidebarView extends StatelessWidget {
  const SidebarView({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (_) => SideMenu(
        mode: StatusStore.mode(),
        position: .right,
        hasResizer: false,
        hasResizerToggle: false,
        minWidth: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (data) => SideMenuData(
          customChild: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 250) return SizedBox.shrink();
              return Column(
                crossAxisAlignment: .start,
                children: [
                  SidebarTitle(title: '显示'),
                  SignalBuilder(
                    builder: (_) => SidebarWrap(
                      children: ShowType.values
                          .map(
                            (e) => SidebarChip(
                              label: e.label,
                              selected: FilterStore.show() == e,
                              onTap: () => SchedulerBinding.instance
                                  .addPostFrameCallback(
                                    (_) => FilterStore.updateShow(e),
                                  ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  SignalBuilder(
                    builder: (BuildContext context) {
                      return SidebarTitle(
                        title: '排序',
                        action: ClickIcon(
                          icon: StatusStore.group()
                              ? Icons.folder_open_outlined
                              : Icons.folder_off_outlined,
                          size: 20,
                          onTap: StatusStore.updateGroup,
                        ),
                      );
                    },
                  ),
                  SignalBuilder(
                    builder: (_) => SidebarWrap(
                      children: SortType.values
                          .map(
                            (e) => SidebarChip(
                              label: e.label,
                              selected: FilterStore.sort() == e,
                              onTap: () => SchedulerBinding.instance
                                  .addPostFrameCallback(
                                    (_) => FilterStore.updateSort(e),
                                  ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  SignalBuilder(
                    builder: (BuildContext context) => SidebarTitle(
                      title: '文件夹 (${FileStore.folders().length})',
                      action: ClickIcon(
                        icon: StatusStore.sort()
                            ? Icons.check
                            : Icons.format_list_numbered_rounded,
                        size: 20,
                        onTap: StatusStore.updateSort,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Padding(
                    padding: .only(left: AppNum.padding),
                    child: SidebarFolderItem(folder: ''),
                  ),
                  SidebarFolders(),
                ],
              );
            },
          ),
          footer: FooterView(),
        ),
      ),
    );
  }
}
