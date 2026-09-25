import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_gallery/component/chip.dart';
import 'package:pocket_gallery/component/wrap.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/store/filter.dart';
import 'package:signals/signals_flutter.dart';

class ShowView extends StatelessWidget {
  const ShowView({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (_) => SidebarWrap(
        children: ShowType.values
            .map(
              (e) => SidebarChip(
                label: e.label,
                selected: FilterStore.show() == e,
                onTap: () => SchedulerBinding.instance.addPostFrameCallback(
                  (_) => FilterStore.updateShow(e),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
