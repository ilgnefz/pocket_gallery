import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 宽高比获取回调类型
typedef IndexedAspectRatioBuilder = double Function(
  BuildContext context,
  int index,
);

/// 内部行数据（存储索引列表，用于后续构建）
class _RowData {
  final List<int> indices; // 该行包含的原始索引
  final double ratioSum; // 该行所有宽高比之和

  _RowData({required this.indices, required this.ratioSum});
}

/// 仿 Win10 照片应用风格的通用比例网格组件（builder 形式）
class FlexibleAspectRatioGrid extends StatelessWidget {
  final EdgeInsets? padding;
  final int itemCount;
  final ScrollCacheExtent? scrollCacheExtent;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedAspectRatioBuilder aspectRatioBuilder;
  final double targetHeight;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const FlexibleAspectRatioGrid.builder({
    super.key,
    this.padding,
    required this.itemCount,
    this.scrollCacheExtent,
    required this.itemBuilder,
    required this.aspectRatioBuilder,
    required this.targetHeight,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
  }) : assert(itemCount >= 0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double extraWidth = padding?.horizontal == null
            ? 0
            : padding!.horizontal;
        final maxWidth = constraints.maxWidth - extraWidth;
        if (maxWidth <= 0 || itemCount == 0) {
          return const SizedBox.shrink();
        }

        // 1. 获取所有宽高比并分行
        final rows = _splitIntoRows(context, maxWidth);

        // 2. 构建列表
        return ListView.separated(
          padding: padding,
          scrollCacheExtent: scrollCacheExtent,
          itemCount: rows.length,
          itemBuilder: (context, rowIndex) {
            final row = rows[rowIndex];
            final bool isLastRow = rowIndex == rows.length - 1;

            if (isLastRow) {
              // 最后一行：固定高度为目标高度，不填满宽度，左对齐
              return _buildRowWithFixedHeight(context, row, targetHeight);
            } else {
              // 其他行：计算实际行高并填满宽度
              final rowHeight = _calculateRowHeight(row, maxWidth);
              return _buildRow(context, row, rowHeight, maxWidth);
            }
          },
          separatorBuilder: (context, rowIndex) {
            return SizedBox(height: mainAxisSpacing);
          },
        );
      },
    );
  }

  /// 将所有条目按宽高比和容器宽度分配到各行
  List<_RowData> _splitIntoRows(BuildContext context, double maxWidth) {
    final rows = <_RowData>[];
    var currentIndices = <int>[];
    var currentRatioSum = 0.0;

    for (int i = 0; i < itemCount; i++) {
      final ratio = aspectRatioBuilder(context, i);

      // 如果当前行已有条目，且加入新条目后预估总宽度会超出可用宽度，则结束当前行
      if (currentIndices.isNotEmpty &&
          (currentRatioSum + ratio) * targetHeight >
              maxWidth - crossAxisSpacing * currentIndices.length) {
        rows.add(
          _RowData(indices: List.of(currentIndices), ratioSum: currentRatioSum),
        );
        currentIndices = [];
        currentRatioSum = 0;
      }

      currentIndices.add(i);
      currentRatioSum += ratio;
    }

    // 处理最后一行
    if (currentIndices.isNotEmpty) {
      rows.add(_RowData(indices: currentIndices, ratioSum: currentRatioSum));
    }

    return rows;
  }

  /// 计算一行实际高度，使行内条目按比例缩放后总宽度等于容器宽度
  double _calculateRowHeight(_RowData row, double maxWidth) {
    final itemCountInRow = row.indices.length;
    final totalSpacing = crossAxisSpacing * (itemCountInRow - 1);
    final availableWidth = maxWidth - totalSpacing;
    return availableWidth / row.ratioSum;
  }

  /// 构建一行（填满宽度模式），内部根据索引调用 itemBuilder
  Widget _buildRow(
    BuildContext context,
    _RowData row,
    double rowHeight,
    double maxWidth,
  ) {
    final children = <Widget>[];
    double accumulatedWidth = 0;

    for (int i = 0; i < row.indices.length; i++) {
      final originalIndex = row.indices[i];
      final ratio = aspectRatioBuilder(context, originalIndex);

      // 计算当前条目宽度，最后一个占满剩余宽度（避免浮点误差）
      double width;
      if (i == row.indices.length - 1) {
        width =
            maxWidth -
            accumulatedWidth -
            crossAxisSpacing * (row.indices.length - 1);
      } else {
        width = rowHeight * ratio;
        accumulatedWidth += width;
      }

      children.add(
        SizedBox(
          width: width,
          height: rowHeight,
          child: itemBuilder(context, originalIndex),
        ),
      );

      if (i != row.indices.length - 1) {
        children.add(SizedBox(width: crossAxisSpacing));
      }
    }

    return Row(children: children);
  }

  /// 构建最后一行（固定高度模式）：使用 targetHeight 作为行高，内容左对齐
  Widget _buildRowWithFixedHeight(
    BuildContext context,
    _RowData row,
    double rowHeight,
  ) {
    final children = <Widget>[];

    for (int i = 0; i < row.indices.length; i++) {
      final originalIndex = row.indices[i];
      final ratio = aspectRatioBuilder(context, originalIndex);
      final width = rowHeight * ratio;

      children.add(
        SizedBox(
          width: width,
          height: rowHeight,
          child: itemBuilder(context, originalIndex),
        ),
      );

      if (i != row.indices.length - 1) {
        children.add(SizedBox(width: crossAxisSpacing));
      }
    }

    return Row(mainAxisAlignment: MainAxisAlignment.start, children: children);
  }
}
