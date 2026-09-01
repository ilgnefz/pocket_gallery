import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
        if (constraints.maxWidth < 250) return SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            '左键单击浏览图片，双击设置桌面壁纸\n右击打开文件所在位置\nv$version Copyright ilgnefz',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: .center,
          ),
        );
      },
    );
  }
}
