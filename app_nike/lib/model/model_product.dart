class Product {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final bool newArrival;
  final List<dynamic> brand;
  final List<dynamic> category;
  final List<dynamic> tax;
  final List<dynamic> conpons;
  final List<Variants> varants;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.brand,
    required this.category,
    required this.conpons,
    required this.newArrival,
    required this.tax,
    required this.varants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'] ?? false,
      brand: json['brand'] ?? [],
      category: json['category'] ?? [],
      conpons: json['coupons'] ?? [],
      newArrival: json['new_arrival'] ?? false,
      tax: json['tax'] ?? [],
      varants: (json['varants'] as List? ?? [])
          .map((e) => Variants.fromJson(e))
          .toList(),
    );
  }
}

class Variants {
  final List<ImageProduct> images;
  final String price;

  Variants({required this.images, required this.price});

  factory Variants.fromJson(Map<String, dynamic> json) {
    return Variants(
      price: json['price'],
      images: (json['images'] as List? ?? [])
          .map((e) => ImageProduct.fromJson(e))
          .toList(),
    );
  }
}

class ImageProduct {
  final String image;

  ImageProduct({required this.image});

  factory ImageProduct.fromJson(Map<String, dynamic> json) {
    return ImageProduct(image: json['image']);
  }
}
