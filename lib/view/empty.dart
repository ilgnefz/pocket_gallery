import 'package:flutter/material.dart';
import 'package:pocket_gallery/component/icon.dart';
import 'package:pocket_gallery/constant/icon.dart';
import 'package:pocket_gallery/service/app.dart';
import 'package:pocket_gallery/store/file.dart';
import 'package:signals/signals_flutter.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SignalBuilder(
        builder: (BuildContext context) {
          // ShowType showType = FilterStore.show();
          // ImageOrientation orientation = FilterStore.orientation();
          // if (!(showType.isAll && orientation.isAll)) {
          //   return Text('暂无任何图片', style: TextStyle(fontSize: 20));
          // }
          if (FileStore.folders().isNotEmpty) {
            return Text('暂无任何图片', style: TextStyle(fontSize: 20));
          }
          return Column(
            mainAxisAlignment: .center,
            children: [
              BaseIcon(svg: AppIcon.images, size: 144),
              Text(
                '暂无任何图片\n选择或拖动文件夹到这里',
                style: TextStyle(fontSize: 14),
                textAlign: .center,
              ),
              SizedBox(height: 12.0),
              Material(
                borderRadius: .circular(40),
                color: Color(0x22222208),
                child: InkWell(
                  borderRadius: .circular(40),
                  onTap: addFolders,
                  child: Container(
                    height: 36,
                    padding: .symmetric(horizontal: 16),
                    child: Row(
                      spacing: 8,
                      mainAxisSize: .min,
                      children: [
                        BaseIcon(
                          icon: Icons.folder_open_rounded,
                          size: 20,
                          color: Colors.grey,
                        ),
                        Text(
                          '添加文件夹',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
