// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dao.dart';

// ignore_for_file: type=lint
class $ImageItemTable extends ImageItem
    with TableInfo<$ImageItemTable, ImageItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImageItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderMeta = const VerificationMeta('folder');
  @override
  late final GeneratedColumn<String> folder = GeneratedColumn<String>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orientationMeta = const VerificationMeta(
    'orientation',
  );
  @override
  late final GeneratedColumn<int> orientation = GeneratedColumn<int>(
    'orientation',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedMeta = const VerificationMeta(
    'modified',
  );
  @override
  late final GeneratedColumn<String> modified = GeneratedColumn<String>(
    'modified',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    folder,
    path,
    width,
    height,
    orientation,
    modified,
    size,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'image_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImageItemData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('folder')) {
      context.handle(
        _folderMeta,
        folder.isAcceptableOrUnknown(data['folder']!, _folderMeta),
      );
    } else if (isInserting) {
      context.missing(_folderMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('orientation')) {
      context.handle(
        _orientationMeta,
        orientation.isAcceptableOrUnknown(
          data['orientation']!,
          _orientationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orientationMeta);
    }
    if (data.containsKey('modified')) {
      context.handle(
        _modifiedMeta,
        modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ImageItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImageItemData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      orientation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orientation'],
      )!,
      modified: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modified'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
    );
  }

  @override
  $ImageItemTable createAlias(String alias) {
    return $ImageItemTable(attachedDatabase, alias);
  }
}

class ImageItemData extends DataClass implements Insertable<ImageItemData> {
  final String id;
  final String name;
  final String folder;
  final String path;
  final int width;
  final int height;
  final int orientation;
  final String modified;
  final int size;
  const ImageItemData({
    required this.id,
    required this.name,
    required this.folder,
    required this.path,
    required this.width,
    required this.height,
    required this.orientation,
    required this.modified,
    required this.size,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['folder'] = Variable<String>(folder);
    map['path'] = Variable<String>(path);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['orientation'] = Variable<int>(orientation);
    map['modified'] = Variable<String>(modified);
    map['size'] = Variable<int>(size);
    return map;
  }

  ImageItemCompanion toCompanion(bool nullToAbsent) {
    return ImageItemCompanion(
      id: Value(id),
      name: Value(name),
      folder: Value(folder),
      path: Value(path),
      width: Value(width),
      height: Value(height),
      orientation: Value(orientation),
      modified: Value(modified),
      size: Value(size),
    );
  }

  factory ImageItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImageItemData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      folder: serializer.fromJson<String>(json['folder']),
      path: serializer.fromJson<String>(json['path']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      orientation: serializer.fromJson<int>(json['orientation']),
      modified: serializer.fromJson<String>(json['modified']),
      size: serializer.fromJson<int>(json['size']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'folder': serializer.toJson<String>(folder),
      'path': serializer.toJson<String>(path),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'orientation': serializer.toJson<int>(orientation),
      'modified': serializer.toJson<String>(modified),
      'size': serializer.toJson<int>(size),
    };
  }

  ImageItemData copyWith({
    String? id,
    String? name,
    String? folder,
    String? path,
    int? width,
    int? height,
    int? orientation,
    String? modified,
    int? size,
  }) => ImageItemData(
    id: id ?? this.id,
    name: name ?? this.name,
    folder: folder ?? this.folder,
    path: path ?? this.path,
    width: width ?? this.width,
    height: height ?? this.height,
    orientation: orientation ?? this.orientation,
    modified: modified ?? this.modified,
    size: size ?? this.size,
  );
  ImageItemData copyWithCompanion(ImageItemCompanion data) {
    return ImageItemData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      folder: data.folder.present ? data.folder.value : this.folder,
      path: data.path.present ? data.path.value : this.path,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      orientation: data.orientation.present
          ? data.orientation.value
          : this.orientation,
      modified: data.modified.present ? data.modified.value : this.modified,
      size: data.size.present ? data.size.value : this.size,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImageItemData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('folder: $folder, ')
          ..write('path: $path, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('orientation: $orientation, ')
          ..write('modified: $modified, ')
          ..write('size: $size')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    folder,
    path,
    width,
    height,
    orientation,
    modified,
    size,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImageItemData &&
          other.id == this.id &&
          other.name == this.name &&
          other.folder == this.folder &&
          other.path == this.path &&
          other.width == this.width &&
          other.height == this.height &&
          other.orientation == this.orientation &&
          other.modified == this.modified &&
          other.size == this.size);
}

class ImageItemCompanion extends UpdateCompanion<ImageItemData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> folder;
  final Value<String> path;
  final Value<int> width;
  final Value<int> height;
  final Value<int> orientation;
  final Value<String> modified;
  final Value<int> size;
  final Value<int> rowid;
  const ImageItemCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.folder = const Value.absent(),
    this.path = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.orientation = const Value.absent(),
    this.modified = const Value.absent(),
    this.size = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImageItemCompanion.insert({
    required String id,
    required String name,
    required String folder,
    required String path,
    required int width,
    required int height,
    required int orientation,
    required String modified,
    required int size,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       folder = Value(folder),
       path = Value(path),
       width = Value(width),
       height = Value(height),
       orientation = Value(orientation),
       modified = Value(modified),
       size = Value(size);
  static Insertable<ImageItemData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? folder,
    Expression<String>? path,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? orientation,
    Expression<String>? modified,
    Expression<int>? size,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (folder != null) 'folder': folder,
      if (path != null) 'path': path,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (orientation != null) 'orientation': orientation,
      if (modified != null) 'modified': modified,
      if (size != null) 'size': size,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImageItemCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? folder,
    Value<String>? path,
    Value<int>? width,
    Value<int>? height,
    Value<int>? orientation,
    Value<String>? modified,
    Value<int>? size,
    Value<int>? rowid,
  }) {
    return ImageItemCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      folder: folder ?? this.folder,
      path: path ?? this.path,
      width: width ?? this.width,
      height: height ?? this.height,
      orientation: orientation ?? this.orientation,
      modified: modified ?? this.modified,
      size: size ?? this.size,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (folder.present) {
      map['folder'] = Variable<String>(folder.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (orientation.present) {
      map['orientation'] = Variable<int>(orientation.value);
    }
    if (modified.present) {
      map['modified'] = Variable<String>(modified.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImageItemCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('folder: $folder, ')
          ..write('path: $path, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('orientation: $orientation, ')
          ..write('modified: $modified, ')
          ..write('size: $size, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ImageItemTable imageItem = $ImageItemTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [imageItem];
}

typedef $$ImageItemTableCreateCompanionBuilder = ImageItemCompanion Function({
  required String id,
  required String name,
  required String folder,
  required String path,
  required int width,
  required int height,
  required int orientation,
  required String modified,
  required int size,
  Value<int> rowid,
});
typedef $$ImageItemTableUpdateCompanionBuilder = ImageItemCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> folder,
  Value<String> path,
  Value<int> width,
  Value<int> height,
  Value<int> orientation,
  Value<String> modified,
  Value<int> size,
  Value<int> rowid,
});

class $$ImageItemTableFilterComposer
    extends Composer<_$AppDatabase, $ImageItemTable> {
  $$ImageItemTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folder => $composableBuilder(
    column: $table.folder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orientation => $composableBuilder(
    column: $table.orientation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImageItemTableOrderingComposer
    extends Composer<_$AppDatabase, $ImageItemTable> {
  $$ImageItemTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folder => $composableBuilder(
    column: $table.folder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orientation => $composableBuilder(
    column: $table.orientation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImageItemTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImageItemTable> {
  $$ImageItemTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get folder =>
      $composableBuilder(column: $table.folder, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get orientation => $composableBuilder(
    column: $table.orientation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modified =>
      $composableBuilder(column: $table.modified, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);
}

class $$ImageItemTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImageItemTable,
          ImageItemData,
          $$ImageItemTableFilterComposer,
          $$ImageItemTableOrderingComposer,
          $$ImageItemTableAnnotationComposer,
          $$ImageItemTableCreateCompanionBuilder,
          $$ImageItemTableUpdateCompanionBuilder,
          (
            ImageItemData,
            BaseReferences<_$AppDatabase, $ImageItemTable, ImageItemData>,
          ),
          ImageItemData,
          PrefetchHooks Function()
        > {
  $$ImageItemTableTableManager(_$AppDatabase db, $ImageItemTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImageItemTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImageItemTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImageItemTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> folder = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> orientation = const Value.absent(),
                Value<String> modified = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImageItemCompanion(
                id: id,
                name: name,
                folder: folder,
                path: path,
                width: width,
                height: height,
                orientation: orientation,
                modified: modified,
                size: size,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String folder,
                required String path,
                required int width,
                required int height,
                required int orientation,
                required String modified,
                required int size,
                Value<int> rowid = const Value.absent(),
              }) => ImageItemCompanion.insert(
                id: id,
                name: name,
                folder: folder,
                path: path,
                width: width,
                height: height,
                orientation: orientation,
                modified: modified,
                size: size,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImageItemTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImageItemTable,
      ImageItemData,
      $$ImageItemTableFilterComposer,
      $$ImageItemTableOrderingComposer,
      $$ImageItemTableAnnotationComposer,
      $$ImageItemTableCreateCompanionBuilder,
      $$ImageItemTableUpdateCompanionBuilder,
      (
        ImageItemData,
        BaseReferences<_$AppDatabase, $ImageItemTable, ImageItemData>,
      ),
      ImageItemData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ImageItemTableTableManager get imageItem =>
      $$ImageItemTableTableManager(_db, _db.imageItem);
}
