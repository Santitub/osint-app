import 'package:dio/dio.dart';
import 'dart:convert';
import '../models/dns_record.dart';
import '../models/whois_info.dart';

class DomainApiService {
  final Dio _dio = Dio();

  /* ---------- Google DNS-over-HTTPS ---------- */
  Future<List<DnsRecord>> resolve(String domain, String type) async {
    final url = 'https://dns.google/resolve?name=$domain&type=$type';
    final res = await _dio.get(url);
    if (res.data['Answer'] == null) return [];
    final List list = res.data['Answer'];
    return list.map((e) => DnsRecord.fromGoogleJson(e)).toList();
  }

  /* ---------- Whois gratuita (con protección de tipos) ---------- */
  Future<WhoisInfo> whois(String domain) async {
    final url = 'https://api.whois.vu/?q=$domain';
    final res = await _dio.get(url);

    // 1) Body ya es Map → parsear normal
    if (res.data is Map<String, dynamic>) {
      return WhoisInfo.fromVuJson(res.data);
    }

    // 2) Body es String → intentar decodear
    if (res.data is String) {
      try {
        final map = jsonDecode(res.data) as Map<String, dynamic>;
        return WhoisInfo.fromVuJson(map);
      } catch (_) {
        // No es JSON válido → devolver objeto vacío
        return WhoisInfo(
          domain: domain,
          registrar: '',
          creationDate: null,
          expirationDate: null,
          nameServers: [],
          raw: res.data,
        );
      }
    }

    // 3) Cualquier otro caso
    return WhoisInfo(
      domain: domain,
      registrar: '',
      creationDate: null,
      expirationDate: null,
      nameServers: [],
      raw: res.data.toString(),
    );
  }
}