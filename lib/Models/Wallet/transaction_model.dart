class TransactionModel {
  final int id;
  final String type;
  final int amount;
  final bool isPayed;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.isPayed,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['id'],
      type: data['type'].toString(),
      amount: int.parse(data['amount'].toString()),
      isPayed: data['isPayed'] == true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        data['createdAt'] * 1000,
      ),
    );
  }

  static List<TransactionModel> listFromJson(List list) => list
      .map(
        (e) => TransactionModel.fromJson(e),
      )
      .toList();
}
