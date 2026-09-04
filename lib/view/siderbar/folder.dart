import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_gallery/constant/num.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:pocket_gallery/store/status.dart';
import 'package:pocket_gallery/view/siderbar/folder_item.dart';
import 'package:signals/signals_flutter.dart';

class SidebarFolders extends StatefulWidget {
  const SidebarFolders({super.key});

  @override
  State<SidebarFolders> createState() => _SidebarFoldersState();
}

class _SidebarFoldersState extends State<SidebarFolders> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SignalBuilder(
        builder: (BuildContext context) {
          List<String> folders = FileStore.folders();
          bool isSort = StatusStore.sort();

          if (!isSort) {
            return ListView.builder(
              shrinkWrap: true,
              padding: .symmetric(horizontal: AppNum.padding),
              itemCount: folders.length,
              itemBuilder: (_, index) =>
                  SidebarFolderItem(folder: folders[index]),
            );
          }

          return ReorderableListView.builder(
            shrinkWrap: true,
            itemCount: folders.length,
            mouseCursor: SystemMouseCursors.click,
            padding: .symmetric(horizontal: AppNum.padding),
            buildDefaultDragHandles: false,
            proxyDecorator: (proxy, original, information) {
              return Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                elevation: 2,
                borderRadius: BorderRadius.circular(4),
                shadowColor: Colors.black,
                child: Padding(
                  padding: .symmetric(horizontal: 8.0),
                  child: proxy,
                ),
              );
            },
            onReorderItem: (int oldIndex, int newIndex) =>
                FileStore.reorderFolder(oldIndex, newIndex),
            itemBuilder: (BuildContext context, int index) {
              final folder = folders[index];
              return ReorderableDragStartListener(
                index: index,
                key: ValueKey(folder),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    height: AppNum.sidebarTitleH,
                    alignment: .centerLeft,
                    child: Text(
                      folder.split(Platform.pathSeparator).last,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
