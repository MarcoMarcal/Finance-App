import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/finance_provider.dart';
import '../models/transaction.dart';

enum FilterType { all, income, expense, future }

class RegistrosScreen extends StatefulWidget {
  const RegistrosScreen({super.key});

  @override
  State<RegistrosScreen> createState() => _RegistrosScreenState();
}

class _RegistrosScreenState extends State<RegistrosScreen> {
  FilterType filter = FilterType.all;

  // ---------- Helpers ----------

  String filterLabel(FilterType type) {
    switch (type) {
      case FilterType.all:
        return 'Todos';
      case FilterType.income:
        return 'Ganhos';
      case FilterType.expense:
        return 'Gastos';
      case FilterType.future:
        return 'Futuros';
    }
  }

  Color filterColor(FilterType type) {
    switch (type) {
      case FilterType.income:
        return Colors.green;
      case FilterType.expense:
        return Colors.red;
      case FilterType.future:
        return Colors.orange;
      case FilterType.all:
      default:
        return Colors.blue;
    }
  }

  List<FinanceTransaction> getFiltered(List<FinanceTransaction> transactions) {
    final now = DateTime.now();
    var filtered = [...transactions];

    switch (filter) {
      case FilterType.income:
        filtered =
            filtered.where((t) => t.type == TransactionType.income).toList();
        break;
      case FilterType.expense:
        filtered = filtered.where((t) =>
            t.type == TransactionType.expense && t.date.isBefore(now)).toList();
        break;
      case FilterType.future:
        filtered = filtered.where((t) =>
            t.type == TransactionType.expense && t.date.isAfter(now)).toList();
        break;
      case FilterType.all:
        break;
    }

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final transactions = getFiltered(finance.transactions);

    return SafeArea(
      child: Column(
        children: [
          // ---------- Header ----------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Registros',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // ---------- Filters ----------
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: FilterType.values.map((f) {
                      final isActive = filter == f;
                      final color = filterColor(f);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filterLabel(f)),
                          selected: isActive,
                          selectedColor: color.withOpacity(0.15),
                          labelStyle: TextStyle(
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.normal,
                            color: isActive ? color : Colors.black87,
                          ),
                          onSelected: (_) {
                            setState(() => filter = f);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // ---------- List ----------
          Expanded(
            child: transactions.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final t = transactions[index];
                      final isIncome =
                          t.type == TransactionType.income;
                      final isFuture =
                          t.type == TransactionType.expense &&
                          t.date.isAfter(DateTime.now());

                      final color = isIncome
                          ? Colors.green
                          : isFuture
                              ? Colors.orange
                              : Colors.red;

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: color.withOpacity(0.2),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.15),
                            child: Icon(
                              isIncome
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: color,
                            ),
                          ),
                          title: Text(
                              (t.description != null && t.description!.trim().isNotEmpty)
                                  ? t.description!
                                  : t.category,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('dd/MM/yyyy').format(t.date),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${isIncome ? '+' : '-'} '
                                '${finance.currency} '
                                '${t.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Excluir transação'),
                                      content: const Text(
                                          'Tem certeza que deseja excluir este registro?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            finance.deleteTransaction(t.id);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Excluir',
                                            style:
                                                TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------- Empty State ----------
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.calendar_month, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Nenhum registro encontrado',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              'Adicione uma transação para começar',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
