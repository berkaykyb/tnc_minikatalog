import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/app/app_theme.dart';
import 'package:tnc_minikatalog/catalog/models/product.dart';
import 'package:tnc_minikatalog/catalog/screens/product_detail_screen.dart';

import '../fixtures/product_fixture.dart';

void main() {
  testWidgets('scrolls long details and specifications with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final product = Product.fromJson({
      ...productJson(),
      'name': 'Uzun bir ürün adına sahip kablosuz kulaklık',
      'description': List.filled(
        10,
        'Günlük kullanım için uzun bir açıklama.',
      ).join(' '),
      'imageAsset': 'assets/images/products/missing.png',
      'specifications': {
        'Bağlantı türü': 'Kablosuz bağlantı ve masaüstü kullanım',
      },
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: ProductDetailScreen(product: product),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    await tester.ensureVisible(
      find.text('Kablosuz bağlantı ve masaüstü kullanım'),
    );
    await tester.pumpAndSettle();
    expect(find.text(product.description), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('omits the specifications section when no values are supplied', (
    tester,
  ) async {
    final product = Product.fromJson({
      ...productJson(),
      'specifications': <String, dynamic>{},
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ProductDetailScreen(product: product),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ürün hakkında'), findsOneWidget);
    expect(find.text('Özellikler'), findsNothing);
    expect(find.text('Sepete ekle'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
