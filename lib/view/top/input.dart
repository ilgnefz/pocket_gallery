import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/close.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/service/debounce.dart';
import 'package:pocket_gallery/store/filter.dart';

class TopInput extends StatefulWidget {
  const TopInput({super.key, this.controller, this.focusNode, this.onDismiss});

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onDismiss;

  @override
  State<TopInput> createState() => _TopInputState();
}

class _TopInputState extends State<TopInput> {
  late final TextEditingController controller =
      widget.controller ?? TextEditingController();
  late final FocusNode focusNode = widget.focusNode ?? FocusNode();
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onChanged);
    focusNode.addListener(_onFocusChanged);
  }

  void _onChanged() {
    setState(() {
      showClear = controller.text.isNotEmpty;
    });
    DebounceService.run(() => FilterStore.updateSearch(controller.text));
    _maybeDismiss();
  }

  void _onFocusChanged() => _maybeDismiss();

  void _maybeDismiss() {
    if (controller.text.isEmpty && !focusNode.hasFocus) {
      widget.onDismiss?.call();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    if (widget.focusNode == null) focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 256,
      width: MediaQuery.of(context).size.width * .25,
      height: 36,
      padding: .only(left: 12.0, right: 8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      alignment: .center,
      child: Row(
        spacing: 4.0,
        children: [
          BaseIcon(
            icon: Icons.search_rounded,
            size: 20,
            color: Color(0xFF555555),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: TextStyle(fontSize: 14.0),
              cursorHeight: 16.0,
              decoration: InputDecoration(hintText: '搜索图片名称'),
            ),
          ),
          if (showClear) CloseIcon(onTap: controller.clear),
        ],
      ),
    );
  }
}
