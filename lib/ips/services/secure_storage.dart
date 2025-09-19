import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/custom_api.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /* -------------  NEW  ------------- */
  static Future<List<CustomApi>> loadApis({String key = 'custom_apis'}) async {
    final raw = await _storage.read(key: key);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => CustomApi.fromJson(e)).toList();
  }

  static Future<void> saveApis(List<CustomApi> apis, {String key = 'custom_apis'}) async {
    final raw = jsonEncode(apis.map((e) => e.toJson()).toList());
    await _storage.write(key: key, value: raw);
  }
}