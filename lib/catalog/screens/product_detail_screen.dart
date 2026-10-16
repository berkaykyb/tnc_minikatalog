import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../shared/widgets/price_text.dart';
import '../models/product.dart';
import '../widgets/product_image.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ürün detayı')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 668),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppTheme.pagePadding,
              16,
              AppTheme.pagePadding,
              MediaQuery.paddingOf(context).bottom + AppTheme.sectionGap,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ProductImage(assetPath: product.imageAsset),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  product.category,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppTheme.accent,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(product.name, style: textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text(product.shortDescription, style: textTheme.bodyLarge),
                const SizedBox(height: 16),
                PriceText(
                  amount: product.price,
                  currency: product.currency,
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppTheme.accent,
                  ),
                ),
                const SizedBox(height: AppTheme.sectionGap),
                Text('Ürün hakkında', style: textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(product.description, style: textTheme.bodyLarge),
                if (product.specifications.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.sectionGap),
                  Text('Özellikler', style: textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _Specifications(values: product.specifications),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Specifications extends StatelessWidget {
  const _Specifications({required this.values});

  final Map<String, String> values;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final largeText = MediaQuery.textScalerOf(context).scale(14) > 20;
        final columns = largeText || constraints.maxWidth < 280
            ? 1
            : constraints.maxWidth >= 540
            ? 3
            : 2;
        final width = (constraints.maxWidth - (columns - 1) * 12) / columns;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final entry in values.entries)
              Container(
                width: width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: textTheme.labelSmall?.copyWith(letterSpacing: 0),
                    ),
                    const SizedBox(height: 8),
                    Text(entry.value, style: textTheme.titleMedium),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
