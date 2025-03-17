
class BannerModel {
  final int? id;
  final String image;
  final String? redirect;

  BannerModel({this.id, required this.image, this.redirect});

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
        id: map['id'],
        image: map['banner_link'] ?? '',
        redirect: map['redirect_link']);
  }

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      BannerModel.fromMap(json);

  BannerModel toJson() {
    return BannerModel(
        id: id,
        image: 'banner_link',
        redirect: 'redirect_link');
  }

}
