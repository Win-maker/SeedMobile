class Contents {
  final String contentName;
  final String wordDescription;
  final String pictureBackground;

  Contents(
      {required this.contentName,
      required this.wordDescription,
      required this.pictureBackground});

  factory Contents.fromJson(Map<String, dynamic> json) {
    return Contents(
      contentName: json['content_Name'] as String,
      wordDescription: json['wordDescription'] as String,
      pictureBackground: json['pictureBackground'] as String,
    );
  }
}
