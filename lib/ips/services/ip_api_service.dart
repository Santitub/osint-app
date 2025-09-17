import 'package:dio/dio.dart';
import '../models/ip_info.dart';
import '../models/custom_api.dart';

class IpApiService {
  final Dio _dio = Dio();

  Future<IpInfo> lookup(String ip, CustomApi api) async {
    final url = api.urlTemplate.replaceAll('{ip}', ip);
    final res = await _dio.get(url, options: Options(headers: api.headers));

    /*  Si ip-api.com devuelve status == "fail" usamos la siguiente API de la lista  */
    if (res.data is Map &&
        (res.data as Map).containsKey('status') &&
        res.data['status'] == 'fail') {
      throw Exception('ip-api.com fail: ${res.data['message']}');
    }

    return IpInfo.fromDynamic(res.data);   // << adaptador universal
  }
}