import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/custom_api.dart';
import '../services/secure_storage.dart';
import '../services/default_apis.dart';

final apiListProvider = StateNotifierProvider<ApiListNotifier, List<CustomApi>>(
    (ref) => ApiListNotifier());

class ApiListNotifier extends StateNotifier<List<CustomApi>> {
  ApiListNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final stored = await SecureStorage.loadApis();
    if (stored.isEmpty) {
      // primera ejecución -> APIs por defecto
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
    state = state.where((a) => a.id != id).toList();
    await SecureStorage.saveApis(state);
  }
}