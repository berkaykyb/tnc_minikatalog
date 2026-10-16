import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/catalog/catalog_filter.dart';
import 'package:tnc_minikatalog/catalog/models/product.dart';

import '../fixtures/product_fixture.dart';

Product _product(int id, String name, String category) => Product.fromJson({
  ...productJson(),
  'id': id,
  'name': name,
  'category': category,
});

void main() {
  final products = [
    _product(1, 'iPad Air', 'Tablet'),
    _product(2, 'MacBook Air', 'Dizüstü'),
    _product(3, 'Kablosuz Kulaklık', 'Ses'),
    _product(4, 'Işık', 'Aksesuar'),
  ];

  test('matches Turkish case and plain keyboard spellings', () {
    for (final query in ['İPAD', 'IPAD', 'ıpad']) {
      expect(filterProducts(products, query: query).single.id, 1);
    }
    expect(filterProducts(products, query: 'kulaklik').single.id, 3);
    expect(filterProducts(products, query: 'ISIK').single.id, 4);
  });

  test('ignores surrounding and repeated spaces', () {
    expect(filterProducts(products, query: '  MACBOOK   AIR  ').single.id, 2);
    expect(filterProducts(products, query: '   '), products);
  });

  test('combines search and category without changing the source list', () {
    final result = filterProducts(products, query: 'air', category: 'Tablet');
    expect(result.map((product) => product.id), [1]);
    expect(products, hasLength(4));
    expect(() => result.clear(), throwsUnsupportedError);
    expect(
      filterProducts(products, query: 'kulaklık', category: 'Tablet'),
      isEmpty,
    );
  });
}
