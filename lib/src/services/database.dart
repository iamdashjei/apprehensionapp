import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// delete the db, create the folder and returnes its path
Future<String> initDeleteDb(String dbName) async {
  final Directory _dbDir = Directory('/storage/emulated/0/data/pnp/db/');
  final databasePath = await getDatabasesPath();
  final path = join(_dbDir.path, dbName);

  // make sure the folder exists
  // ignore: avoid_slow_async_io
  if (await Directory(dirname(_dbDir.path)).exists()) {
    await deleteDatabase(_dbDir.path);
  } else {
    try {
      await Directory(dirname(_dbDir.path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
  }
  return path;
}