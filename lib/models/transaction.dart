enum TransactionType { income, expense }

class FinanceTransaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final bool isRecurring;
  final int? installments;
  final int? currentInstallment;

  FinanceTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.isRecurring = false,
    this.installments,
    this.currentInstallment,
  });
}
