// To parse this JSON data, do
//
//     final faqType = faqTypeFromJson(jsonString);

import 'dart:convert';

FaqType faqTypeFromJson(String str) => FaqType.fromJson(json.decode(str));

String faqTypeToJson(FaqType data) => json.encode(data.toJson());

class FaqType {
  final int id;
  final String name;
  final List<Faq> faqs;

  FaqType({
    required this.id,
    required this.name,
    required this.faqs,
  });

  factory FaqType.fromJson(Map<String, dynamic> json) => FaqType(
    id: int.tryParse(json["id"].toString()) ?? 0,
    name: json["name"],
    faqs: List<Faq>.from(json["faqs"].map((x) => Faq.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "faqs": List<dynamic>.from(faqs.map((x) => x.toJson())),
  };

  static List<FaqType> listFromJson(data) {
    return List.from(data).map((e) => FaqType.fromJson(e)).toList();
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
  };
}
