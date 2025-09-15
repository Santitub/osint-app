class IpInfo {
  final String ip;
  final String city;
  final String country;
  final String isp;
  final String org;
  final double lat;
  final double lon;

  const IpInfo({
    required this.ip,
    required this.city,
    required this.country,
    required this.isp,
    required this.org,
    required this.lat,
    required this.lon,
  });

  /* ----------  NUEVO ADAPTADOR  ---------- */
  factory IpInfo.fromDynamic(Map<String, dynamic> json) {
    /* --------- freeipapi.com --------- */
    if (json.containsKey('ipAddress')) {
      return IpInfo(
        ip: json['ipAddress'] ?? '',
        city: json['cityName'] ?? '',
        country: json['countryName'] ?? '',
        isp: json['asnOrganization'] ?? '',
        org: 'AS${json['asn'] ?? ''} ${json['asnOrganization'] ?? ''}',
        lat: (json['latitude'] as num?)?.toDouble() ?? 0,
        lon: (json['longitude'] as num?)?.toDouble() ?? 0,
      );
    }

    /* --------- ipinfo.io --------- */
    if (json.containsKey('loc')) {
      final loc = (json['loc'] as String).split(',');
      return IpInfo(
        ip: json['ip'] ?? '',
        city: json['city'] ?? '',
        country: json['country'] ?? '',
        isp: json['org'] ?? '',
        org: json['org'] ?? '',
        lat: double.tryParse(loc[0]) ?? 0,
        lon: double.tryParse(loc[1]) ?? 0,
      );
    }

    /* --------- ip-api.com (antiguo) --------- */
    return IpInfo(
      ip: json['query'] ?? json['ip'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      isp: json['isp'] ?? '',
      org: json['org'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0,
    );
  }
}