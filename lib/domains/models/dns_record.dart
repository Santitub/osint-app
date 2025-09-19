class DnsRecord {
  final String type;   // A, MX, TXT, NS …
  final String value;  // 93.184.216.34  o  "v=spf1 …"
  final int? priority; // solo MX
  final int ttl;

  const DnsRecord({
    required this.type,
    required this.value,
    this.priority,
    required this.ttl,
  });

  /* factory desde Google DoH response */
  factory DnsRecord.fromGoogleJson(Map<String, dynamic> json) {
    return DnsRecord(
      type: json['type']?.toString() ?? '',
      value: (json['data'] ?? '').toString(),
      priority: json['priority'] as int?,
      ttl: json['TTL'] as int? ?? 0,
    );
  }
}