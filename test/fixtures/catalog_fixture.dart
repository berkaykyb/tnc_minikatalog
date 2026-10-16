import 'package:tnc_minikatalog/catalog/data/product_repository.dart';
import 'package:tnc_minikatalog/catalog/models/product.dart';

import 'product_fixture.dart';

List<Product> catalogProducts() => [
  Product.fromJson({
    ...productJson(price: 549),
    'name': 'AirPods Max',
    'id': 1,
  }),
  Product.fromJson({
    ...productJson(price: 99),
    'name': 'HomePod Mini',
    'id': 2,
  }),
  Product.fromJson({
    ...productJson(price: 599),
    'id': 3,
    'name': 'iPad Air',
    'category': 'Tablet',
  }),
  Product.fromJson({
    ...productJson(price: 1299),
    'id': 4,
    'name': 'MacBook Air',
    'category': 'Dizüstü',
  }),
];

class MemoryProductRepository extends ProductRepository {
  MemoryProductRepository(this.products);

  final List<Product> products;
  int loadCount = 0;

  @override
  Future<List<Product>> loadProducts() async {
    loadCount++;
    return products;
  }
}
