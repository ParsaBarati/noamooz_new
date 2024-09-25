import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:noamooz/DataBase/Entity.dart';
import 'package:sqflite/sqflite.dart';

enum DbDataTypes {
  Integer,
  Text,
  Real,
}

typedef FromJsonFunction = BaseEntity Function(Map<String, dynamic> map);

abstract class BaseModel {
  static Database? _database;
  final box = GetStorage();
  late String tablaName;

  void setName(){
    String name = toString().replaceAll("Instance of '", '');
    name = name.replaceAll("'", '').trim();
    tablaName = name;
  }
  Future<Database> get database async {
      _database ??= await initializedDataBase();

    setName();
    // try {
    //   await this.count();
    // } catch (e) {
    //   await this._createDb(_database, 1);
    // }
    return _database!;
  }

  String primaryKey();

  Map<String, DbDataTypes> fields();

  Future<Database> initializedDataBase() async {
    var databasesPath = await getDatabasesPath();
    String name = toString().replaceAll("Instance of '", '');
    name = name.replaceAll("'", '').trim();
    tablaName = name;
    print('tablaName');
    print(tablaName);

    String path = '$databasesPath/$name';
    print('path');
    print(path);
    var db = await openDatabase(path, version: 1, onCreate: _createDb);
    return db;
  }

  Future<void> _createDb(Database db, int newVersion) async {
    String name = toString().replaceAll("Instance of '", '');
    name = name.replaceAll("'", '').trim();
    String query = "CREATE TABLE $tablaName";
    List fields = ['${primaryKey()} INTEGER PRIMARY KEY AUTOINCREMENT'];
    this.fields().forEach((key, value) {
      fields.add(
          "$key ${value.toString().replaceAll("DbDataTypes.", "").toUpperCase()}");
    });
    query = '$query (${fields.join(', ')} )';
    try {
      await db.execute(
        query,
      );
    } catch (e){
      print(e.toString());
    }
  }

  Future<void> createDb() async {
    Database database = await this.database;
    try {
      _createDb(database, 1);
    } catch (e) {
      print(e);
    }
  }

  Future<int> insert(Map<String, dynamic> map) async {
    if (kIsWeb) {
      setName();
      String? val = box.read(tablaName);
      int id = DateTime.now().millisecondsSinceEpoch;
      map['dbID'] = id.toString();
      if (val is String) {
        List list = jsonDecode(val);
        list.add(map);
        box.write(tablaName, jsonEncode(list));
        return DateTime.now().millisecondsSinceEpoch;
      } else {
        box.write(tablaName, jsonEncode([map]));
        return DateTime.now().millisecondsSinceEpoch;
      }
    } else {
      Database db = await database;
      Map<String, dynamic> dataToAdd = {};
      map.forEach((key, value) {
        if (fields().containsKey(key)) {
          if (value is Map ||
              value is Iterable ||
              value.runtimeType.toString().contains('_InternalLinkedHashMap') ||
              value.runtimeType.toString().contains('HashMap')) {
            dataToAdd[key] = jsonEncode(value);
          } else {
            dataToAdd[key] = value;
          }
        }
      });
      return db.insert(tablaName, dataToAdd);
    }
  }

  Future<int> update(int id, Map<String, dynamic> map) async {
    if (kIsWeb) {
      setName();
      String? val = box.read(tablaName);
      if (val is String) {
        List list = jsonDecode(val);
        if (list.any((element) => element['dbID'] == id.toString())) {
          int index = list.indexWhere((element) => element['dbID'] == id.toString());
          map['dbID'] = id.toString();
          list[index] = map;
          box.write(tablaName, jsonEncode(list));
          return id;
        }
      }
      return 0;
    } else {
      Database db = await database;
      return db.update(tablaName, map, where: "${primaryKey()} = $id");
    }
  }

  Future<List<int>> insertAll(List list) async {
    List<int> ids = [];
    // await createDb();
    list.forEach((element) async {
      ids.add(await insert(element));
    });
    return ids;
  }

  Future<void> truncate() async {
    if (kIsWeb) {
      setName();
      String? val = box.read(tablaName);
      if (val is String) {
        box.write(tablaName, jsonEncode([]));
      }
    } else {
      Database db = await database;
      try {
        await db.rawDelete("delete from $tablaName");
      } catch (e) {
        await _createDb(db, 1);
        truncate();
      }
    }
  }

  Future<void> create() async {
    if (kIsWeb) {
      setName();
      String? val = box.read(tablaName);
      if (val is String) {
        box.write(tablaName, jsonEncode([]));
      }
    } else {
      Database db = await database;
      try {
        await db.rawQuery("SELECT * FROM $tablaName");
      } catch (e) {
        await _createDb(db, 1);
        create();
      }
    }
  }
  Future<List<Map>?> selectAll() async {
    if (kIsWeb) {
      setName();
      String? val = box.read(tablaName);
      if (val is String) {
        box.write(tablaName, jsonEncode([]));
      }
    } else {
      Database db = await database;
      try {
        return db.rawQuery("SELECT * FROM $tablaName");
      } catch (e) {
        await _createDb(db, 1);
        return selectAll();
      }
    }
    return null;
  }

  Future<List> getAll([FromJsonFunction? fromJson, int? limit]) async {
    if (kIsWeb){
      setName();
      String? val = box.read(tablaName);
      if (val is String) {
        List result = jsonDecode(val);
        if (fromJson is FromJsonFunction) {
          return result.map((e) => fromJson(e)).toList();
        }
      }
      return [];
    } else {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        tablaName,
        limit: limit,
      );
      if (fromJson is FromJsonFunction) {
        return result.map((e) => fromJson(e)).toList();
      }
      return result.toList();
    }
  }

  Future<BaseEntity?> get(FromJsonFunction fromJson, int id) async {
    if (kIsWeb){
      String? val = box.read(tablaName);
      if (val is String) {
        List result = jsonDecode(val);
        return result.isNotEmpty ? fromJson(result.first) : null;
      }
      return null;
    } else {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        tablaName,
        limit: 1,
        where: "${primaryKey()} = $id",
      );
      return result.isNotEmpty ? fromJson(result.first) : null;
    }
  }


  Future<int> delete(int id) async {
    if (kIsWeb) {
      String? val = box.read(tablaName);
      if (val is String) {
        List list = jsonDecode(val);
        if (list.any((element) => element['dbID'] == id)) {
          list.removeWhere((element) => element['dbID'] == id);
          box.write(tablaName, jsonEncode(list));
          return id;
        }
      }
      return 0;
    } else {
      Database db = await database;

      return await db.rawDelete(
        'DELETE FROM $tablaName WHERE ${primaryKey()} = $id',
      );
    }
  }

  Future<bool> exists(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tablaName,
      limit: 1,
      columns: [
        primaryKey(),
      ],
      where: "${primaryKey()} = $id",
    );
    return result.isNotEmpty;
  }

  Future<int?> count() async {
    Database db = await database;
    List<Map<String, dynamic>> x = await db.rawQuery(
      'SELECT COUNT (*) from $tablaName',
    );
    return Sqflite.firstIntValue(x);
  }
}
