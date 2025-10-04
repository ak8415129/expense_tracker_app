
import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final String categoryId;
  final DateTime date;
  final bool isRecurring;

  Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.date,
    this.isRecurring = false,
  });

  factory Expense.fromMap(Map<String, dynamic> data, String documentId) {
    return Expense(
      id: documentId,
      userId: data['userId'],
      amount: data['amount'],
      description: data['description'],
      categoryId: data['categoryId'],
      date: (data['date'] as Timestamp).toDate(),
      isRecurring: data['isRecurring'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'description': description,
      'categoryId': categoryId,
      'date': date,
      'isRecurring': isRecurring,
    };
  }
}
