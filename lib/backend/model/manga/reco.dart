class RecoModel {
  
  final int mangaid;
  final String title;
  final String status;
  final double rating;
  final int volume_count;
  final String cover_image;
  final String description;
  final String chapter_count;

  final List<String> tags;
  final List<String> authors;
  final List<String> artists;

  RecoModel({
    required this.title,
    required this.status,
    required this.rating,
    required this.mangaid,
    required this.description,
    required this.cover_image,
    required this.volume_count,
    required this.chapter_count,

    required this.tags,
    required this.artists,
    required this.authors
  });

  factory RecoModel.fromJson(Map<String, dynamic> json) {
    return RecoModel(
      title: json['title'] ?? 'N/A',
      status: json['status'] ?? 'N/A',
      rating: json['rating'] ?? 'N/A',
      description: json['description'] ?? 'N/A',
      cover_image: json['cover_image'] ?? '',
      volume_count: int.tryParse(json['volume_count'].toString()) ?? 0,
      chapter_count: json['chapter_count']?.toString() ?? 'N/A',
      mangaid: int.tryParse(json['id'].toString()) ?? 0,

      tags: List<String>.from(json['tags'] ?? []),
      artists: List<String>.from(json['artists'] ?? []),
      authors: List<String>.from(json['authors'] ?? []),
    );
  }

}
