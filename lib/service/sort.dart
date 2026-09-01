// ignore_for_file: constant_identifier_names
// ignore_for_file: non_constant_identifier_names
import 'package:lpinyin/lpinyin.dart';

class SortService {
  static const int CODE_0 = 48,
      CODE_9 = 57,
      CODE_A = 65,
      CODE_Z = 90,
      CODE_a = 97,
      CODE_z = 122;

  SortService._();

  static bool isCode_num(int code) {
    return (code >= CODE_0 && code <= CODE_9);
  }

  static bool isCode_AZ(int code) {
    return (code >= CODE_A && code <= CODE_Z);
  }

  static bool isCode_az(int code) {
    return (code >= CODE_a && code <= CODE_z);
  }

  static bool isCode_AZaz(int code) {
    return (isCode_AZ(code) || isCode_az(code));
  }

  /// 如果是字母，则转为大写[A-Z]，否则返回[null]
  static int? toCode_tryAZ(int code) {
    if (isCode_az(code)) {
      return code - (CODE_a - CODE_A);
    } else if (isCode_AZ(code)) {
      return code;
    }
    return null;
  }

  /// 如果是字母，则转为大写[a-z]，否则返回[null]
  static int? toCode_tryaz(int code) {
    if (isCode_az(code)) {
      return code;
    } else if (isCode_AZ(code)) {
      return code + (CODE_a - CODE_A);
    }
    return null;
  }

  /// 如果是字母，则转为大写[A-Z]，否则返回[code]
  static int toCode_mayAZ(int code) {
    return toCode_tryAZ(code) ?? code;
  }

  /// 如果是字母，则转为大写[a-z]，否则返回[null]
  static int? toCode_mayaz(int code) {
    return toCode_tryaz(code) ?? code;
  }

  /// 转为大写字母
  /// * 必须确保[code]是字母
  static int toCode_AZ(int code) {
    if (isCode_az(code)) {
      return code - (CODE_a - CODE_A);
    }
    assert(isCode_AZ(code));
    return code;
  }

  /// 转为小写字母
  /// * 必须确保[code]是字母
  static int toCode_az(int code) {
    if (isCode_AZ(code)) {
      return code + (CODE_a - CODE_A);
    }
    assert(isCode_az(code));
    return code;
  }

  /// 会忽略[str]开头的空白符
  /// * 如果[str]的首字符为中文字符，将转换返回该字符的拼音
  /// * 如果 [str] 为字母，将转为[小写]并返回该字母
  /// * 如果 [str] 为数字，则返回数值
  /// * 如果 [str] 为空、无法转为拼音，则返回 null
  static String? getFirstCharPinyin(
    String str, {
    bool enableAZ = true,
    bool enableNum = true,
  }) {
    if (str.isEmpty) {
      return null;
    }
    // 移除开头的空白符
    str = removeBetweenSpace(str, subRight: false);
    if (str.isEmpty) {
      return null;
    }
    final code = str.codeUnitAt(0);
    if (isCode_num(code)) {
      if (enableNum) {
        return str[0];
      } else {
        return null;
      }
    } else if (isCode_az(code)) {
      if (enableAZ) {
        return str[0];
      } else {
        return null;
      }
    } else if (isCode_AZ(code)) {
      if (enableAZ) {
        return String.fromCharCode(code + (CODE_a - CODE_A));
      } else {
        return null;
      }
    } else {
      final result = PinyinHelper.getFirstWordPinyin(str);
      if (result.isNotEmpty) {
        // 非空
        if (isCode_AZaz(result.codeUnitAt(0))) {
          // 第一个字符在 [A-Za-z]
          return result.toLowerCase();
        }
      }
      return null;
    }
  }

  /// 只返回[str]的第一个字符的类别
  /// * 如果是中文，转为拼音，并把拼音第一个字母返回
  /// * 如果是字母，返回小写字母
  /// * 如果是数字，则返回数字
  static String? getFirstCharPinyinFirstChar(String str) {
    final restr = getFirstCharPinyin(str);
    if (null != restr && restr.isNotEmpty) {
      return restr[0];
    }
    return null;
  }

  /// 获取字符的可比较形式
  /// 返回 null 表示该字符不是中英文字符（特殊字符）
  /// 返回非 null 为拼音首字母的小写 codeUnit
  static int? _getComparableCode(String str, int index) {
    final int code = str.codeUnitAt(index);

    if (isCode_az(code)) return code;
    if (isCode_AZ(code)) return code + (CODE_a - CODE_A);

    if (code < 128) return null;

    final String target = index == 0 ? str : str[index];
    final String? pinyin = _getFirstCharPinyinFast(target);
    if (pinyin != null && pinyin.isNotEmpty) {
      final int pinyinCode = pinyin.codeUnitAt(0);
      if (isCode_AZ(pinyinCode)) return pinyinCode + (CODE_a - CODE_A);
      if (isCode_az(pinyinCode)) return pinyinCode;
    }
    return null;
  }

