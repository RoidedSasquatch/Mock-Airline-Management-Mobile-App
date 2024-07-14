// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airplane_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

/// Builder class for initializing and configuring the AppDatabase.
class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the database builder.
  /// Returns the updated database builder instance.
  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a callback to the database builder.
  /// Returns the updated database builder instance.
  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Builds the [AppDatabase] instance asynchronously.
  /// Resolves with the initialized [AppDatabase] instance.
  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

/// Database implementation for managing airplane data using SQLite.
class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AirplaneDao? _airplaneDaoInstance;

  /// Opens the database at the specified [path] with optional [migrations] and [callback].
  /// Returns a future with the initialized [sqflite.Database] instance.
  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Airplane` (`id` INTEGER NOT NULL, `airplaneType` TEXT NOT NULL, `maxPassengers` INTEGER NOT NULL, `maxSpeed` REAL NOT NULL, `maxRange` REAL NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  /// Returns the instance of [AirplaneDao] for interacting with airplane data.
  @override
  AirplaneDao get airplaneDao {
    return _airplaneDaoInstance ??= _$AirplaneDao(database, changeListener);
  }
}

/// DAO (Data Access Object) for managing Airplane entity operations in SQLite database.
class _$AirplaneDao extends AirplaneDao {
  _$AirplaneDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _airplaneInsertionAdapter = InsertionAdapter(
            database,
            'Airplane',
            (Airplane item) => <String, Object?>{
                  'id': item.id,
                  'airplaneType': item.airplaneType,
                  'maxPassengers': item.maxPassengers,
                  'maxSpeed': item.maxSpeed,
                  'maxRange': item.maxRange
                }),
        _airplaneUpdateAdapter = UpdateAdapter(
            database,
            'Airplane',
            ['id'],
            (Airplane item) => <String, Object?>{
                  'id': item.id,
                  'airplaneType': item.airplaneType,
                  'maxPassengers': item.maxPassengers,
                  'maxSpeed': item.maxSpeed,
                  'maxRange': item.maxRange
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Airplane> _airplaneInsertionAdapter;

  final UpdateAdapter<Airplane> _airplaneUpdateAdapter;

  /// Finds all Airplane items stored in the database.
  /// Returns a future with a list of [Airplane] objects.
  @override
  Future<List<Airplane>> findAllListItems() async {
    return _queryAdapter.queryList('SELECT * FROM Airplane',
        mapper: (Map<String, Object?> row) => Airplane(
            row['id'] as int,
            row['airplaneType'] as String,
            row['maxPassengers'] as int,
            row['maxSpeed'] as double,
            row['maxRange'] as double));
  }

  /// Finds a single Airplane item by its [id] in the database.
  /// Returns a future with the [Airplane] object, or null if not found.
  @override
  Future<Airplane?> findSingleListItem(int id) async {
    return _queryAdapter.query('SELECT FROM Airplane WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Airplane(
            row['id'] as int,
            row['airplaneType'] as String,
            row['maxPassengers'] as int,
            row['maxSpeed'] as double,
            row['maxRange'] as double),
        arguments: [id]);
  }

  /// Deletes the Airplane item with the given [id] from the database.
  /// Returns a future with the number of rows affected by the delete operation.
  @override
  Future<int?> delete(int id) async {
    return _queryAdapter.query('DELETE FROM Airplane WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  /// Inserts a new Airplane item into the database.
  /// Returns a future with the id of the inserted item.
  @override
  Future<int> insertList(Airplane airplane) {
    return _airplaneInsertionAdapter.insertAndReturnId(
        airplane, OnConflictStrategy.abort);
  }

  /// Updates an existing Airplane item in the database.
  /// Returns a future with the number of rows affected by the update operation.
  @override
  Future<int> updateList(Airplane airplane) {
    return _airplaneUpdateAdapter.updateAndReturnChangedRows(
        airplane, OnConflictStrategy.abort);
  }
}
