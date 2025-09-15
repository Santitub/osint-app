class CustomApi {
  final String id;
  final String name;
  final String urlTemplate;
  final Map<String, String> headers;

  CustomApi({
    required this.id,
    required this.name,
    required this.urlTemplate,
    required this.headers,
  });

  factory CustomApi.fromJson(Map<String, dynamic> json) => CustomApi(
        id: json['id'],
        name: json['name'],
        urlTemplate: json['urlTemplate'],
        headers: Map<String, String>.from(json['headers']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'urlTemplate': urlTemplate,
        'headers': headers,
      };
}