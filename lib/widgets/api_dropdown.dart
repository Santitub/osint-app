import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:osint_app/models/custom_api.dart';
import '../providers/api_storage_provider.dart';
import '../providers/ip_providers.dart';

class ApiDropdown extends ConsumerWidget {
  const ApiDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(apiListProvider);
    final selected = ref.watch(selectedApiProvider);

    if (list.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.warning),
          title: Text('Añade al menos una API'),
        ),
      );
    }

    return DropdownButtonFormField<CustomApi>(
      value: selected ?? list.first,
      decoration: const InputDecoration(labelText: 'API seleccionada'),
      items: list
          .map((api) => DropdownMenuItem(value: api, child: Text(api.name)))
          .toList(),
      onChanged: (api) =>
          ref.read(selectedApiProvider.notifier).state = api,
    );
  }
}