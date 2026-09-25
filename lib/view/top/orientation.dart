import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/dropdown.dart';
import 'package:pocket_gallery/component/frosted.dart';
import 'package:pocket_gallery/enum/enum.dart';
import 'package:pocket_gallery/service/debounce.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';
import 'package:pocket_gallery/store/filter.dart';
import 'package:signals/signals_flutter.dart';

class OrientationDropdown extends StatelessWidget {
  const OrientationDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext context) => HoverDropdown(
        trigger: DropdownTrigger.hover,
        hideDelay: 300,
        animationDuration: const Duration(milliseconds: 250),
        animationCurve: Curves.easeOutCubic,
        menuWidth: 80,
        menuMaxHeight: 500,
        offset: Offset(0, 4),
        menu: Frosted(
          child: ListView(
            shrinkWrap: true,
            primary: false,
            children: ImageOrientation.values.map((e) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => DebounceService.run(
                    () => FilterStore.updateOrientation(e),
                  ),
                  child: Container(
                    height: 36,
                    padding: .only(left: 12.0),
                    alignment: .centerLeft,
                    child: Text(e.label, style: TextStyle(fontSize: 14)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: .circular(4.0),
          child: InkWell(
            borderRadius: .circular(4.0),
            onTap: () {},
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    FilterStore.orientation().label,
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.black, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
