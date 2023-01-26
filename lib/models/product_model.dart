class ProductModel {
  final String? id;
  final String? name;
  final String? categoryID;
  final String? description;
  final String? address;
  final String? urlAddress;
  final List? images;
  final String? defaultImage;
  final String? isFavorit;
  final double? rating;

  ProductModel(
      {this.id,
      this.name,
      this.categoryID,
      this.description,
      this.address,
      this.urlAddress,
      this.images,
      this.defaultImage,
      this.isFavorit,
      this.rating});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        categoryID: json['category_id'],
        description: json['description'],
        address: json['address'],
        urlAddress: json['url_address'],
        images: json['images'],
        defaultImage: json['default_image'],
        isFavorit: json['is_favorit'],
        rating: double.parse(json['rating'] ?? "0.0"),
      );
}
