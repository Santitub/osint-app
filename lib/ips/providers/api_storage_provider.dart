import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/custom_api.dart';
import '../services/secure_storage.dart';
import '../services/default_apis.dart';
import '../providers/ip_providers.dart';

final apiListProvider = StateNotifierProvider<ApiListNotifier, List<CustomApi>>(
    (ref) => ApiListNotifier(ref));

class ApiListNotifier extends StateNotifier<List<CustomApi>> {
  ApiListNotifier(this._ref) : super([]) {
    _load();
  }

  final Ref _ref;

  Future<void> _load() async {
    final stored = await SecureStorage.loadApis();
    if (stored.isEmpty) {
      state = defaultApis;
      await SecureStorage.saveApis(state);
    } else {
      state = stored;
    }
  }

  Future<void> add(CustomApi api) async {
    state = [...state, api];
    await SecureStorage.saveApis(state);
  }

  Future<void> remove(String id) async {
    final toRemoveIndex = state.indexWhere((a) => a.id == id);
    final currentSel = _ref.read(selectedApiProvider);

    // 1. Calculamos cuál será la próxima selección ANTES de borrar
    CustomApi? next;
    if (currentSel?.id == id) {
      if (state.length == 1) {
        next = null; // no queda ninguna
      } else {
        // siguiente circular (si era la última, cogemos la anterior)
        next = toRemoveIndex == state.length - 1
            ? state[toRemoveIndex - 1]
            : state[toRemoveIndex + 1];
      }
    }

    // 2. Borramos
    state = state.where((a) => a.id != id).toList();
    await SecureStorage.saveApis(state);

    // 3. Aplicamos la selección que ya teníamos calculada
    if (currentSel?.id == id) {
      _ref.read(selectedApiProvider.notifier).state = next;
    }
  }

  Future<void> update(CustomApi updated) async {
    state = [
      for (final a in state) if (a.id == updated.id) updated else a,
    ];
    await SecureStorage.saveApis(state);
  }
}