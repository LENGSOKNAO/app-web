// lib/models/product_model.dart
class Product {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final bool newArrival;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> brand;
  final List<dynamic> category;
  final List<dynamic> tax;
  final List<Variant> varants;
  final List<dynamic> coupons;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.newArrival,
    required this.createdAt,
    required this.updatedAt,
    required this.brand,
    required this.category,
    required this.tax,
    required this.varants,
    required this.coupons,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'],
      newArrival: json['new_arrival'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      brand: json['brand'] ?? [],
      category: json['category'] ?? [],
      tax: json['tax'] ?? [],
      varants: (json['varants'] as List? ?? [])
          .map((variant) => Variant.fromJson(variant))
          .toList(),
      coupons: json['coupons'] ?? [],
    );
  }
}

class Variant {
  final int id;
  final int productsId;
  final String price;
  final String? sizes;
  final String? colors;
  final int stock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductImage> images;

  Variant({
    required this.id,
    required this.productsId,
    required this.price,
    this.sizes,
    this.colors,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      productsId: json['products_id'],
      price: json['price'],
      sizes: json['sizes'],
      colors: json['colors'],
      stock: json['stock'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      images: (json['images'] as List? ?? [])
          .map((image) => ProductImage.fromJson(image))
          .toList(),
    );
  }
}

class ProductImage {
  final int id;
  final int productVariantsId;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubImage> subImage;

  ProductImage({
    required this.id,
    required this.productVariantsId,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.subImage,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productVariantsId: json['product_variants_id'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      subImage: (json['sub_image'] as List? ?? [])
          .map((subImage) => SubImage.fromJson(subImage))
          .toList(),
    );
  }
}

class SubImage {
  final int id;
  final int productImageId;
  final String subImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubImage({
    required this.id,
    required this.productImageId,
    required this.subImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubImage.fromJson(Map<String, dynamic> json) {
    return SubImage(
      id: json['id'],
      productImageId: json['product_image_id'],
      subImage: json['sub_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
