import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/custom_api.dart';
import '../providers/api_storage_provider.dart';
import '../providers/ip_providers.dart';

class ApiDropdown extends ConsumerWidget {
  const ApiDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(apiListProvider);
    final selected = ref.watch(selectedApiProvider);

    /* 1. Lista vacía → aviso */
    if (list.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.warning),
          title: Text('Añade al menos una API'),
        ),
      );
    }

    /* 2. Calculamos valor VÁLIDO sin tocar el provider */
    final validValue =
        (selected != null && list.any((a) => a.id == selected.id))
            ? selected
            : null; // ← null mientras no elija

    /* 3. Si el provider está desfasado lo corregimos DESPUÉS del frame */
    if (selected != validValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ref.read(selectedApiProvider.notifier).state = validValue;
        }
      });
    }

    return DropdownButtonFormField<CustomApi>(
      value: validValue, // ← SIEMPRE está en [items] o es null
      hint: const Text('Selecciona una API'),
      decoration: const InputDecoration(labelText: 'API seleccionada'),
      items: list
          .map((api) => DropdownMenuItem(value: api, child: Text(api.name)))
          .toList(),
      onChanged: (api) =>
          ref.read(selectedApiProvider.notifier).state = api,
    );
  }
}