import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:osint_app/models/custom_api.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = 'custom_apis';

  static Future<List<CustomApi>> loadApis() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => CustomApi.fromJson(e)).toList();
  }

  static Future<void> saveApis(List<CustomApi> apis) async {
    final raw = jsonEncode(apis.map((e) => e.toJson()).toList());
    await _storage.write(key: _key, value: raw);
  }
}