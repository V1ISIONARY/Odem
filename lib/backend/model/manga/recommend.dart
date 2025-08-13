import 'package:odem/backend/model/manga/chapter_detail.dart';

class RecoModel {
  final String mangaid;
  final String title;
  final String status;
  final double rating;
  final int volume_count;
  final String main_image;
  final String cover_image;
  final String description;
  final String chapter_count;

  final List<String> tags;
  final List<String> authors;
  final List<String> artists;

  final List<ChapterDetail> chapterdetails;

  RecoModel({
    required this.title,
    required this.status,
    required this.rating,
    required this.mangaid,
    required this.description,
    required this.main_image,
    required this.cover_image,
    required this.volume_count,
    required this.chapter_count,
    required this.tags,
    required this.artists,
    required this.authors,

    required this.chapterdetails,
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
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': mangaid,
      'title': title,
      'status': status,
      'rating': rating,
      'volume_count': volume_count,
      'main_image': main_image,
      'cover_image': cover_image,
      'description': description,
      'chapter_count': chapter_count,
      'tags': tags,
      'authors': authors,
      'artists': artists,
      'chapterdetails': chapterdetails.map((e) => e.toJson()).toList(),
    };
  }
  
}
