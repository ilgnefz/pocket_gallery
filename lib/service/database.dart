import 'package:pocket_gallery/db/dao.dart';
import 'package:pocket_gallery/src/rust/api/model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  factory DatabaseService() => _instance;
  DatabaseService._();

  static late AppDatabase _database;

  static void init() => _database = AppDatabase();

  static Future<List<ImageItemData>> getItems() async =>
      await _database.select(_database.imageItem).get();

  static Future<void> insert(ImageFile file) async {
    final database = _database.into(_database.imageItem);
    await database.insert(
      ImageItemCompanion.insert(
        id: file.id,
        name: file.name,
        folder: file.folder,
        path: file.path,
        width: file.width,
        height: file.height,
        orientation: file.orientation.index,
        modified: file.modified.toString(),
        size: file.size,
      ),
    );
  }

  static Future<void> removeFolder(String folder) async =>
      await (_database.delete(
        _database.imageItem,
      )..where((e) => e.folder.equals(folder))).go();

  static Future<void> removeById(String id) async => await (_database.delete(
    _database.imageItem,
  )..where((e) => e.id.equals(id))).go();
}
