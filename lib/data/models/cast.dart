// lib/data/models/cast.dart

class Cast {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  Cast({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      character: json['character'] ?? 'Unknown',
      profilePath: json['profile_path'],
    );
  }
}