// In model/product.dart
class ModelProduct {
  final String name;
  final double price;
  final String image;
  final List<String> category;
  final List<String> sizes;
  final String colors;
  final List<String> sizeImage;
  final String description;

  ModelProduct({
    required this.image,
    required this.description,
    required this.name,
    required this.price,
    required this.category,
    required this.sizes,
    required this.colors,
    required this.sizeImage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelProduct &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price &&
          image == other.image &&
          description == other.description &&
          colors == other.colors &&
          category.toString() == other.category.toString() &&
          sizes.toString() == other.sizes.toString() &&
          sizeImage.toString() == other.sizeImage.toString();

  @override
  int get hashCode =>
      name.hashCode ^
      price.hashCode ^
      image.hashCode ^
      description.hashCode ^
      colors.hashCode ^
      category.toString().hashCode ^
      sizes.toString().hashCode ^
      sizeImage.toString().hashCode;

  get quantity => null;
}
