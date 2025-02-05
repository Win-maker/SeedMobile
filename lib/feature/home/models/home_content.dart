class Contents {
  final String contentName;
  final String wordDescription;
  final String pictureBackground;
  final String contentFile;

  Contents(
      {required this.contentName,
      required this.wordDescription,
      required this.pictureBackground,
      required this.contentFile});

  factory Contents.fromJson(Map<String, dynamic> json) {
    return Contents(
      contentName: json['content_Name'] as String,
      wordDescription: json['wordDescription'] as String,
      pictureBackground: json['pictureBackground'] as String,
      contentFile:json['content_File'] as String
    );
  }
}
