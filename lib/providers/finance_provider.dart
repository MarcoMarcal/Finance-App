import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

class FinanceProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  List<FinanceTransaction> transactions = [];
  List<String> categories = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Saúde',
    'Educação',
    'Lazer',
  ];

  String currency = 'R\$';
  int startMonth = 1;

  void addTransaction(FinanceTransaction tx) {
    transactions.add(tx);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void addCategory(String category) {
    categories.add(category);
    notifyListeners();
  }

  void setCurrency(String value) {
    currency = value;
    notifyListeners();
  }

  void setStartMonth(int month) {
    startMonth = month;
    notifyListeners();
  }

  double get totalIncome {
  return transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);
}

double get totalExpenses {
  return transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);
}

}