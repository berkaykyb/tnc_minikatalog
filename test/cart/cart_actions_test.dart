import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/app/app.dart';
import 'package:tnc_minikatalog/app/app_routes.dart';
import 'package:tnc_minikatalog/cart/cart_scope.dart';
import 'package:tnc_minikatalog/catalog/screens/home_screen.dart';
import 'package:tnc_minikatalog/catalog/screens/product_detail_screen.dart';

import '../fixtures/catalog_fixture.dart';

void main() {
  testWidgets('adds repeated products to one row and keeps cart on return', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      final products = catalogProducts();
      final repository = MemoryProductRepository(products);
      await tester.pumpWidget(MiniKatalogApp(repository: repository));
      await tester.pumpAndSettle();
      final homeContext = tester.element(find.byType(HomeScreen));
      final initial = CartScope.of(homeContext);
      Navigator.of(homeContext)
          .pushNamed(AppRoutes.productDetail, arguments: products.first);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sepete ekle'));
      await tester.tap(find.text('Sepete ekle'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sepete ekle'));
      await tester.pumpAndSettle();

      final cart = CartScope.of(
        tester.element(find.byType(ProductDetailScreen)),
      );
      expect(cart.items, hasLength(1));
      expect(cart.quantity, 2);
      expect(cart.items.single.product, same(products.first));
      expect(cart.items.single.totalCents, 109800);
      expect(initial.items, isEmpty);
      expect(() => cart.items.clear(), throwsUnsupportedError);
      expect(find.text('AirPods Max sepete eklendi.'), findsOneWidget);
      expect(
        tester.getSemantics(find.byTooltip('Sepet (2 ürün)')).label,
        'Sepet (2 ürün)',
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(CartScope.of(tester.element(find.byType(HomeScreen))).quantity, 2);
      expect(repository.loadCount, 1);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });
}
