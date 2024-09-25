import 'package:noamooz/Models/general_item_model_no_icon.dart';

class TicketModel {
  int id;
  String title;
  GeneralInformationModelNoIcon subject;
  String text;
  int createdAt;
  int status;
  bool hasResponse;

  final List<TicketModel> responses;

  TicketModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.text,
    required this.createdAt,
    required this.status,
    required this.hasResponse,
    required this.responses,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: int.tryParse(json['id'].toString()) ?? 0   ,
      title: json['title'],
      subject: GeneralInformationModelNoIcon.fromJson(json['subject']),
      text: json['text'],
      createdAt: json['createdAt'],
      status: json['status'],
      hasResponse: json['hasResponse'],
      responses: List.from(json['responses']).map((e) => TicketModel.fromJson(e)).toList(),
    );
  }

  static List<TicketModel> listFromJson(List data) {
    return List.from(data).map((e) => TicketModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subject'] = subject.toJson();
    data['text'] = text;
    data['createdAt'] = createdAt;
    data['status'] = status;
    data['hasResponse'] = hasResponse;
    return data;
  }

  String getStatusText() {
    switch (status){
      case 0:
        return "در حال بررسی";
        break;
      case 1:
        return "پاسخ داده شده";
        break;
      case 2:
        return "تمام شده";
        break;
      case -1:
        return "بایگانی";
        break;
    }
    return "نا مشخص";
  }
}
