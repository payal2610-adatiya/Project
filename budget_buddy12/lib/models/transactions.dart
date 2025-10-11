class TransactionModel {
  int id;
  int userId;
  int categoryId;
  double amount;
  String? note;
  String date;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    this.note,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: int.parse(json['id']),
      userId: int.parse(json['user_id']),
      categoryId: int.parse(json['category_id']),
      amount: double.parse(json['amount']),
      note: json['note'],
      date: json['date'],
    );
  }
}
