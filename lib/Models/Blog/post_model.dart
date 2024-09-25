
class PostModel {
  PostModel({
    required this.id,
    required this.date,
    required this.title,
    required this.cover,
    required this.tags,
    required this.price,
  });

  final int id;
  final DateTime date;
  final String title;
  final int price;
  final String cover;
  final List<Tag> tags;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: int.tryParse(json["id"].toString()) ?? 0,
    date: DateTime.fromMillisecondsSinceEpoch(json["date"] * 1000),
    title: json["title"],
    price: int.tryParse(json["price"].toString()) ?? 0,
    cover: json["cover"],
    tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "cover": cover,
    "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
  };

  static List<PostModel> listFromJson(List data) {
    return data.map((e) => PostModel.fromJson(e)).toList();
  }
}

class Tag {
  Tag({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: int.tryParse(json["id"].toString()) ?? 0,
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
