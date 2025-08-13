class Extension {
  final String language;
  final String version;
  final String logoImg;
  final String exName;
  final String key;

  Extension({
    required this.language,
    required this.version,
    required this.logoImg,
    required this.exName,
    required this.key
  });

  factory Extension.fromJson(Map<String, dynamic> json) {
    return Extension(
      language: json['language'],
      version: json['version'],
      logoImg: json['logoImg'],
      exName: json['exName'],
      key: json['key']
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language,
    'version': version,
    'logoImg': logoImg,
    'exName': exName,
    'key': key
  };

}