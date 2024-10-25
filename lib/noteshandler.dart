import 'package:notes01/notes.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class NoteHandler {
  static const _databaseName = "myDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'notes';
  static const columnId = '_id';
  static const columnTitle = 'title';
  static const columnDesc = 'desc';
  static const columnDate = 'date';

  // make this a singleton class
  NoteHandler._privateConstructor();
  static final NoteHandler instance = NoteHandler._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) {
      db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDesc INTEGER NOT NULL,
            $columnDate INTEGER NOT NULL
          )
          ''');
    });
  }
  static insert(String title , String desc) {
    DateTime now = DateTime.now();
    _database!.insert(
      'notes',
      {
        'title': title,
        'desc': desc,
        'date': "${now.year}-${now.month}-${now.day}"
      },
    );
  }
  static getAllNotes() async {
    var row = await _database!.query('notes');
    List<Note> notes = row.map((json) => Note.fromJson(json)).toList();
    return notes;
  }
  static deleteAllNotes()  {
    _database!.delete('notes');
  }
  static deleteNote(int id)  {
    _database!.delete(
      'notes',
      where: '_id = ?',
      whereArgs: [id],
    );
  }
  static update(Note note) async {
    DateTime now = DateTime.now();
    _database!.update(
      'notes',
      {
        'title': note.title,
        'desc': note.desc,
        'date': "${now.year}-${now.month}-${now.day}"
      },
      where: '_id = ?',
      whereArgs: [note.id],
    );
  }
}

Future<Database> openMyDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'myDatabase.db');
  final database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      // Create tables here
    },
  );
  return database;
}
