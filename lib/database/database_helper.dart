import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'user.dart';

class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper;
  static Database _database;

  String dataTable = 'data_table';
  String colId = 'id';
  String colcolor = 'color';
  String colimage = 'image';
  String colname = 'name';
  String coljob = 'job';
  String colphone = 'phone';
  String colmail = 'mail';
  String collink = 'link';
  String collocation = 'location';
  String coltwitter = 'twitter';
  String colfacebook = 'facebook';
  String colinstagram = 'instagram';
  String colgithub = 'github';

  DataBaseHelper._createInstance(); // Constructor to create an instance of DataBaseHelper

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._createInstance(); //Execute only once
    }
    return _dataBaseHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }

    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'user_data.db';
    var databaseOfNumbers =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return databaseOfNumbers;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $dataTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colcolor INTEGER NOT NULL, $colimage TEXT NOT NULL, '
        '$colname TEXT NOT NULL, $coljob TEXT NOT NULL, $colphone TEXT NOT NULL, $colmail TEXT NOT NULL, $collink TEXT NOT NULL, $collocation TEXT NOT NULL,'
        '$coltwitter TEXT, $colfacebook TEXT NOT NULL, $colinstagram TEXT NOT NULL, $colgithub TEXT NOT NULL)');
  }

  Future<List<Map<String, dynamic>>> getDataMapList() async {
    Database db = await this.database;
    var result = await db.query(
        dataTable); // or use var result = await database.rawQuery('SELECT * FROM $dataTable');
    return result;
  }

  Future<int> insert(User user) async {
    Database db = await this.database;

    var result;

    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $dataTable');
    int count = Sqflite.firstIntValue(x);

    if (count == 0) {
      result = await db.insert(dataTable, user.addToMap());
    } else {
      await db.update(dataTable, user.addToMap(),
          where: '$colId = ?', whereArgs: [user.id]);
    }
    return result;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $dataTable WHERE $colId = $id');
    return result;
  }

  Future<int> deleteAll() async {
    var db = await this.database;
    var result = await db.delete(dataTable);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $dataTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<User>> getUserList() async {
    var userMapList = await getDataMapList();
    int count = userMapList.length;
    List<User> userList = List<User>();
    for (int i = 0; i < count; i++) {
      userList.add(User.fromMapObject(userMapList[i]));
    }
    return userList;
  }
}
