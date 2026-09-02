import 'package:flutter/material.dart';

class FileImageWithKey extends FileImage {
  const FileImageWithKey(super.file, this.cacheKey);

  final String cacheKey;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileImageWithKey &&
        other.file.path == file.path &&
        other.cacheKey == cacheKey;
  }

  @override
  int get hashCode => Object.hash(file.path, cacheKey);
}
