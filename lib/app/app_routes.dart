import 'package:flutter/material.dart';

import '../catalog/models/product.dart';
import '../catalog/screens/product_detail_screen.dart';
import '../catalog/screens/product_list_screen.dart';
import '../shared/widgets/empty_state.dart';

abstract final class AppRoutes {
  static const catalog = '/catalog';
  static const productDetail = '/product';

  static Route<void> generate(RouteSettings settings) {
    final arguments = settings.arguments;
    if (settings.name == catalog && arguments is List<Product>) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => ProductListScreen(
          products: List.unmodifiable(arguments),
          onProductSelected: (product) {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pushNamed(productDetail, arguments: product);
          },
        ),
      );
    }
    if (settings.name == productDetail && arguments is Product) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => ProductDetailScreen(product: arguments),
      );
    }
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Sayfa açılamadı')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: EmptyState(
              title: 'Bu sayfaya ulaşılamıyor.',
              message: 'Ana sayfadan yeniden bir ürün seçebilirsin.',
              icon: Icons.inventory_2_outlined,
              actionLabel: 'Ana sayfaya dön',
              onAction: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ),
        ),
      ),
    );
  }
}
