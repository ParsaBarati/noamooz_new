import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:noamooz/DataBase/Entity.dart';
import 'package:noamooz/DataBase/Model.dart';
import 'package:sqflite/sqlite_api.dart';

class CoursesDbModel extends BaseModel {
  @override
  Map<String, DbDataTypes> fields() {
    return {
      'course_id': DbDataTypes.Integer,
      'content': DbDataTypes.Text,
    };
  }

  @override
  String primaryKey() {
    return 'id';
  }

  Future<Map<String,dynamic>?> getCourse(int id) async {
    if (kIsWeb){
      String? val = box.read(tablaName);
      if (val is String) {
        List result = jsonDecode(val);
        return result.isNotEmpty ? result.first : null;
      }
      return null;
    } else {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        tablaName,
        limit: 1,
        where: "course_id = $id",
      );
      return result.isNotEmpty ? result.first : null;
    }
  }
}
