import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pocket_gallery/constant/num.dart';

class FooterView extends StatefulWidget {
  const FooterView({super.key});

  @override
  State<FooterView> createState() => _FooterViewState();
}

class _FooterViewState extends State<FooterView> {
  String version = '1.0.0';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 250.0) return SizedBox.shrink();
        return Padding(
          padding: .only(top: AppNum.paddingSmall, bottom: AppNum.padding),
          child: Text(
            '左键单击浏览图片，双击设置桌面壁纸\n长按打开文件位置，右键单击收藏\nv$version Copyright ilgnefz',
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: .center,
          ),
        );
      },
    );
  }
}
