import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/close.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/service/debounce.dart';
import 'package:pocket_gallery/store/filter.dart';
import 'package:signals/signals_flutter.dart';

class SidebarClickFolder extends StatefulWidget {
  const SidebarClickFolder({super.key, required this.folder});

  final String folder;

  @override
  State<SidebarClickFolder> createState() => _SidebarClickFolderState();
}

class _SidebarClickFolderState extends State<SidebarClickFolder> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    String name = widget.folder.isEmpty
        ? '全部'
        : widget.folder.split(Platform.pathSeparator).last;

    Widget child = SignalBuilder(
      builder: (BuildContext context) => Text(
        name,
        style: TextStyle(
          color: isHover || FilterStore.folder() == widget.folder
              ? Theme.of(context).primaryColor
              : Colors.black,
          // fontWeight: FilterStore.folder() == widget.folder ? .bold : .normal,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: () =>
            DebounceService.run(() => FilterStore.updateFolder(widget.folder)),
        child: widget.folder.isEmpty
            ? child
            : Row(
                children: [
                  Expanded(child: child),
                  if (widget.folder.isNotEmpty)
                    CloseIcon(onTap: () => removeFolder(widget.folder)),
                ],
              ),
      ),
    );
  }
}
