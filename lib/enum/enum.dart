import 'package:pocket_gallery/src/rust/api/model.dart';

extension ImageOrientationExtension on ImageOrientation {
  String get label {
    switch (this) {
      case ImageOrientation.all:
        return '全部';
      case ImageOrientation.landscape:
        return '横向';
      case ImageOrientation.portrait:
        return '竖向';
      case ImageOrientation.square:
        return '方形';
      case ImageOrientation.other:
        return '其他';
    }
  }

  bool get isAll => this == ImageOrientation.all;
  bool get isLandscape => this == ImageOrientation.landscape;
  bool get isPortrait => this == ImageOrientation.portrait;
  bool get isSquare => this == ImageOrientation.square;
  bool get isOther => this == ImageOrientation.other;
}

enum SortType {
  none,
  nameAscending,
  nameDescending,
  sizeAscending,
  sizeDescending,
  orientationAscending,
  orientationDescending,
}

extension SortTypeExtension on SortType {
  String get label {
    switch (this) {
      case SortType.none:
        return '默认';
      case SortType.nameAscending:
        return '名称升序';
      case SortType.nameDescending:
        return '名称降序';
      case SortType.sizeAscending:
        return '大小升序';
      case SortType.sizeDescending:
        return '大小降序';
      case SortType.orientationAscending:
        return '尺寸升序';
      case SortType.orientationDescending:
        return '尺寸降序';
    }
  }

  bool get isNone => this == SortType.none;
  bool get isNameAscending => this == SortType.nameAscending;
  bool get isNameDescending => this == SortType.nameDescending;
  bool get isSizeAscending => this == SortType.sizeAscending;
  bool get isSizeDescending => this == SortType.sizeDescending;
  bool get isOrientationAscending => this == SortType.orientationAscending;
  bool get isOrientationDescending => this == SortType.orientationDescending;
}

enum ShowType { all, like, unlike }

extension ShowTypeExtension on ShowType {
  String get label {
    switch (this) {
      case ShowType.all:
        return '全部';
      case ShowType.like:
        return '收藏';
      case ShowType.unlike:
        return '非收藏';
    }
  }

  bool get isAll => this == ShowType.all;
  bool get isLike => this == ShowType.like;
  bool get isUnlike => this == ShowType.unlike;
}

enum LayoutStyle { equalHeight, equalWidth }

extension LayoutStyleExtension on LayoutStyle {
  String get label {
    switch (this) {
      case LayoutStyle.equalHeight:
        return '等高';
      case LayoutStyle.equalWidth:
        return '等宽';
    }
  }

  bool get isEqualHeight => this == LayoutStyle.equalHeight;
  bool get isEqualWidth => this == LayoutStyle.equalWidth;
}