  /// getFirstCharPinyin 跳过 removeBetweenSpace
  static String? _getFirstCharPinyinFast(String str) {
    if (str.isEmpty) return null;
    final int code = str.codeUnitAt(0);
    if (isCode_num(code)) return str[0];
    if (isCode_az(code)) return str[0];
    if (isCode_AZ(code)) return String.fromCharCode(code + (CODE_a - CODE_A));

    final String result = PinyinHelper.getFirstWordPinyin(str);
    if (result.isNotEmpty && isCode_AZaz(result.codeUnitAt(0))) {
      return result.toLowerCase();
    }
    return null;
  }

  /// ## 扩展名称排序
  /// - 支持数值排序
  ///   - 得到 1，2，3，04, 005, ...，11，012，13，...
  ///   - 而非 1，11，12，13，2，3，
  /// - 支持中文转拼音后排序
  /// - 整体顺序：
  ///   - 数值
  ///   - 特殊字符
  ///   - A-Z（中英文字符混合排序）
  /// - return :
  ///   - 左排前，返回 < 0
  ///   - 右排前，返回 > 0
  ///   - 相等返回0
  /// 自定义排序方法：数字 -> 英文 -> 中文，且支持数字自然排序
  static int compareExtend(String? left, String? right) {
    // 1. 处理 null 和空字符串
    if (null == left || left.isEmpty) {
      if (null == right || right.isEmpty) return 0;
      return -1; // 空排前面
    }
    if (null == right || right.isEmpty) return 1;

    // 2. 判断首字符类型，赋予不同的优先级
    // 优先级：数字(0) < 英文(1) < 中文(2) < 其他(3)
    int getCharType(String s) {
      final code = s.codeUnitAt(0);
      if (isCode_num(code)) return 0;
      if ((code >= 65 && code <= 90) || (code >= 97 && code <= 122)) {
        return 1; // A-Z, a-z
      }
      if (isChinese(code)) return 2; // 中文字符
      return 3; // 特殊符号等
    }

    final leftType = getCharType(left);
    final rightType = getCharType(right);

    // 如果首字符类型不同，直接按类型优先级排序
    if (leftType != rightType) {
      return leftType - rightType;
    }

    // 3. 如果类型相同，进入详细比较逻辑（支持数字自然排序）
    int i = 0, j = 0;

    while (i < left.length && j < right.length) {
      final leftCode = left.codeUnitAt(i);
      final rightCode = right.codeUnitAt(j);
      final leftIsNum = isCode_num(leftCode);
      final rightIsNum = isCode_num(rightCode);

      // 如果一个字符是数字，另一个不是，数字排前面
      if (leftIsNum != rightIsNum) {
        return leftIsNum ? -1 : 1;
      }

      // 如果都是数字，提取完整的数字串进行数值比较
      if (leftIsNum) {
        int leftSum = 0;
        while (i < left.length && isCode_num(left.codeUnitAt(i))) {
          leftSum = leftSum * 10 + (left.codeUnitAt(i) - CODE_0);
          i++;
        }
        int rightSum = 0;
        while (j < right.length && isCode_num(right.codeUnitAt(j))) {
          rightSum = rightSum * 10 + (right.codeUnitAt(j) - CODE_0);
          j++;
        }
        if (leftSum != rightSum) {
          return leftSum - rightSum; // 按数值大小比较
        }
        continue; // 数值相等，继续比较后面的字符
      }

      // 如果都不是数字（即都是文本），按原有逻辑比较
      final int? leftComp = _getComparableCode(left, i);
      final int? rightComp = _getComparableCode(right, j);

      if (leftComp != null && rightComp != null) {
        final int result = leftComp - rightComp;
        if (result != 0) return result;
      } else if (leftComp != null) {
        return 1;
      } else if (rightComp != null) {
        return -1;
      } else {
        final int leftLower = toCode_tryaz(leftCode) ?? leftCode;
        final int rightLower = toCode_tryaz(rightCode) ?? rightCode;
        final int result = leftLower - rightLower;
        if (result != 0) return result;
      }

      i++;
      j++;
    }

    // 如果前面都相同，短字符串排在前面
    if (i < left.length || j < right.length) {
      return (left.length - right.length);
    }
    return 0;
  }

  /// 辅助方法：判断是否为中文字符
  static bool isChinese(int code) {
    return (code >= 0x4E00 && code <= 0x9FFF) ||
        (code >= 0x3400 && code <= 0x4DBF) ||
        (code >= 0x20000 && code <= 0x2A6DF);
  }

