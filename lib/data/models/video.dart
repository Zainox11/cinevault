// lib/data/models/video.dart

class Video {
  final String id;
  final String key; // YouTube video ki ID
  final String name;
  final String site; // YouTube, Vimeo, etc.
  final String type; // Trailer, Teaser, Featurette

  Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
    );
  }
}