import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/domain_providers.dart';
import '../widgets/api_dropdown.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _types = ['A', 'MX', 'TXT', 'NS'];

  @override
  Widget build(BuildContext context) {
    final selectedType = ref.watch(dnsTypeProvider);
    final selectedApi = ref.watch(selectedDomainApiProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: 'Menú principal',
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: const Text('ANALIZAR DOMINIOS'),
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
            const DomainApiDropdown(),   // ← selector
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Dominio',
                hintText: 'ejemplo.com',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(labelText: 'Tipo de registro DNS'),
              items: _types
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (t) => ref.read(dnsTypeProvider.notifier).state = t!,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: selectedApi == null
                  ? null
                  : () {
                      ref.read(domainQueryProvider.notifier).state =
                          _controller.text.trim();
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}