import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/custom_api.dart';
import '../providers/api_storage_provider.dart';
import 'package:uuid/uuid.dart';

class ManageApisScreen extends ConsumerWidget {
  const ManageApisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(apiListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis APIs')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context, ref),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, i) {
          final api = list[i];
          return ListTile(
            title: Text(api.name),
            subtitle: Text(api.urlTemplate),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  ref.read(apiListProvider.notifier).remove(api.id),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final headersCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Añadir API'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: urlCtrl,
              decoration: const InputDecoration(
                labelText: 'URL (usa {ip} como placeholder)',
                hintText: 'https://ip-api.com/json/{ip}',
              ),
            ),
            TextField(
              controller: headersCtrl,
              decoration: const InputDecoration(
                labelText: 'Headers (opcional, JSON)',
                hintText: '{"Authorization": "Bearer xxx"}',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final headers = headersCtrl.text.trim().isEmpty
                  ? <String, String>{}
                  : (Map<String, dynamic>.from(
                          jsonDecode(headersCtrl.text.trim())))
                      .map((k, v) => MapEntry(k, v.toString()));
              final api = CustomApi(
                id: const Uuid().v4(),
                name: nameCtrl.text.trim(),
                urlTemplate: urlCtrl.text.trim(),
                headers: headers,
              );
              ref.read(apiListProvider.notifier).add(api);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}