class Product {
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.description,
    required this.price,
    required this.currency,
    required this.imageAsset,
    required Map<String, String> specifications,
  }) : specifications = Map.unmodifiable(specifications);

  final int id;
  final String name;
  final String category;
  final String shortDescription;
  final String description;
  final double price;
  final String currency;
  final String imageAsset;
  final Map<String, String> specifications;

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final price = json['price'];
    final specifications = json['specifications'];

    if (id is! int || id <= 0) {
      throw const FormatException('Ürün kimliği geçersiz.');
    }
    if (price is! num || !price.isFinite || price < 0) {
      throw const FormatException('Ürün fiyatı geçersiz.');
    }
    if (specifications is! Map<String, dynamic> ||
        specifications.values.any((value) => value is! String)) {
      throw const FormatException('Ürün özellikleri geçersiz.');
    }

    return Product(
      id: id,
      name: _readText(json, 'name'),
      category: _readText(json, 'category'),
      shortDescription: _readText(json, 'shortDescription'),
      description: _readText(json, 'description'),
      price: price.toDouble(),
      currency: _readText(json, 'currency'),
      imageAsset: _readText(json, 'imageAsset'),
      specifications: Map<String, String>.from(specifications),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'shortDescription': shortDescription,
    'description': description,
    'price': price,
    'currency': currency,
    'imageAsset': imageAsset,
    'specifications': Map<String, String>.of(specifications),
  };

  static String _readText(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Ürün alanı eksik: $key');
    }
    return value.trim();
  }
}
