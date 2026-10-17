import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/app/app.dart';
import 'package:tnc_minikatalog/app/app_routes.dart';
import 'package:tnc_minikatalog/app/app_theme.dart';
import 'package:tnc_minikatalog/cart/cart_scope.dart';
import 'package:tnc_minikatalog/cart/models/cart_item.dart';
import 'package:tnc_minikatalog/cart/screens/cart_screen.dart';
import 'package:tnc_minikatalog/cart/widgets/cart_item_tile.dart';
import 'package:tnc_minikatalog/catalog/data/product_repository.dart';
import 'package:tnc_minikatalog/catalog/models/product.dart';
import 'package:tnc_minikatalog/catalog/screens/home_screen.dart';
import 'package:tnc_minikatalog/catalog/screens/product_list_screen.dart';
import 'package:tnc_minikatalog/catalog/widgets/product_card.dart';

import '../fixtures/catalog_fixture.dart';
import '../fixtures/product_fixture.dart';

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('keeps catalog filters and cart counts across all screens', (
    tester,
  ) async {
    final repository = MemoryProductRepository(catalogProducts());
    await tester.pumpWidget(MiniKatalogApp(repository: repository));
    await tester.pumpAndSettle();
    await _tapVisible(tester, find.text('Tüm ürünleri gör'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Ses'));
    await tester.enterText(find.byType(TextField), 'airpods');
    await tester.pumpAndSettle();
    await _tapVisible(tester, find.byType(ProductCard));
    await _tapVisible(tester, find.text('Sepete ekle'));
    await _tapVisible(tester, find.text('Sepete ekle'));
    expect(find.byTooltip('Sepet (2 ürün)'), findsOneWidget);
    await tester.tap(find.byTooltip('Sepet (2 ürün)'));
    await tester.pumpAndSettle();
    await _tapVisible(tester, find.byTooltip('AirPods Max adet artır'));
    expect(find.text('1 farklı ürün, 3 adet'), findsOneWidget);
    await _tapVisible(tester, find.byTooltip('AirPods Max adet azalt'));
    await _tapVisible(tester, find.text('Kaldır'));
    expect(find.text('Sepetin henüz boş.'), findsOneWidget);
    await _tapVisible(tester, find.text('Kataloğa dön'));

    expect(find.byType(ProductListScreen), findsOneWidget);
    expect(find.byTooltip('Sepet (0 ürün)'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'airpods',
    );
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Ses'))
          .selected,
      isTrue,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    await _tapVisible(tester, find.byTooltip('Sepet (0 ürün)'));
    expect(find.text('Sepetin henüz boş.'), findsOneWidget);
    expect(repository.loadCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('removes a whole row and decrements the last item to empty', (
    tester,
  ) async {
    final products = catalogProducts();
    await tester.pumpWidget(
      MiniKatalogApp(repository: MemoryProductRepository(products)),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HomeScreen));
    final cart = CartScope.of(context);
    cart.onAdd(products.first);
    cart.onAdd(products.first);
    cart.onAdd(products[1]);
    Navigator.of(context).pushNamed(AppRoutes.cart);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Toplam'), 250);
    expect(find.text(r'$1.197'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Kaldır').first, -250);
    await _tapVisible(tester, find.text('Kaldır').first);
    expect(find.text('1 farklı ürün, 1 adet'), findsOneWidget);
    expect(find.text('AirPods Max'), findsNothing);
    final remaining = CartScope.of(tester.element(find.byType(CartScreen)));
    expect(remaining.totalsByCurrency, {'USD': 9900});
    await _tapVisible(tester, find.byTooltip('HomePod Mini adet azalt'));
    expect(find.text('Sepetin henüz boş.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byTooltip('Sepet (0 ürün)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps different currencies in separate totals', (tester) async {
    final dollars = Product.fromJson(productJson(price: 0.29));
    final euros = Product.fromJson({
      ...productJson(price: 1.15),
      'id': 2,
      'currency': 'EUR',
    });
    await tester.pumpWidget(
      MiniKatalogApp(repository: MemoryProductRepository([dollars, euros])),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HomeScreen));
    final cart = CartScope.of(context);
    cart.onAdd(dollars);
    cart.onAdd(dollars);
    cart.onAdd(dollars);
    cart.onAdd(euros);
    await tester.pump();
    expect(CartScope.of(context).totalsByCurrency, {'USD': 87, 'EUR': 115});
    expect(cart.items, isEmpty);
  });

  testWidgets(
    'fits long names, missing images and large text on a small screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      addTearDown(tester.view.reset);
      final product = Product.fromJson({
        ...productJson(),
        'name': 'Çalışma masası için uzun bir adı olan kablosuz kulaklık',
        'imageAsset': 'assets/images/products/missing.png',
      });
      await tester.pumpWidget(
        CartScope(
          items: [CartItem(product: product, quantity: 3)],
          onAdd: (_) {},
          onDecrease: (_) {},
          onRemove: (_) {},
          child: MaterialApp(
            theme: AppTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(2)),
              child: child!,
            ),
            home: CartScreen(loadProducts: () async => [product]),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.byType(CartItemTile), 100);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Toplam'), 200);
      await tester.scrollUntilVisible(find.text('Alışverişe devam et'), 150);
      expect(find.text(r'$747'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('stays in the cart after a failed catalog load and can retry', (
    tester,
  ) async {
    final repository = _RetryRepository();
    await tester.pumpWidget(MiniKatalogApp(repository: repository));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Sepet (0 ürün)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kataloğa dön'));
    await tester.pumpAndSettle();
    expect(find.byType(CartScreen), findsOneWidget);
    expect(
      find.text('Katalog yüklenemedi. Yeniden deneyebilirsin.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Kataloğa dön'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductListScreen), findsOneWidget);
    expect(repository.loadCount, 3);
    expect(tester.takeException(), isNull);
  });
}

class _RetryRepository extends ProductRepository {
  int loadCount = 0;

  @override
  Future<List<Product>> loadProducts() async {
    loadCount++;
    if (loadCount < 3) throw const ProductLoadException();
    return catalogProducts();
  }
}
