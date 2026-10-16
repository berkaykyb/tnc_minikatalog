import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      cacheWidth: 1024,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: AppTheme.border,
        child: Center(
          child: Semantics(
            label: 'Ürün görseli bulunamadı',
            child: const Icon(Icons.image_not_supported_outlined, size: 32),
          ),
        ),
      ),
    );
  }
}
