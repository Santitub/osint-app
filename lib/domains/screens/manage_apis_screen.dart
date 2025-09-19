import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../ips/models/custom_api.dart';
import '../providers/api_storage_provider.dart';

class ManageDomainApisScreen extends ConsumerWidget {
  const ManageDomainApisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(domainApiListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis APIs de Dominios')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showEditDialog(context, ref),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, i) {
          final api = list[i];
          return ListTile(
            title: Text(api.name),
            subtitle: Text(api.urlTemplate),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditDialog(context, ref, api: api),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      ref.read(domainApiListProvider.notifier).remove(api.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /* ---------- diálogo seguro (controllers fuera del builder) ---------- */
  void _showEditDialog(BuildContext context, WidgetRef ref, {CustomApi? api}) {
    final isEdit = api != null;
    final nameCtrl = TextEditingController(text: api?.name ?? '');
    final urlCtrl = TextEditingController(text: api?.urlTemplate ?? '');
    final headersCtrl =
        TextEditingController(text: jsonEncode(api?.headers ?? {}));

    showDialog<bool>(
      context: context,
      builder: (_) => _EditApiDialog(
        isEdit: isEdit,
        nameCtrl: nameCtrl,
        urlCtrl: urlCtrl,
        headersCtrl: headersCtrl,
      ),
    ).then((saved) {
      // limpiar controllers SIEMPRE
      nameCtrl.dispose();
      urlCtrl.dispose();
      headersCtrl.dispose();

      if (saved != true) return; // Cancelado

      final newApi = CustomApi(
        id: isEdit ? api.id : const Uuid().v4(),
        name: nameCtrl.text.trim(),
        urlTemplate: urlCtrl.text.trim(),
        headers: _parseHeaders(headersCtrl.text.trim()),
      );

      if (isEdit) {
        ref.read(domainApiListProvider.notifier).update(newApi);
      } else {
        ref.read(domainApiListProvider.notifier).add(newApi);
      }
    });
  }

  Map<String, String> _parseHeaders(String raw) {
    if (raw.isEmpty) return {};
    try {
      return (jsonDecode(raw) as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {}; // inválido → vacío
    }
  }
}

/* ---------- widget interno sin controllers ---------- */
class _EditApiDialog extends StatelessWidget {
  const _EditApiDialog({
    required this.isEdit,
    required this.nameCtrl,
    required this.urlCtrl,
    required this.headersCtrl,
  });

  final bool isEdit;
  final TextEditingController nameCtrl;
  final TextEditingController urlCtrl;
  final TextEditingController headersCtrl;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Editar API' : 'Añadir API'),
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
              labelText: 'URL (usa {domain} como placeholder)',
              hintText: 'https://dns.google/resolve?name={domain}&type=A',
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
          onPressed: () => Navigator.pop(context, false), // cancelar
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final name = nameCtrl.text.trim();
            final url = urlCtrl.text.trim();
            if (name.isEmpty || url.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Nombre y URL no pueden estar vacíos')),
              );
              return;
            }
            Navigator.pop(context, true); // guardar
          },
          child: Text(isEdit ? 'Guardar cambios' : 'Añadir'),
        ),
      ],
    );
  }
}