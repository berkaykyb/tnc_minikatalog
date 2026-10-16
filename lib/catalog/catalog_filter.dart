import 'models/product.dart';

List<Product> filterProducts(
  List<Product> products, {
  String query = '',
  String? category,
}) {
  final search = _normalize(query);
  return List.unmodifiable(
    products.where((product) {
      final matchesCategory = category == null || product.category == category;
      return matchesCategory && _normalize(product.name).contains(search);
    }),
  );
}

String _normalize(String value) => value
    .replaceAll('İ', 'i')
    .toLowerCase()
    .replaceAll('\u0307', '')
    .replaceAll('ı', 'i')
    .replaceAll('ç', 'c')
    .replaceAll('ğ', 'g')
    .replaceAll('ö', 'o')
    .replaceAll('ş', 's')
    .replaceAll('ü', 'u')
    .trim()
    .replaceAll(RegExp(r'\s+'), ' ');
