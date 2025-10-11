class Category {
  int id;
  int userId;
  String name;
  String type;

  Category({required this.id, required this.userId, required this.name, required this.type});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json['id']),
      userId: int.parse(json['user_id']),
      name: json['name'],
      type: json['type'],
    );
  }
}
