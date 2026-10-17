import 'package:flutter/material.dart';

import '../../catalog/widgets/product_image.dart';
import '../../shared/widgets/price_text.dart';
import '../models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox.square(
                    dimension: 72,
                    child: ProductImage(assetPath: product.imageAsset),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Birim fiyat', style: textTheme.labelSmall),
                      PriceText(
                        amount: product.price,
                        currency: product.currency,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.outlined(
                      tooltip: '${product.name} adet azalt',
                      onPressed: onDecrease,
                      icon: const Icon(Icons.remove_rounded),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Semantics(
                        liveRegion: true,
                        label: '${product.name}: ${item.quantity} adet',
                        excludeSemantics: true,
                        child: Text(
                          '${item.quantity}',
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ),
                    IconButton.outlined(
                      tooltip: '${product.name} adet artır',
                      onPressed: onIncrease,
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Kaldır'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text('Ara toplam'),
                PriceText(
                  amount: item.totalCents / 100,
                  currency: product.currency,
                  style: textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
