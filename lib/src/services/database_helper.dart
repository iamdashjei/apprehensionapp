import 'dart:io';
import 'package:meta/meta.dart';
import 'package:pnpdict/src/models/apprehension.dart';
import 'package:pnpdict/src/models/violation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    final Directory _dbDir = Directory('/storage/emulated/0/data/pnp/db/');
    final Directory _imageDir = Directory('/storage/emulated/0/data/pnp/images/');
    //Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(_dbDir.path, 'outerboxpos.db');
    String imagePath = join(_imageDir.path, 'outerbox.txt');
    bool exists = await _dbDir.exists();
    var db;

    bool dbExists = await databaseExists(path);
    if(dbExists){
      print("DB EXISTS ");
    }
    if(exists){
      print("Directory exists");
      db = await openDatabase(path, version: 1);
    } else {
      print("Directory not exists creating now");
      try {
        await Directory(dirname(path)).create(recursive: true);
        await Directory(dirname(imagePath)).create(recursive: true);
        db = await openDatabase(path, version: 1, onCreate: _onCreate);
      } catch (e) {
        print(e);
      }


    }

    //var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    //var db = await openDatabase(path);
    return db;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future deleteDatabaseLogout() async {
    var dbClient = await db;
    await dbClient.rawDelete('DELETE FROM violations');
    await dbClient.rawDelete('DELETE FROM apprehensions');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE apprehensions ('
        'apprehension_id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'apprehension_name TEXT, '
        'barcode TEXT, '
        'violations TEXT, '
        'location TEXT, '
        'dl_number TEXT, '
        'apprehended_by TEXT, '
        'created_at TEXT, '
        'updated_at TEXT '
        ')',
    );

    await db.execute('CREATE TABLE violations ('
        'violation_id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'violation_name TEXT, '
        'value REAL, '
        'created_at TEXT, '
        'updated_at TEXT '
        ')',
    );
  }

  Future<List<Violation>> getAllViolations() async {
    var dbClient = await db;
    var data = await dbClient.rawQuery('SELECT * FROM violations');
    return data.map((e) => Violation.fromJson(e)).toList();
  }

  Future<List<Apprehension>> getAllApprehensions() async {
    var dbClient = await db;
    var data = await dbClient.rawQuery('SELECT * FROM apprehensions');
    return data.map((e) => Apprehension.fromJson(e)).toList();
  }

  Future<void> insertApprehension({
    @required Apprehension apprehension
  }) async {
    var dbClient = await db;
    await dbClient.insert('apprehensions', apprehension.toJson());

  }
}