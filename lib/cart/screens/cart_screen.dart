import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../app/app_theme.dart';
import '../../catalog/models/product.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/price_text.dart';
import '../cart_scope.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.loadProducts});

  final Future<List<Product>> Function() loadProducts;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _openingCatalog = false;

  Future<void> _browse() async {
    if (_openingCatalog) return;
    setState(() => _openingCatalog = true);
    try {
      final products = await widget.loadProducts();
      if (!mounted) return;
      final navigator = Navigator.of(context);
      var foundCatalog = false;
      navigator.popUntil((route) {
        foundCatalog = route.settings.name == AppRoutes.catalog;
        return foundCatalog || route.isFirst;
      });
      if (!foundCatalog) {
        navigator.pushNamed(AppRoutes.catalog, arguments: products);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Katalog yüklenemedi. Yeniden deneyebilirsin.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _openingCatalog = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final textTheme = Theme.of(context).textTheme;
    final browseLabel = _openingCatalog ? 'Açılıyor...' : 'Kataloğa dön';
    final padding = EdgeInsets.fromLTRB(
      AppTheme.pagePadding,
      16,
      AppTheme.pagePadding,
      MediaQuery.paddingOf(context).bottom + 24,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 668),
          child: cart.items.isEmpty
              ? ListView(
                  padding: padding,
                  children: [
                    EmptyState(
                      title: 'Sepetin henüz boş.',
                      message: 'Seçkiden beğendiğin ürünleri burada biriktir.',
                      icon: Icons.shopping_bag_outlined,
                      actionLabel: browseLabel,
                      onAction: _browse,
                    ),
                  ],
                )
              : ListView.builder(
                  padding: padding,
                  itemCount: cart.items.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seçtiklerin', style: textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                '${cart.items.length} farklı ürün, ${cart.quantity} adet',
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index <= cart.items.length) {
                      final item = cart.items[index - 1];
                      return CartItemTile(
                        key: ValueKey(item.product.id),
                        item: item,
                        onIncrease: () => cart.onAdd(item.product),
                        onDecrease: () => cart.onDecrease(item.product.id),
                        onRemove: () => cart.onRemove(item.product.id),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Divider(),
                          const SizedBox(height: 16),
                          Text('Toplam', style: textTheme.titleMedium),
                          const SizedBox(height: 8),
                          for (final total in cart.totalsByCurrency.entries)
                            PriceText(
                              amount: total.value / 100,
                              currency: total.key,
                              style: textTheme.headlineSmall?.copyWith(
                                color: AppTheme.accent,
                              ),
                            ),
                          const SizedBox(height: 24),
                          OutlinedButton(
                            onPressed: _openingCatalog ? null : _browse,
                            child: Text(
                              _openingCatalog
                                  ? 'Açılıyor...'
                                  : 'Alışverişe devam et',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
