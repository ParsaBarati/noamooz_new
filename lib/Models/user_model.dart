import 'package:noamooz/Models/Locations/locations_model.dart';

class UserModel {
  UserModel({
    this.id = 0,
    this.firstName = '',
    this.lastName = '',
    this.fullName = '',
    this.mobile = '',
    this.mobile2 = '',
    this.avatar = '',
    this.email = '',
    this.studyField = '',
    this.studyDegree = '',
    this.birthdate = '',
    this.state,
    this.national = '',
    this.city,
    this.gender = 0,
    this.credit = 0,
  });

  int id;
  String firstName;
  String lastName;
  String fullName;
  String mobile;
  String mobile2;
  String national;
  String avatar;
  String email;
  String studyField;
  String birthdate;
  String studyDegree;
  StateModel? state;
  CityModel? city;
  int gender;
  int credit = 0;

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        firstName: json["firstName"],
        lastName: json["lastName"],
        fullName: json["fullName"],
        state: json['state'] != null ? StateModel.fromMap(json['state']) : null,
        city: json['city'] != null ? CityModel.fromMap(json['city']) : null,
        mobile: json["mobile"],
        mobile2: json["mobile2"] ?? "",
        national: json["national"],
        avatar: json["avatar"],
        credit: int.tryParse(json["credit"].toString()) ?? 0,
        email: json["email"] ?? "",
        birthdate: json["birthdate"] ?? "",
        studyField: json["studyField"] ?? "",
        studyDegree: json["studyDegree"] ?? "",
        gender: int.tryParse(json["gender"].toString()) ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "fullName": fullName,
        "mobile": mobile,
        "national": national,
        "mobile2": mobile2,
        "avatar": avatar,
        "credit": int.tryParse(credit.toString()) ?? 0,
        "email": email ?? "",
        "birthdate": birthdate ?? "",
        "studyField": studyField ?? "",
        "studyDegree": studyDegree ?? "",
        "gender": gender ?? 1,
      };
}
