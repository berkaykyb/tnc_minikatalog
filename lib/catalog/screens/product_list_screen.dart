import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({
    super.key,
    required this.products,
    this.onProductSelected,
  });

  final List<Product> products;
  final ValueChanged<Product>? onProductSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Katalog')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 668),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.pagePadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Tüm ürünler',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('${products.length} parça, günlük rutinin için.'),
                const SizedBox(height: 24),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final scaler = MediaQuery.textScalerOf(context);
                      final columns =
                          constraints.maxWidth < 280 || scaler.scale(16) > 21
                          ? 1
                          : 2;
                      final imageSize =
                          (constraints.maxWidth - (columns - 1) * 12) / columns;
                      final textHeight =
                          scaler.scale(16) * 1.35 * 3 +
                          scaler.scale(14) * 1.5 * 2 +
                          48;

                      return GridView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          mainAxisExtent: imageSize + textHeight,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: onProductSelected == null
                                ? null
                                : () => onProductSelected!(product),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
