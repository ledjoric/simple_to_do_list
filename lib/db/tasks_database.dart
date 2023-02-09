import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_list/models/task.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();

  static Database? _database;

  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableTasks (
      ${TaskFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${TaskFields.name} TEXT NOT NULL,
      ${TaskFields.note} TEXT NOT NULL,
      ${TaskFields.isCompleted} BOOLEAN NOT NULL,
      ${TaskFields.priority} INTEGER NOT NULL
      )
      ''');
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;

    final id = await db.insert(tableTasks, task.toJson());
    return task.copy(id: id);
  }

  Future<Task> readTask(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTasks,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Task>> readAllTasks(String orderBy, int isCompleted) async {
    final db = await instance.database;

    //const orderBy = '${TaskFields.id} ASC';
    final completed = '${TaskFields.isCompleted} = $isCompleted';
    final result =
        await db.query(tableTasks, orderBy: orderBy, where: completed);

    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<int> update(Task task) async {
    final db = await instance.database;

    return db.update(
      tableTasks,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db.delete(
      tableTasks,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
