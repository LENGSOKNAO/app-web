class ModelProduct {
  final String name;
  final String descrition;
  final List<String> image;
  final double price;
  final String category;
  final String color;
  final double qty;
  final String time;
  final List<String> sizes;

  const ModelProduct({
    required this.name,
    required this.image,
    required this.descrition,
    required this.price,
    required this.category,
    required this.color,
    required this.qty,
    required this.time,
    required this.sizes,
  });
}
