class InstallmentModel {
  final String id;
  final String userCourseId;
  final String price;
  final String status;
  final List<String> files;

  InstallmentModel({
    required this.id,
    required this.userCourseId,
    required this.price,
    required this.status,
    required this.files,
  });

  factory InstallmentModel.fromJson(Map<String, dynamic> json) => InstallmentModel(
    id: json["id"].toString(),
    userCourseId: json["userCourseId"].toString(),
    price: json["price"].toString(),
    status: json["status"].toString(),
    files: json["files"] != null ? List<String>.from(json["files"].map((x) => x)) : [],
  );

  static List<InstallmentModel> listFromJson(List data) {
    return data.map((e) => InstallmentModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userCourseId": userCourseId,
    "price": price,
    "status": status,
    "files": List<dynamic>.from(files.map((x) => x)),
  };

  String getStatus() => status == "0" ? "پرداخت نشده" : "پرداخت شده";
}
