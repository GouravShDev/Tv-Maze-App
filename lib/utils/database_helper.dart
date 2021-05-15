import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tv_maze/models/shows.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database;

  String showsLibrary = 'library';
  String colId = 'id';
  String colName = 'name';
  String colImageUrl = 'imageUrl';
  String colRating = 'rating';
  String colStatus = 'status';
  String colData = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async {
    // Get the directory path to Store Database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'showsLibrary.db';

    var showsDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return showsDatabase;
  }

  // Create Database using basic Sql command
  Future<void> _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $showsLibrary($colId INTEGER PRIMARY KEY, $colName TEXT, $colImageUrl TEXT, $colRating STRING, $colStatus TEXT)');
  }

  // Fetch Operation : Get all show from Database
  getShowMapList() async{
    Database db = await this.database;
    var result = await db.query(showsLibrary);
    return result;
  }

  // Insert Operation : Insert a Show Object to Database
  Future<int> insertShow(Shows show) async{
    Database db = await this.database;
    var result = await db.insert(showsLibrary, show.toMap());
    print(result);
    return result;
  }

  // Update Operation : Update a Show Object and save it to Database
  Future<int> updateShow(Shows show) async {
    var db = await this.database;
    var result = db.update(showsLibrary, show.toMap(), where: '$colId = ?', whereArgs: [show.id]);
    return result;
  }

  // Delete Operation : Delete a show object from Database
  Future<int> deleteShow(String id) async {
    var db = await this.database;
    int result = await db.delete(showsLibrary, where: '$colId = ?',whereArgs: [id]);
    return result;
  }

  // Fetch Operation: Get Show from database using id
  Future<Shows> getShowById(String id) async {
    var db = await this.database;
    var showMap = await db.query(showsLibrary,where: '$colId = ?',whereArgs: [id]);
    if(showMap.isEmpty){
      return null;
    }else{
      return Shows.fromDatabaseMap(showMap[0]);
    }
  }

  // Get number of Show Objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $showsLibrary');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' and convert it to 'ShowList'
  Future<List<Shows>> getShowList() async{
    var showMapList = await getShowMapList();
    int count = showMapList.length;

    List<Shows> showList = List<Shows>();
    for(int i = 0; i < count; i++){
      showList.add(Shows.fromDatabaseMap(showMapList[i]));
    }
    return showList;
  }
}
