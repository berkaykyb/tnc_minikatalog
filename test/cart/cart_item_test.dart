import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/cart/models/cart_item.dart';
import 'package:tnc_minikatalog/catalog/models/product.dart';

import '../fixtures/product_fixture.dart';

void main() {
  test(
    'calculates decimal prices in whole cents without changing the item',
    () {
      final item = CartItem(
        product: Product.fromJson(productJson(price: 0.29)),
      );
      final increased = item.withQuantity(3);
      expect(increased.totalCents, 87);
      expect(item.totalCents, 29);
      expect(item.quantity, 1);
      expect(increased.product, same(item.product));
    },
  );

  test('rejects zero and negative quantities', () {
    final product = Product.fromJson(productJson());
    expect(() => CartItem(product: product, quantity: 0), throwsArgumentError);
    expect(() => CartItem(product: product, quantity: -1), throwsArgumentError);
    expect(
      () => CartItem(product: product).withQuantity(0),
      throwsArgumentError,
    );
  });
}
