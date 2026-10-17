import 'package:flutter/material.dart';

import '../cart/cart_scope.dart';
import '../cart/models/cart_item.dart';
import '../catalog/data/product_repository.dart';
import '../catalog/models/product.dart';
import '../catalog/screens/home_screen.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class MiniKatalogApp extends StatefulWidget {
  const MiniKatalogApp({super.key, this.repository});

  final ProductRepository? repository;

  @override
  State<MiniKatalogApp> createState() => _MiniKatalogAppState();
}

class _MiniKatalogAppState extends State<MiniKatalogApp> {
  List<CartItem> _items = const [];
  late final _repository = widget.repository ?? ProductRepository();
  Future<List<Product>>? _catalog;

  Future<List<Product>> _loadProducts() {
    return _catalog ??= _repository.loadProducts().then(
      (products) => products,
      onError: (Object error, StackTrace stack) {
        _catalog = null;
        Error.throwWithStackTrace(error, stack);
      },
    );
  }

  void _add(Product product) {
    setState(() {
      final index = _items.indexWhere((item) => item.product.id == product.id);
      if (index == -1) {
        _items = [..._items, CartItem(product: product)];
      } else {
        _items = [
          for (var i = 0; i < _items.length; i++)
            if (i == index)
              _items[i].withQuantity(_items[i].quantity + 1)
            else
              _items[i],
        ];
      }
    });
  }

  void _decrease(int productId) {
    setState(() {
      _items = [
        for (final item in _items)
          if (item.product.id != productId)
            item
          else if (item.quantity > 1)
            item.withQuantity(item.quantity - 1),
      ];
    });
  }

  void _remove(int productId) {
    setState(() {
      _items = _items.where((item) => item.product.id != productId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      items: _items,
      onAdd: _add,
      onDecrease: _decrease,
      onRemove: _remove,
      child: MaterialApp(
        title: 'Mini Katalog',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: HomeScreen(loadProducts: _loadProducts),
        onGenerateRoute: (settings) =>
            AppRoutes.generate(settings, loadProducts: _loadProducts),
      ),
    );
  }
}
