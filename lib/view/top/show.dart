import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/store/filter.dart';

class ShowTabBar extends StatefulWidget {
  const ShowTabBar({super.key});

  @override
  State<ShowTabBar> createState() => _ShowTabBarState();
}

class _ShowTabBarState extends State<ShowTabBar> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: ShowType.values.length, vsync: this);
    controller.addListener(() {
      if (controller.indexIsChanging) {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => FilterStore.updateShow(ShowType.values[controller.index]),
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabs: [for (var type in ShowType.values) Tab(text: type.label)],
    );
  }
}
