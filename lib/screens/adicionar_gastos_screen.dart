import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/finance_provider.dart';
import '../models/transaction.dart';

enum ExpenseType { single, recurring, installment }

class AdicionarGastoScreen extends StatefulWidget {
  const AdicionarGastoScreen({super.key});

  @override
  State<AdicionarGastoScreen> createState() => _AdicionarGastoScreenState();
}

class _AdicionarGastoScreenState extends State<AdicionarGastoScreen> {
  final _uuid = const Uuid();

  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _installmentsController = TextEditingController();

  DateTime _date = DateTime.now();
  ExpenseType _expenseType = ExpenseType.single;
  String? _category;
  
  @override
  void initState() {
    super.initState();
    final finance = context.read<FinanceProvider>();
    _category = finance.categories.first;
  }

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Gasto'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor',
                prefixText: '${finance.currency} ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _category,
              items: finance.categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _category = v),
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Data
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data'),
              subtitle: Text(
                '${_date.day}/${_date.month}/${_date.year}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _date = picked);
                }
              },
            ),

            const SizedBox(height: 16),

            /// Tipo de gasto
            const Text('Tipo de Gasto'),
            const SizedBox(height: 8),
            ToggleButtons(
              isSelected: [
                _expenseType == ExpenseType.single,
                _expenseType == ExpenseType.recurring,
                _expenseType == ExpenseType.installment,
              ],
              onPressed: (index) {
                setState(() {
                  _expenseType = ExpenseType.values[index];
                });
              },
              borderRadius: BorderRadius.circular(12),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Único'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Recorrente'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Parcelado'),
                ),
              ],
            ),

            /// Parcelas
            if (_expenseType == ExpenseType.installment) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _installmentsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de parcelas',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 16),

            /// Observação
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observação',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),

      /// Botão fixo
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text('Salvar Gasto'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            final amount = double.tryParse(_amountController.text);
            if (amount == null) return;

            if (_expenseType == ExpenseType.installment) {
              final count =
                  int.tryParse(_installmentsController.text) ?? 1;
              final installmentValue = amount / count;

              for (int i = 0; i < count; i++) {
                final date = DateTime(
                  _date.year,
                  _date.month + i,
                  _date.day,
                );

                finance.addTransaction(
                  FinanceTransaction(
                    id: _uuid.v4(),
                    type: TransactionType.expense,
                    amount: installmentValue,
                    category: _category!,
                    date: date,
                    description:
                        '${_descriptionController.text} (${i + 1}/$count)',
                    installments: count,
                    currentInstallment: i + 1,
                  ),
                );
              }
            } else {
              finance.addTransaction(
                FinanceTransaction(
                  id: _uuid.v4(),
                  type: TransactionType.expense,
                  amount: amount,
                  category: _category!,
                  date: _date,
                  description: _descriptionController.text,
                  isRecurring:
                      _expenseType == ExpenseType.recurring,
                ),
              );
            }

            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}