import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:rf_viewer/enum/enum.dart';
import 'package:rf_viewer/store/file.dart';
import 'package:rf_viewer/store/filter.dart';
import 'package:rf_viewer/store/status.dart';
import 'package:rf_viewer/view/siderbar/chip.dart';
import 'package:rf_viewer/view/siderbar/folder.dart';
import 'package:rf_viewer/view/siderbar/title.dart';
import 'package:signals/signals_flutter.dart';

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
          footer: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 250) return SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  '左键单击浏览图片，双击设置桌面壁纸\n右击打开文件所在位置\nv1.0.0 Copyright ilgnefz',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: .center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
