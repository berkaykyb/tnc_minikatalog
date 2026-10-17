import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../app/app_routes.dart';
import '../../cart/cart_scope.dart';
import '../../cart/widgets/cart_button.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/catalog_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.repository, this.loadProducts});

  final ProductRepository? repository;
  final Future<List<Product>> Function()? loadProducts;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductRepository _repository;
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ProductRepository();
    _products = _loadProducts();
  }

  Future<List<Product>> _loadProducts() =>
      widget.loadProducts?.call() ?? _repository.loadProducts();

  void _reload() {
    final request = _loadProducts();
    setState(() {
      _products = request;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.pagePadding,
            20,
            AppTheme.pagePadding,
            AppTheme.sectionGap,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BrandHeader(),
                  const SizedBox(height: AppTheme.sectionGap),
                  Text(
                    'Çalışma alanına\niyi gelenler.',
                    style: textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Her gün kullandığın şeylere biraz daha özen.',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  const CatalogBanner(),
                  const SizedBox(height: AppTheme.sectionGap),
                  FutureBuilder<List<Product>>(
                    future: _products,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const _LoadingCatalog();
                      }
                      if (snapshot.hasError) {
                        return _CatalogError(onRetry: _reload);
                      }
                      final products = snapshot.data ?? [];
                      if (products.isEmpty) {
                        return const _EmptyCatalog();
                      }
                      return _CatalogPreview(products: products);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.accent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.space_dashboard_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            'Mini Katalog',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: 12),
        if (CartScope.maybeOf(context) != null)
          const CartButton()
        else
          Flexible(
            child: Text(
              'SEÇKİ / 01',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: AppTheme.accent, letterSpacing: 1),
            ),
          ),
      ],
    );
  }
}

class _CatalogPreview extends StatelessWidget {
  const _CatalogPreview({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final categoryCount = products
        .map((product) => product.category)
        .toSet()
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seçkiden ilk bakış', style: textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          '${products.length} ürün, $categoryCount farklı kategori.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        for (final product in products.take(3))
          _ProductPreview(product: product),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () =>
                Navigator.of(context)
                    .pushNamed(AppRoutes.catalog, arguments: products),
            icon: const Icon(Icons.grid_view_rounded),
            label: const Text('Tüm ürünleri gör'),
          ),
        ),
      ],
    );
  }
}

class _ProductPreview extends StatelessWidget {
  const _ProductPreview({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () =>
          Navigator.of(context)
              .pushNamed(AppRoutes.productDetail, arguments: product),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                product.imageAsset,
                width: 76,
                height: 76,
                cacheWidth: 228,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 76,
                  height: 76,
                  child: ColoredBox(
                    color: AppTheme.border,
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(product.shortDescription, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingCatalog extends StatelessWidget {
  const _LoadingCatalog();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 16),
          Expanded(child: Text('Seçki hazırlanıyor...')),
        ],
      ),
    );
  }
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seçki yüklenemedi.', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('Bir kez daha deneyebilirsin.', style: textTheme.bodyMedium),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Tekrar dene'),
        ),
      ],
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Seçki henüz hazır değil.', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Ürünler eklendiğinde burada görünecek.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
