import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_provider.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  static const List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  static const List<String> currencies = [
    'R\$',
    'US\$',
    '€',
    '£',
    '¥',
  ];

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsTile(
            icon: Icons.folder_open,
            color: Colors.blue,
            title: 'Gerenciar Categorias',
            subtitle: '${finance.categories.length} categorias',
            onTap: () => _showCategoryModal(context),
          ),
          const SizedBox(height: 8),

          _SettingsTile(
            icon: Icons.attach_money,
            color: Colors.green,
            title: 'Moeda',
            subtitle: finance.currency,
            onTap: () => _showCurrencyModal(context),
          ),
          const SizedBox(height: 8),

          _SettingsTile(
            icon: Icons.calendar_month,
            color: Colors.purple,
            title: 'Mês Inicial',
            subtitle: months[finance.startMonth - 1],
            onTap: () => _showMonthModal(context),
          ),
          const SizedBox(height: 8),

          _SettingsTile(
            icon: Icons.download,
            color: Colors.orange,
            title: 'Exportar Dados',
            subtitle: 'Baixar suas transações',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Funcionalidade de exportação em desenvolvimento'),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          _SettingsTile(
            icon: Icons.storage,
            color: Colors.indigo,
            title: 'Backup',
            subtitle: 'Salvar e restaurar dados',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Funcionalidade de backup em desenvolvimento'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= MODAIS =================

  void _showCategoryModal(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context, listen: false);
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ModalHeader(title: 'Categorias'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Nova categoria',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        finance.addCategory(controller.text.trim());
                        controller.clear();
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...finance.categories.map(
                (c) => ListTile(
                  title: Text(c),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencyModal(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ModalHeader(title: 'Selecionar Moeda'),
              ...currencies.map(
                (c) => ListTile(
                  title: Text(c),
                  trailing:
                      finance.currency == c ? const Icon(Icons.check) : null,
                  onTap: () {
                    finance.setCurrency(c);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMonthModal(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ModalHeader(title: 'Mês Inicial'),
              ...months.asMap().entries.map(
                (entry) {
                  final index = entry.key;
                  final month = entry.value;
                  return ListTile(
                    title: Text(month),
                    trailing: finance.startMonth == index + 1
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      finance.setStartMonth(index + 1);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================= COMPONENTES =================

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalHeader extends StatelessWidget {
  final String title;

  const _ModalHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
