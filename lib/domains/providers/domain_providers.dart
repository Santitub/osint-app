import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dns_record.dart';
import '../models/whois_info.dart';
import '../services/domain_api_service.dart';
import '../../ips/models/custom_api.dart';

final domainApiServiceProvider = Provider((_) => DomainApiService());

final domainQueryProvider = StateProvider<String>((ref) => '');
final dnsTypeProvider = StateProvider<String>((ref) => 'A');
final selectedDomainApiProvider = StateProvider<CustomApi?>((ref) => null);

/* registros DNS */
final dnsResultProvider = FutureProvider<List<DnsRecord>>((ref) async {
  final domain = ref.watch(domainQueryProvider);
  final type = ref.watch(dnsTypeProvider);
  final api = ref.watch(selectedDomainApiProvider);
  if (domain.isEmpty || api == null) return [];
  return ref.read(domainApiServiceProvider).resolve(domain, type);
});

/* whois */
final whoisResultProvider = FutureProvider<WhoisInfo?>((ref) async {
  final domain = ref.watch(domainQueryProvider);
  if (domain.isEmpty) return null;
  return ref.read(domainApiServiceProvider).whois(domain);
});