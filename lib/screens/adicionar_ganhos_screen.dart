import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/finance_provider.dart';
import '../models/transaction.dart';

class AdicionarGanhoScreen extends StatefulWidget {
  const AdicionarGanhoScreen({super.key});

  @override
  State<AdicionarGanhoScreen> createState() => _AdicionarGanhoScreenState();
}

class _AdicionarGanhoScreenState extends State<AdicionarGanhoScreen> {
  final _uuid = const Uuid();

  final _amountController = TextEditingController();
  final _sourceController = TextEditingController();

  DateTime _date = DateTime.now();
  bool _isRecurring = false;

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Ganho'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// Valor
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

            /// Fonte
            TextField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Fonte do ganho',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Data
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data'),
              subtitle:
                  Text('${_date.day}/${_date.month}/${_date.year}'),
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

            /// Recorrente
            SwitchListTile(
              value: _isRecurring,
              onChanged: (v) => setState(() => _isRecurring = v),
              title: const Text('Ganho recorrente'),
              subtitle: const Text('Repete mensalmente'),
            ),
          ],
        ),
      ),

      /// Botão fixo
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text('Salvar Ganho'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            final amount = double.tryParse(_amountController.text);
            if (amount == null) return;

            finance.addTransaction(
              FinanceTransaction(
                id: _uuid.v4(),
                type: TransactionType.income,
                amount: amount,
                category: 'Receita',
                date: _date,
                description: _sourceController.text,
                isRecurring: _isRecurring,
              ),
            );

            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}