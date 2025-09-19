import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ips/models/custom_api.dart';
import '../providers/api_storage_provider.dart';
import '../providers/domain_providers.dart';

class DomainApiDropdown extends ConsumerWidget {
  const DomainApiDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(domainApiListProvider);
    final selected = ref.watch(selectedDomainApiProvider);

    if (list.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.warning),
          title: Text('Añade al menos una API'),
        ),
      );
    }

    final validValue =
        (selected != null && list.any((a) => a.id == selected.id))
            ? selected
            : null;

    if (selected != validValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ref.read(selectedDomainApiProvider.notifier).state = validValue;
        }
      });
    }

    return DropdownButtonFormField<CustomApi>(
      value: validValue,
      hint: const Text('Selecciona una API'),
      decoration: const InputDecoration(labelText: 'API seleccionada'),
      items: list
          .map((api) => DropdownMenuItem(value: api, child: Text(api.name)))
          .toList(),
      onChanged: (api) =>
          ref.read(selectedDomainApiProvider.notifier).state = api,
    );
  }
}