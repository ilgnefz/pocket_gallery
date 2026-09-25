import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_gallery/component/chip.dart';
import 'package:pocket_gallery/component/wrap.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/store/filter.dart';
import 'package:signals/signals_flutter.dart';

class SortView extends StatelessWidget {
  const SortView({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (_) => SidebarWrap(
        children: SortType.values
            .map(
              (e) => SidebarChip(
                label: e.label,
                selected: FilterStore.sort() == e,
                onTap: () => SchedulerBinding.instance.addPostFrameCallback(
                  (_) => FilterStore.updateSort(e),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
