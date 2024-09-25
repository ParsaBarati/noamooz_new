
import 'package:noamooz/DataBase/Model.dart';

class UserDbModel extends BaseModel {
  @override
  Map<String, DbDataTypes> fields() {
    return {
      'content': DbDataTypes.Text,
    };
  }

  @override
  String primaryKey() {
    return 'id';
  }
}