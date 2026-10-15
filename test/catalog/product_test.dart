import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/catalog/models/product.dart';

import '../fixtures/product_fixture.dart';

void main() {
  test('reads both integer and decimal prices', () {
    expect(Product.fromJson(productJson()).price, 249.0);
    expect(Product.fromJson(productJson(price: 249.50)).price, 249.50);
  });

  test('keeps all fields when converted back to JSON', () {
    final original = Product.fromJson(productJson(price: 249.50));
    final restored = Product.fromJson(original.toJson());

    expect(restored.toJson(), original.toJson());
  });

  test('rejects missing names and invalid prices', () {
    expect(
      () => Product.fromJson(productJson()..remove('name')),
      throwsFormatException,
    );
    for (final price in [-1, double.infinity, double.nan]) {
      expect(
        () => Product.fromJson(productJson(price: price)),
        throwsFormatException,
      );
    }
  });

  test('rejects invalid identifiers and non-text specifications', () {
    expect(
      () => Product.fromJson(productJson()..['id'] = 0),
      throwsFormatException,
    );
    expect(
      () =>
          Product.fromJson(productJson()..['specifications'] = {'Weight': 200}),
      throwsFormatException,
    );
  });

  test('does not expose mutable product specifications', () {
    final json = productJson();
    final product = Product.fromJson(json);
    (json['specifications'] as Map)['Bağlantı'] = 'USB';

    expect(product.specifications['Bağlantı'], 'Bluetooth');
    expect(
      () => product.specifications['Bağlantı'] = 'USB',
      throwsUnsupportedError,
    );
    (product.toJson()['specifications'] as Map)['Bağlantı'] = 'USB';
    expect(product.specifications['Bağlantı'], 'Bluetooth');
  });
}