  /// 将 路径 规范化，去除多余的 / 或 \
  static String toStandardPath(String path) {
    return path
        // 合并 \\\ 为 \
        .replaceAll(RegExp(r'\\{2,}'), r'\')
        // 合并 /// 为 /
        .replaceAll(RegExp(r'/{2,}'), '/')
        // 合并连续 \/\/ 为 \
        .replaceAll(RegExp(r'[\\/]{2,}'), r'\');
  }

  static String toWindowsStandardPath(String path) {
    return path.replaceAll(RegExp(r'[/\\]+'), r'\');
  }

  /// 将路径unix标准化
  static String toUnixStandardPath(String path) {
    return path.replaceAll(RegExp(r'[/\\]+'), '/');
  }

  static String toUnixStandardDirPath(String path) {
    if (path.isEmpty) {
      return path;
    }
    return toUnixStandardPath(path.endsWith("/") ? path : "$path/");
  }

  /// ## 获取文件或文件夹名称
  /// * [useRigthDot] 判断扩展名时应当取左还是右边的点[.]
  /// ### 特殊情况
  /// * [in_path] 空字符串；返回空字符串 ""
  /// * in_path = "/" 或 "\"；返回本身 "/" 或 "\"
  static String getFileName(
    String in_path, {
    bool removeEXT = false, // 是否去掉扩展名
    bool useRigthDot = true,
  }) {
    if (in_path.isEmpty) {
      return "";
    }
    int i = in_path.length;
    bool isContinueDot = false;
    // 去除尾部的/或\
    while (i-- > 0) {
      if (in_path[i] != '/' && in_path[i] != r'\') {
        break;
      }
      // 如果移除过尾部的斜杠，说明是文件夹，不需要识别扩展名
      removeEXT = false;
    }
    int nameEndIndex = i + 1;
    // 开始查找名称之前的 / 或 \，以及名称之后的.
    // 记录左右.的位置
    int? leftDotIndex, leftTempDotIndex, rightDotIndex;
    if (nameEndIndex <= 0) {
      return in_path;
    }
    for (; i-- > 0;) {
      if (in_path[i] == '/' || in_path[i] == r'\') {
        // 如果为路径符号
        if (i == in_path.length) {
          return "";
        } else {
          break;
        }
      } else if ('.' == in_path[i]) {
        // .
        if (removeEXT) {
          rightDotIndex ??= i;
          leftTempDotIndex = leftDotIndex;
          leftDotIndex = i;
          isContinueDot = (leftDotIndex != rightDotIndex);
        }
      } else {
        isContinueDot = false;
      }
    }
    // 修正右边界
    rightDotIndex ??= nameEndIndex;
    var start = i + 1;
    int? end;
    if (useRigthDot) {
      end = rightDotIndex;
    } else {
      end = leftDotIndex;
    }
    if (start < 0) {
      start = 0;
    }
    if (null != end && end < 0) {
      end = 0;
    }
    if (leftDotIndex == start) {
      // .开头，整个文件名都是扩展名
      if (isContinueDot ||
          false == removeEXT ||
          leftDotIndex == rightDotIndex) {
        // 连续 .
        // 不删扩展名
        // 只有开头一个点
        end = nameEndIndex;
      } else {
        // 移除扩展名
        if (useRigthDot) {
          end = rightDotIndex;
        } else {
          // 此时[leftDotIndex]是开头的.因此需要取第二个点
          end = leftTempDotIndex;
        }
      }
    }
    return in_path.substring(start, end);
  }

  /// 获取文件扩展名
  /// 即识别最后一个.之后的字符串
  static String? getFileNameEXT(String? in_path) {
    /// 排除：
    ///   空字符串
    ///   xxx.
    ///   xxx/
    ///   xxx\
    if (null == in_path ||
        in_path.isEmpty ||
        in_path.endsWith('.') ||
        in_path.endsWith("/") ||
        in_path.endsWith(r"\")) {
      return null;
    }

    /// xx.xx
    /// i > 1 排除.开头的情况 .xxx
    for (int i = in_path.length - 1; i-- > 1;) {
      if (in_path[i] == '.') {
        return in_path.substring(i + 1);
      }
    }
    return null;
  }

  static String replaceOrAppendExt(String inpath, String newExt) {
    final ext = getFileNameEXT(inpath);
    if (null != ext) {
      return inpath.replaceRange(
        inpath.length - ext.length,
        inpath.length,
        newExt,
      );
    }
    if (inpath.endsWith(".")) {
      return inpath + newExt;
    }
    return "$inpath.$newExt";
  }

  /// 获取文件或文件夹的父目录路径
  static String? getParentDirPath(String? in_path) {
    if (null == in_path || in_path.isEmpty) {
      return null;
    }
    int i = in_path.length;
    // 去掉末尾的 / 或 \
    while (i-- > 0) {
      if (in_path[i] != '/' && in_path[i] != r'\') {
        break;
      }
    }
    if (i < 0 && in_path.isNotEmpty) {
      // 全是 / 或 \
      return "/";
    }
    for (; i-- > 0;) {
      if (in_path[i] == '/' || in_path[i] == r'\') {
        if (i == in_path.length) {
          return "";
        } else {
          return in_path.substring(0, i + 1);
        }
      }
    }
    // 前面没有 /
    // xxx
    // 尾部有 / ，但前面没有 /，仍应丢弃
    // xxx/
    return null;
  }

  /// 移除所有空白符号
  static String removeAllSpace(String str) {
    return str.replaceAll(RegExp(r"\s+"), "");
  }

  /// 移除[str]所有空白符号，如果str为[null]或移除空白符号后是[空字符串]则返回[null]
  static String? removeAllSpaceMayNull(String? str) {
    if (null == str || str.isEmpty) {
      return null;
    }
    final result = removeAllSpace(str);
    if (result.isEmpty) {
      return null;
    }
    return result;
  }

  /// 移除[str]两边的（空格|制表符\t）
  /// - [removeLine] 是否移除两边的换行符号
  static String removeBetweenSpace(
    String str, {
    bool removeLine = true,
    bool subLeft = true,
    bool subRight = true,
  }) {
    assert(subLeft || subRight);
    if (str.isEmpty) {
      return str;
    }
    int left = 0, right = str.length - 1;
    if (subRight) {
      for (; right >= left; --right) {
        if (str[right] != ' ' &&
            str[right] != '\t' &&
            (false == removeLine ||
                (str[right] != '\r' && str[right] != '\n'))) {
          break;
        }
      }
    }
    if (subLeft) {
      for (; left <= right; ++left) {
        if (str[left] != ' ' &&
            str[left] != '\t' &&
            (false == removeLine || (str[left] != '\r' && str[left] != '\n'))) {
          break;
        }
      }
    }
    if (left <= right) {
      return str.substring(left, right + 1);
    } else {
      return "";
    }
  }

  /// 移除[str]两端的（空格|制表符\t），
  /// 如果[str]为[null]或移除空白符号后得到[空字符串]则返回[null]
  static String? removeBetweenSpaceMayNull(
    String? str, {
    bool removeLine = true,
    bool subLeft = true,
    bool subRight = true,
  }) {
    if (null == str) {
      return null;
    }
    final result = removeBetweenSpace(
      str,
      removeLine: removeLine,
      subLeft: subLeft,
      subRight: subRight,
    );
    if (result.isEmpty) {
      return null;
    }
    return result;
  }

  static bool isIgnoreCaseEqual(String left, String right) {
    if (left.length == right.length) {
      return left.toLowerCase() == right.toLowerCase();
    }
    return false;
  }

  /// 判断[longStr]是否包含[shortStr]，忽略大小写
  static bool isIgnoreCaseContains(String longStr, String shortStr) {
    return longStr.toLowerCase().contains(shortStr.toLowerCase());
  }

  /// 判断[str1]和[str2]中长的字符串是否包含短的字符串，忽略大小写
  static bool isIgnoreCaseContainsAny(String str1, String str2) {
    return (str1.length >= str2.length)
        ? isIgnoreCaseContains(str1, str2)
        : isIgnoreCaseContains(str2, str1);
  }

  /// 是否[str1]和[str2]都非空，并且其中长的字符串包含端的字符串，忽略大小写
  static bool isNotEmptyAndIgnoreCaseContains(String? str1, String? str2) {
    if (str1 == null || str2 == null || str1.isEmpty || str2.isEmpty) {
      return false;
    }
    return isIgnoreCaseContains(str1, str2);
  }

  /// 是否[str1]和[str2]都非空，并且其中长的字符串包含端的字符串，忽略大小写
  static bool isNotEmptyAndIgnoreCaseContainsAny(String? str1, String? str2) {
    if (str1 == null || str2 == null || str1.isEmpty || str2.isEmpty) {
      return false;
    }
    return isIgnoreCaseContainsAny(str1, str2);
  }

  static String? subString(String str, {int start = 0, int? end}) {
    if (start > str.length) {
      return null;
    }
    if (null != end) {
      if (end < start) {
        return null;
      }
      if (end > str.length) {
        end = null;
      }
    }
    return str.substring(start, end);
  }

  static String toArgument(String str, {String mark = '"'}) {
    assert(mark.length == 1);
    final result = str.replaceAllMapped(
      RegExp('(^|[^\\\\])((\\$mark)+)', multiLine: true),
      (match) {
        final marklist = match[2] ?? "";
        final m = StringBuffer();
        for (int i = 0; i < marklist.length; ++i) {
          m.write("\\$mark");
        }
        return "${match[1]}$m";
      },
    );
    return "$mark$result$mark";
  }
}
