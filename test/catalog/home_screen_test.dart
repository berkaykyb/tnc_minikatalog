import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/app/app_theme.dart';
import 'package:tnc_minikatalog/catalog/data/product_repository.dart';
import 'package:tnc_minikatalog/catalog/models/product.dart';
import 'package:tnc_minikatalog/catalog/screens/home_screen.dart';

import '../fixtures/product_fixture.dart';

class _ControlledRepository extends ProductRepository {
  final requests = <Completer<List<Product>>>[];

  @override
  Future<List<Product>> loadProducts() {
    final request = Completer<List<Product>>();
    requests.add(request);
    return request.future;
  }
}

List<Product> _products() => List.generate(
  8,
  (index) => Product.fromJson({
    ...productJson(),
    'id': index + 1,
    'name': 'Ürün ${index + 1}',
  }),
);

Widget _app(ProductRepository repository, {double textScale = 1}) =>
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: HomeScreen(repository: repository),
    );

void main() {
  testWidgets('shows loading and retries a failed request', (tester) async {
    final repository = _ControlledRepository();
    await tester.pumpWidget(_app(repository));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    repository.requests.single.completeError(const ProductLoadException());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tekrar dene'));
    await tester.tap(find.text('Tekrar dene'));
    await tester.pump();

    expect(repository.requests, hasLength(2));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.requests.last.complete(_products());
    await tester.pumpAndSettle();

    expect(find.text('Ürün 1'), findsOneWidget);
    expect(find.text('Ürün 4'), findsNothing);
    expect(find.text('8 ürün, 1 farklı kategori.'), findsOneWidget);
    expect(find.text('Tekrar dene'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows an empty selection without product rows', (tester) async {
    final repository = _ControlledRepository();
    await tester.pumpWidget(_app(repository));
    repository.requests.single.complete([]);
    await tester.pumpAndSettle();

    expect(find.text('Seçki henüz hazır değil.'), findsOneWidget);
    expect(find.text('Seçkiden ilk bakış'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('fits a small screen with large text and a keyboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.reset);

    final repository = _ControlledRepository();
    await tester.pumpWidget(_app(repository, textScale: 2));
    repository.requests.single.complete(_products());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Ürün 3'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Ürün 3'), findsOneWidget);
  });
}
