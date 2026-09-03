import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/close.dart';
import 'package:pocket_gallery/service/debounce.dart';
import 'package:pocket_gallery/store/filter.dart';

class TopInput extends StatefulWidget {
  const TopInput({super.key});

  @override
  State<TopInput> createState() => _TopInputState();
}

class _TopInputState extends State<TopInput> {
  TextEditingController controller = TextEditingController();
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        showClear = controller.text.isNotEmpty;
      });
      DebounceService.run(() => FilterStore.updateSearch(controller.text));
    });
  }

  @override
  void dispose() {
    controller.dispose();
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
        color: Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(4.0),
      ),
      alignment: .center,
      child: Row(
        spacing: 4.0,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
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
