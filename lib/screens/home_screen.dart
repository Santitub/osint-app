import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/ip_providers.dart';
import '../widgets/api_dropdown.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ipController = TextEditingController();
    final selected = ref.watch(selectedApiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IP OSINT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => context.push('/apis'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const ApiDropdown(),
            const SizedBox(height: 16),
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: 'Dirección IP',
                hintText: 'Ej: 8.8.8.8',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: selected == null
                  ? null
                  : () {
                      ref.read(ipQueryProvider.notifier).state =
                          ipController.text.trim();
                      context.push('/result');
                    },
              icon: const Icon(Icons.search),
              label: const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }
}