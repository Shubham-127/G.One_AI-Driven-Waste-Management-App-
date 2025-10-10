class Report {
  final String id;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String? photoPath;

  Report({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.photoPath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'createdAt': createdAt.toIso8601String(),
      };
}
