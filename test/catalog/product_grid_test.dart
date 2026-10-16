import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/app/app_theme.dart';
import 'package:tnc_minikatalog/catalog/models/product.dart';
import 'package:tnc_minikatalog/catalog/screens/product_list_screen.dart';
import 'package:tnc_minikatalog/shared/widgets/price_text.dart';

import '../fixtures/product_fixture.dart';

void main() {
  test('formats prices with grouping and optional fractional digits', () {
    expect(formatPrice(1299, 'USD'), r'$1.299');
    expect(formatPrice(7.5, 'USD'), r'$7,50');
    expect(formatPrice(0.01, 'TRY'), '₺0,01');
    expect(formatPrice(99.999, 'EUR'), '€100');
    expect(formatPrice(12, 'CAD'), '12 CAD');
  });

  testWidgets('keeps long names and missing images inside a narrow grid', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final products = [
      Product.fromJson({
        ...productJson(),
        'name': 'Çok uzun bir ürün adına sahip kablosuz kulaklık',
        'imageAsset': 'assets/images/products/missing.png',
      }),
      Product.fromJson({...productJson(price: 1299), 'id': 2}),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ProductListScreen(products: products),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    expect(find.text(r'$1.299'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
