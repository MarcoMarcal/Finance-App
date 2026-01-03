import 'package:flutter/material.dart';
import 'adicionar_gastos_screen.dart';
import 'adicionar_ganhos_screen.dart';

class AdicionarScreen extends StatelessWidget {
  const AdicionarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.remove),
              label: const Text('Adicionar Gasto'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdicionarGastoScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Ganho'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdicionarGanhoScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
