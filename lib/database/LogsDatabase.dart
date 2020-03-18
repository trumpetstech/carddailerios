import 'dart:io';

import 'package:dailer/models/Log.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LogsDatabase {
  
  static final _databaseName = "CardDailerLogs.db";
  static final _databaseVersion = 1;

  static final table = 'logs';
  
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnTime = 'time';
  static final columnPhone = 'phone';

  // make this a singleton class
  LogsDatabase._privateConstructor();
  static final LogsDatabase instance = LogsDatabase._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _logsDatabase;
  Future<Database> get logsDatabase async {
    if (_logsDatabase != null) return _logsDatabase;
    // lazily instantiate the db the first time it is accessed
    _logsDatabase = await _initDatabase();
    return _logsDatabase;
  }
  
  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnTime TEXT NOT NULL,
            $columnPhone TEXT NOT NULL
          )
          ''');
  }
  
  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.logsDatabase;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is 
  // a key-value list of columns.
  Future<List<Log>> queryAllRows() async {
    Database db = await instance.logsDatabase;
    var allRows = await db.query(table);
      
    List<Log> logs = allRows.isNotEmpty ? allRows.map((c) => Log.fromMap(c)).toList() : [];
    print('query all rows:' + logs.toString());
    return logs;
  
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.logsDatabase;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other 
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.logsDatabase;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is 
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.logsDatabase;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}