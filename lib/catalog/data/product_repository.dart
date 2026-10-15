import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  ProductRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<List<Product>> loadProducts() async {
    try {
      final content = await _bundle.loadString(
        'assets/data/products.json',
        cache: false,
      );
      final decoded = jsonDecode(content);
      if (decoded is! List) {
        throw const FormatException('Ürün listesi bekleniyor.');
      }

      final ids = <int>{};
      final products = <Product>[];
      for (final entry in decoded) {
        if (entry is! Map<String, dynamic>) {
          throw const FormatException('Ürün kaydı geçersiz.');
        }
        final product = Product.fromJson(entry);
        if (!ids.add(product.id)) {
          throw const FormatException('Ürün kimliği tekrarlanıyor.');
        }
        products.add(product);
      }
      return List.unmodifiable(products);
    } catch (_) {
      throw const ProductLoadException();
    }
  }
}

class ProductLoadException implements Exception {
  const ProductLoadException();

  @override
  String toString() => 'Ürünler yüklenemedi. Lütfen tekrar dene.';
}
