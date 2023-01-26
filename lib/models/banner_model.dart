class BannerModel {
  final String? id;
  final String? name;

  BannerModel({this.id, this.name});

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      BannerModel(id: json['id'], name: json['name']);
}
