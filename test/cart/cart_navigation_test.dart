import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/app/app.dart';
import 'package:tnc_minikatalog/catalog/data/product_repository.dart';
import 'package:tnc_minikatalog/catalog/models/product.dart';
import 'package:tnc_minikatalog/catalog/screens/home_screen.dart';
import 'package:tnc_minikatalog/catalog/screens/product_list_screen.dart';

import '../fixtures/catalog_fixture.dart';

void main() {
  testWidgets('can leave the cart while the catalog is still loading', (
    tester,
  ) async {
    final repository = _PendingRepository();
    await tester.pumpWidget(MiniKatalogApp(repository: repository));
    await tester.pump();
    await tester.tap(find.byTooltip('Sepet (0 ürün)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Kataloğa dön'));
    await tester.pump();
    await tester.pageBack();
    await tester.pump(const Duration(milliseconds: 400));
    repository.request.complete(catalogProducts());
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(ProductListScreen), findsNothing);
    expect(repository.loadCount, 1);
    expect(tester.takeException(), isNull);
  });
}

class _PendingRepository extends ProductRepository {
  final request = Completer<List<Product>>();
  int loadCount = 0;

  @override
  Future<List<Product>> loadProducts() {
    loadCount++;
    return request.future;
  }
}
