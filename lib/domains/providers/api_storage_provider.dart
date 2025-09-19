import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../ips/models/custom_api.dart'; // clase única
import '../../ips/services/secure_storage.dart' as storage;

final domainApiListProvider =
    StateNotifierProvider<DomainApiListNotifier, List<CustomApi>>(
        (ref) => DomainApiListNotifier());

class DomainApiListNotifier extends StateNotifier<List<CustomApi>> {
  DomainApiListNotifier() : super([]) {
    _load();
  }

  /* ---------- CRUD ---------- */
  Future<void> _load() async {
    final stored = await storage.SecureStorage.loadApis(key: 'custom_domain_apis');
    if (stored.isEmpty) {
      state = _defaults;
      await storage.SecureStorage.saveApis(state, key: 'custom_domain_apis');
    } else {
      state = stored;
    }
  }

  Future<void> add(CustomApi api) async {
    state = [...state, api];
    await storage.SecureStorage.saveApis(state, key: 'custom_domain_apis');
  }

  Future<void> remove(String id) async {
    state = state.where((a) => a.id != id).toList();
    await storage.SecureStorage.saveApis(state, key: 'custom_domain_apis');
  }

  Future<void> update(CustomApi updated) async {
    state = [
      for (final a in state) if (a.id == updated.id) updated else a,
    ];
    await storage.SecureStorage.saveApis(state, key: 'custom_domain_apis');
  }
}

/* APIs precargadas (puedes editarlas) */
final List<CustomApi> _defaults = [
  CustomApi(
    id: const Uuid().v4(),
    name: 'Google DoH (A)',
    urlTemplate: 'https://dns.google/resolve?name={domain}&type=A',
    headers: {},
  ),
  CustomApi(
    id: const Uuid().v4(),
    name: 'Google DoH (MX)',
    urlTemplate: 'https://dns.google/resolve?name={domain}&type=MX',
    headers: {},
  ),
  CustomApi(
    id: const Uuid().v4(),
    name: 'Whois.vu',
    urlTemplate: 'https://api.whois.vu/?q={domain}',
    headers: {},
  ),
];