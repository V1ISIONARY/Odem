class ChapterDetail {
  final String link;
  final String chapter;
  final String date;

  ChapterDetail({
    required this.link,
    required this.chapter,
    required this.date,
  });

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    return ChapterDetail(
      link: json['link'] ?? '',
      chapter: json['chapterNo'] ?? 'Unknown',
      date: json['date'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'chapterNo': chapter,
      'date': date,
    };
  }
}

class MangaImgModel {
  final String url;
  const MangaImgModel({required this.url});
  factory MangaImgModel.fromJson(String url) {
    return MangaImgModel(url: url);
  }
  static List<MangaImgModel> listFromJson(Map<String, dynamic> json) {
    final List<dynamic> images = json['images'] ?? [];
    return images.map((e) => MangaImgModel.fromJson(e as String)).toList();
  }
}