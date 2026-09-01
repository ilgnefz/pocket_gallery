import 'package:drift/drift.dart';

class ImageItem extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get folder => text()();
  TextColumn get path => text()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  IntColumn get orientation => integer()();
  TextColumn get modified => text()();
  IntColumn get size => integer()();
}
