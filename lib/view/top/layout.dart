import 'package:flutter/material.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/service/debounce.dart';
import 'package:pocket_gallery/store/filter.dart';
import 'package:signals/signals_flutter.dart';

class LayoutDropdown extends StatelessWidget {
  const LayoutDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 36,
      child: SignalBuilder(
        builder: (BuildContext context) => DropdownButtonHideUnderline(
          child: DropdownButton(
            value: FilterStore.layout(),
            isDense: true,
            padding: const EdgeInsets.only(left: 12, right: 4),
            borderRadius: BorderRadius.circular(4),
            dropdownColor: Colors.white,
            focusColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.click,
            dropdownMenuItemMouseCursor: SystemMouseCursors.click,
            items: LayoutStyle.values
                .map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(
                      e.label,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(fontSize: 14),
                    ),
                  );
                })
                .whereType<DropdownMenuItem<LayoutStyle>>()
                .toList(),
            onChanged: (value) =>
                DebounceService.run(() => FilterStore.updateLayout(value!)),
          ),
        ),
      ),
    );
  }
}
