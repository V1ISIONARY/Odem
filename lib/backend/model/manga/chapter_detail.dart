class ChapterDetail {
  DateTime timeRead;
  final String sourceKey;
  final String chapter;
  final String link;
  final String date;
  int percentage;

  ChapterDetail({
    required this.sourceKey,
    required this.timeRead,
    required this.chapter,
    this.percentage = 0,
    required this.link,
    required this.date,
  });

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    return ChapterDetail(
      sourceKey: json['sourceKey'] ?? 'Unknown',
      chapter: json['chapterNo'] ?? 'Unknown',
      percentage: json['percentage'] ?? 0,
      timeRead: json['timeRead'] != null 
        ? DateTime.parse(json['timeRead']) 
        : DateTime.fromMillisecondsSinceEpoch(0),
      date: json['date'] ?? 'Unknown',
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeRead': timeRead.toIso8601String(),
      'percentage': percentage,
      'sourceKey': sourceKey,
      'chapterNo': chapter,
      'link': link,
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