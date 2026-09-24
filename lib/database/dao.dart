import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'data.dart';

part 'dao.g.dart';

@DriftDatabase(tables: [ImageItem])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async => m.createAll(),
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // 使用生成的表实例和列字段
          await m.addColumn(imageItem, imageItem.blurhash);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'pocket_gallery_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
