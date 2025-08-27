import 'package:odem/backend/model/manga/chapter_detail.dart';

class RecoModel {

  List<ChapterDetail> chapterdetails;
  final String chapter_count;
  final List<String> authors;
  final List<String> artists;
  final String cover_image;
  final String description;
  final List<String> tags;
  final String main_image;
  final int volume_count;
  DateTime updatedAt;
  final String mangaid;
  final String status;
  final String title;
  bool isFavorite;
  double rating;
  bool isPinned;

  RecoModel({
    required this.chapterdetails,
    required this.chapter_count,
    required this.volume_count,
    required this.description,
    required this.cover_image,
    required this.main_image,
    required this.updatedAt,
    this.isFavorite = false,
    this.isPinned = false,
    required this.mangaid,
    required this.artists,
    required this.authors,
    required this.status,
    required this.rating,
    required this.title,
    required this.tags,
  });

  factory RecoModel.fromJson(Map<String, dynamic> json) {
    String normalizeImage(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is List && value.isNotEmpty) return value.first.toString();
      return value.toString();
    }

    return RecoModel(
      title: json['title'] ?? 'N/A',
      status: json['status'] ?? 'N/A',
      rating: (json['rating'] is int)
        ? (json['rating'] as int).toDouble()
        : (json['rating'] is String)
          ? double.tryParse(json['rating']) ?? 0.0
          : json['rating'] ?? 0.0,
      description: json['description'] ?? 'N/A',
      cover_image: normalizeImage(json['cover_image']),
      volume_count: int.tryParse(json['volume_count'].toString()) ?? 0,
      main_image: normalizeImage(json['main_image']),
      chapter_count: json['chapter_count']?.toString() ?? 'N/A',
      mangaid: json['id']?.toString() ?? "unknownId",
      tags: List<String>.from(json['tags'] ?? []),
      artists: List<String>.from(json['artists'] ?? []),
      authors: List<String>.from(json['authors'] ?? []),
      chapterdetails: (json['chapterdetails'] as List<dynamic>?)
          ?.map((item) => ChapterDetail.fromJson(item))
          .toList() ??
        [],
      updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
        : DateTime.now(),
      isPinned: json['isPinned'] ?? false,
      isFavorite: json['isFavorite'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterdetails': chapterdetails.map((e) => e.toJson()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
      'chapter_count': chapter_count,
      'volume_count': volume_count,
      'cover_image': cover_image,
      'description': description,
      'main_image': main_image,
      'isFavorite': isFavorite,
      'isPinned' : isPinned,
      'authors': authors,
      'artists': artists,
      'status': status,
      'rating': rating,
      'title': title,
      'id': mangaid,
      'tags': tags,
    };
  }
}