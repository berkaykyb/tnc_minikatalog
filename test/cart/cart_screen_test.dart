import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/app/app.dart';
import 'package:tnc_minikatalog/app/app_routes.dart';
import 'package:tnc_minikatalog/cart/cart_scope.dart';
import 'package:tnc_minikatalog/cart/screens/cart_screen.dart';
import 'package:tnc_minikatalog/catalog/screens/home_screen.dart';
import 'package:tnc_minikatalog/catalog/screens/product_list_screen.dart';

import '../fixtures/catalog_fixture.dart';

void main() {
  testWidgets('updates quantities and returns from an empty cart to catalog', (
    tester,
  ) async {
    final products = catalogProducts();
    final repository = MemoryProductRepository(products);
    await tester.pumpWidget(MiniKatalogApp(repository: repository));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HomeScreen));
    CartScope.of(context).onAdd(products.first);
    Navigator.of(context).pushNamed(AppRoutes.cart);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('AirPods Max adet artır'));
    await tester.pumpAndSettle();
    expect(find.text('1 farklı ürün, 2 adet'), findsOneWidget);
    await tester.ensureVisible(find.text('Toplam'));
    expect(find.text(r'$1.098'), findsNWidgets(2));

    await tester.ensureVisible(find.byTooltip('AirPods Max adet azalt'));
    await tester.tap(find.byTooltip('AirPods Max adet azalt'));
    await tester.pumpAndSettle();
    expect(CartScope.of(tester.element(find.byType(CartScreen))).quantity, 1);
    await tester.tap(find.text('Kaldır'));
    await tester.pumpAndSettle();
    expect(find.text('Sepetin henüz boş.'), findsOneWidget);
    expect(find.text('Toplam'), findsNothing);

    await tester.tap(find.text('Kataloğa dön'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductListScreen), findsOneWidget);
    expect(find.byTooltip('Sepet (0 ürün)'), findsOneWidget);
    expect(repository.loadCount, 1);
    expect(tester.takeException(), isNull);
  });
}
