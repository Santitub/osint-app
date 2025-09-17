import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/ip_providers.dart';
import '../widgets/api_dropdown.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _ipController = TextEditingController();

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedApiProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: 'Menú principal',
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: const Text('ANALIZAR IPS'),
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
              controller: _ipController, // ← conserva texto
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
                          _ipController.text.trim();
                      context.push('/result');
                      // NO limpiamos el campo
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