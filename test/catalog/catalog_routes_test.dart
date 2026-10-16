import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/app/app.dart';
import 'package:tnc_minikatalog/app/app_routes.dart';
import 'package:tnc_minikatalog/catalog/screens/home_screen.dart';
import 'package:tnc_minikatalog/catalog/screens/product_detail_screen.dart';
import 'package:tnc_minikatalog/catalog/screens/product_list_screen.dart';
import 'package:tnc_minikatalog/catalog/widgets/product_card.dart';

import '../fixtures/catalog_fixture.dart';

void main() {
  testWidgets('opens the selected product with route arguments', (
    tester,
  ) async {
    final products = catalogProducts();
    final repository = MemoryProductRepository(products);
    await tester.pumpWidget(MiniKatalogApp(repository: repository));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tüm ürünleri gör'));
    await tester.tap(find.text('Tüm ürünleri gör'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductListScreen), findsOneWidget);
    final card = find.byType(ProductCard).first;
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();

    final detailFinder = find.byType(ProductDetailScreen);
    expect(
      tester.widget<ProductDetailScreen>(detailFinder).product,
      same(products.first),
    );
    final route = ModalRoute.of(tester.element(detailFinder));
    expect(route?.settings.name, AppRoutes.productDetail);
    expect(route?.settings.arguments, same(products.first));
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(ProductListScreen), findsOneWidget);
    expect(repository.loadCount, 1);
  });

  testWidgets('returns home when a product route has invalid arguments', (
    tester,
  ) async {
    await tester.pumpWidget(
      MiniKatalogApp(repository: MemoryProductRepository(catalogProducts())),
    );
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(HomeScreen)))
        .pushNamed(AppRoutes.productDetail, arguments: 'missing product');
    await tester.pumpAndSettle();

    expect(find.text('Bu sayfaya ulaşılamıyor.'), findsOneWidget);
    await tester.tap(find.text('Ana sayfaya dön'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Sayfa açılamadı'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
