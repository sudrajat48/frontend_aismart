class VoucherModel {
  final String? id;
  final String? userID;
  final String? name;
  final String? description;
  late final String? image;
  final int? point;
  final int? isDiscount;
  final int? discountPercent;
  final int? discountPrice;
  final String? activeAt;
  final String? expiredAt;
  final String? createdAt;

  VoucherModel(
      {this.id,
      this.userID,
      this.name,
      this.description,
      this.image,
      this.point,
      this.isDiscount,
      this.discountPercent,
      this.discountPrice,
      this.activeAt,
      this.expiredAt,
      this.createdAt});

  factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
      id: json["id"],
      userID: json["user_id"],
      name: json["name_voucher"],
      description: json["description"],
      image: json["image"],
      point: json["point"] as int,
      isDiscount: json["is_discount"],
      discountPercent: json["discount_percent"],
      discountPrice: json["discount_price"],
      activeAt: json["active_at"],
      expiredAt: json["expired_at"],
      createdAt: json["created_at"]);
}
