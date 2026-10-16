import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/app/app.dart';
import 'package:tnc_minikatalog/app/app_theme.dart';
import 'package:tnc_minikatalog/catalog/screens/product_detail_screen.dart';
import 'package:tnc_minikatalog/catalog/screens/product_list_screen.dart';
import 'package:tnc_minikatalog/catalog/widgets/product_card.dart';

import '../fixtures/catalog_fixture.dart';

Future<void> _openCatalog(WidgetTester tester) async {
  await tester.pumpWidget(
    MiniKatalogApp(repository: MemoryProductRepository(catalogProducts())),
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Tüm ürünleri gör'));
  await tester.tap(find.text('Tüm ürünleri gör'));
  await tester.pumpAndSettle();
}

Finder _chip(String label) => find.widgetWithText(ChoiceChip, label);

void main() {
  testWidgets('keeps search and category when returning from product details', (
    tester,
  ) async {
    await _openCatalog(tester);
    await tester.tap(_chip('Ses'));
    await tester.enterText(find.byType(TextField), ' AIRPODS ');
    await tester.pumpAndSettle();
    expect(find.text('1 ürün bulundu'), findsOneWidget);

    final card = find.byType(ProductCard);
    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ProductDetailScreen>(find.byType(ProductDetailScreen))
          .product
          .name,
      'AirPods Max',
    );
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      ' AIRPODS ',
    );
    expect(tester.widget<ChoiceChip>(_chip('Ses')).selected, isTrue);
    expect(find.byType(ProductCard), findsOneWidget);
    expect(find.text('1 ürün bulundu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('clears both search and category from an empty result', (
    tester,
  ) async {
    await _openCatalog(tester);
    await tester.tap(_chip('Ses'));
    await tester.enterText(find.byType(TextField), 'macbook');
    await tester.pumpAndSettle();
    expect(find.text('0 ürün bulundu'), findsOneWidget);
    expect(find.byType(ProductCard), findsNothing);

    await tester.ensureVisible(find.text('Filtreleri temizle'));
    await tester.tap(find.text('Filtreleri temizle'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      isEmpty,
    );
    expect(tester.widget<ChoiceChip>(_chip('Tümü')).selected, isTrue);
    expect(find.byType(ProductCard), findsNWidgets(4));
    expect(find.text('4 ürün bulundu'), findsOneWidget);
  });

  testWidgets('clears the search without losing the selected category', (
    tester,
  ) async {
    await _openCatalog(tester);
    await tester.tap(_chip('Ses'));
    await tester.enterText(find.byType(TextField), 'unknown');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Aramayı temizle'));
    await tester.pumpAndSettle();

    expect(tester.widget<ChoiceChip>(_chip('Ses')).selected, isTrue);
    expect(find.byType(ProductCard), findsNWidgets(2));
    expect(find.text('2 ürün bulundu'), findsOneWidget);
    expect(find.byTooltip('Aramayı temizle'), findsNothing);
  });

  testWidgets('supports large text and keyboard space on a small screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: ProductListScreen(products: catalogProducts()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'ipAd');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(ProductCard));
    await tester.pumpAndSettle();

    expect(find.text('1 ürün bulundu'), findsOneWidget);
    expect(
      tester.widget<ProductCard>(find.byType(ProductCard)).product.name,
      'iPad Air',
    );
    expect(tester.takeException(), isNull);
  });
}
