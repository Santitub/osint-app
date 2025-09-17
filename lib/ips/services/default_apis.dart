import '../models/custom_api.dart';
import 'package:uuid/uuid.dart';

final List<CustomApi> defaultApis = [
  CustomApi(
    id: const Uuid().v4(),
    name: 'ip-api.com',
    urlTemplate: 'http://ip-api.com/json/{ip}',
    headers: {},
  ),
  CustomApi(
    id: const Uuid().v4(),
    name: 'ipinfo.io',
    urlTemplate: 'https://ipinfo.io/{ip}/json',
    headers: {},
  ),
  CustomApi(
    id: const Uuid().v4(),
    name: 'freeipapi.com',
    urlTemplate: 'https://freeipapi.com/api/json/{ip}',
    headers: {},
  ),
];