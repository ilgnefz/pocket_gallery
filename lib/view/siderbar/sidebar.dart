import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/store/filter.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:signals/signals_flutter.dart';

import 'chip.dart';
import 'folder.dart';
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
          customChild: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth < 250) return SizedBox.shrink();
                return Container(
                  padding: .symmetric(horizontal: 12.0),
                  width: double.infinity,
                  child: Column(
                    spacing: 4.0,
                    crossAxisAlignment: .start,
                    children: [
                      SidebarTitle(title: '显示'),
                      SignalBuilder(
                        builder: (_) => Wrap(
                          spacing: 12.0,
                          runSpacing: 4.0,
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
                      SizedBox(height: 8.0),
                      SidebarTitle(title: '排序'),
                      SignalBuilder(
                        builder: (_) => Wrap(
                          spacing: 12.0,
                          runSpacing: 4.0,
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
                      SizedBox(height: 8.0),
                      SignalBuilder(
                        builder: (BuildContext context) => SidebarTitle(
                          title: '文件夹 (${FileStore.folders().length})',
                        ),
                      ),
                      SidebarClickFolder(folder: ''),
                      SignalBuilder(
                        builder: (BuildContext context) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: FileStore.folders().length,
                            itemBuilder: (BuildContext context, int index) {
                              return SidebarClickFolder(
                                folder: FileStore.folders()[index],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          footer: FooterView(),
        ),
      ),
    );
  }
}
