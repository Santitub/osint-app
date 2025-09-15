import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ip_info.dart';
import '../models/custom_api.dart';
import '../services/ip_api_service.dart';

final ipApiServiceProvider = Provider((_) => IpApiService());

final ipQueryProvider = StateProvider<String>((ref) => '');

final selectedApiProvider = StateProvider<CustomApi?>((ref) => null);

final ipResultProvider = FutureProvider<IpInfo?>((ref) async {
  final ip = ref.watch(ipQueryProvider);
  final api = ref.watch(selectedApiProvider);
  if (ip.isEmpty || api == null) return null;
  return ref.read(ipApiServiceProvider).lookup(ip, api);
});