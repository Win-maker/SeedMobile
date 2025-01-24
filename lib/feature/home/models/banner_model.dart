class BannerType {
  final String orgImage;

  BannerType({required this.orgImage});

  factory BannerType.fromJson(Map<String, dynamic> json) {
    return BannerType(orgImage: json['orgImage'] as String);
  }
}
