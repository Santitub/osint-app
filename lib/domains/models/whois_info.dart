class WhoisInfo {
  final String domain;
  final String registrar;
  final DateTime? creationDate;
  final DateTime? expirationDate;
  final List<String> nameServers;
  final String raw;

  const WhoisInfo({
    required this.domain,
    required this.registrar,
    this.creationDate,
    this.expirationDate,
    required this.nameServers,
    required this.raw,
  });

  /* adaptador rápido para api.whois.vu */
  factory WhoisInfo.fromVuJson(Map<String, dynamic> json) {
    return WhoisInfo(
      domain: json['domain']?.toString() ?? '',
      registrar: json['registrar']?.toString() ?? '',
      creationDate: json['creation_date'] != null
          ? DateTime.tryParse(json['creation_date'].toString())
          : null,
      expirationDate: json['expiration_date'] != null
          ? DateTime.tryParse(json['expiration_date'].toString())
          : null,
      nameServers: (json['name_servers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      raw: json.toString(),
    );
  }
}