
class Budget {
  final String id;
  final String userId;
  final double amount;
  final String period; // e.g., 'monthly', 'weekly'

  Budget({
    required this.id,
    required this.userId,
    required this.amount,
    required this.period,
  });

  factory Budget.fromMap(Map<String, dynamic> data, String documentId) {
    return Budget(
      id: documentId,
      userId: data['userId'],
      amount: data['amount'],
      period: data['period'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'period': period,
    };
  }
}
