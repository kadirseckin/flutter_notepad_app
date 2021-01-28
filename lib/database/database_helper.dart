import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_notes_app/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//database methods and variables

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      return _databaseHelper = DatabaseHelper._internal();
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initalizeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  _initalizeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notesDB.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notesDB.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    return await openDatabase(path, readOnly: false);
  }

  //CRUD operations
  Future<List<Map<String, dynamic>>> getNotes() async {
    var db = await _getDatabase();
    var result = await db.query("notes", orderBy: 'noteID DESC');
    print(result);
    return result;
  }

  Future<List<Note>> getNotesList() async {
    var mapList = await getNotes();
    List<Note> noteList = List();

    for (Map m in mapList) {
      noteList.add(Note.fromMap(m));
    }
    return noteList;
  }

  addNote(Note note) async {
    var db = await _getDatabase();
    var result = await db.insert("notes", note.toMap());
    print(result.toString() + " added ");
  }

  updateNote(Note note) async {
    var db = await _getDatabase();
    var result = await db.update("notes", note.toMap(),
        where: 'noteID=?', whereArgs: [note.noteID]);
    print(
      result.toString() + " updated ",
    );
  }

  deleteNote(int id) async {
    var db = await _getDatabase();
    var result = await db.delete("notes", where: 'noteID=?', whereArgs: [id]);
    print(
      result.toString() + " deleted ",
    );
  }
}
