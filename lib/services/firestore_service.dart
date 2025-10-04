
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/budget_model.dart';
import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // User operations
  Future<void> addUser(UserModel user) {
    return _db.collection('users').doc(user.uid).set(user.toMap());
  }

  // Expense operations
  Future<void> addExpense(Expense expense) {
    return _db.collection('expenses').add(expense.toMap());
  }

  Future<void> updateExpense(Expense expense) {
    return _db.collection('expenses').doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String expenseId) {
    return _db.collection('expenses').doc(expenseId).delete();
  }

  Stream<List<Expense>> getExpenses({DateTime? startDate, DateTime? endDate, String? categoryId, String? searchTerm}) {
    Query query = _db.collection('expenses').where('userId', isEqualTo: getCurrentUserId()).orderBy('date', descending: true);

    if (startDate != null) {
      query = query.where('date', isGreaterThanOrEqualTo: startDate);
    }
    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: endDate);
    }
    if (categoryId != null) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }
    if (searchTerm != null && searchTerm.isNotEmpty) {
      query = query.where('description', isGreaterThanOrEqualTo: searchTerm).where('description', isLessThanOrEqualTo: searchTerm + '\uf8ff');
    }

    return query.snapshots().map((snapshot) => snapshot.docs.map((doc) => Expense.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  // Category operations
  Future<void> addCategory(Category category) {
    return _db.collection('categories').add(category.toMap());
  }

  Future<void> updateCategory(Category category) {
    return _db.collection('categories').doc(category.id).update(category.toMap());
  }

  Future<void> deleteCategory(String categoryId) {
    return _db.collection('categories').doc(categoryId).delete();
  }

  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) => snapshot.docs.map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  // Budget operations
  Future<void> setBudget(Budget budget) {
    return _db.collection('budgets').doc(getCurrentUserId()).set(budget.toMap());
  }

  Stream<Budget?> getBudget() {
    return _db.collection('budgets').doc(getCurrentUserId()).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Budget.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null;
    });
  }
}
