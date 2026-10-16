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
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.pagePadding),
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
              product.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            PriceText(amount: product.price, currency: product.currency),
          ],
        ),
      ),
    );
  }
}
