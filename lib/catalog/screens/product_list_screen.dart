import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../cart/widgets/cart_button.dart';
import '../../shared/widgets/empty_state.dart';
import '../catalog_filter.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({
    super.key,
    required this.products,
    this.onProductSelected,
  });

  final List<Product> products;
  final ValueChanged<Product>? onProductSelected;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _query = '';
  String? _category;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _resetScroll() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _search(String query) {
    _resetScroll();
    setState(() => _query = query);
  }

  void _selectCategory(String? category) {
    _resetScroll();
    setState(() => _category = category);
  }

  void _clearFilters() {
    _searchController.clear();
    _resetScroll();
    setState(() {
      _query = '';
      _category = null;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final products = filterProducts(
      widget.products,
      query: _query,
      category: _category,
    );
    final categories = widget.products
        .map((product) => product.category)
        .toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog'),
        actions: const [CartButton(), SizedBox(width: 12)],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 668),
          child: SingleChildScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              AppTheme.pagePadding,
              16,
              AppTheme.pagePadding,
              MediaQuery.paddingOf(context).bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tüm ürünler',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('Günlük rutinine göre bir şeyler seç.'),
                const SizedBox(height: 24),
                TextField(
                  controller: _searchController,
                  onChanged: _search,
                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    labelText: 'Ürün ara',
                    hintText: 'Ürün adı yaz',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Aramayı temizle',
                            onPressed: () {
                              _searchController.clear();
                              _search('');
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _categoryChip('Tümü', null),
                      for (final category in categories)
                        _categoryChip(category, category),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    '${products.length} ürün bulundu',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
                if (products.isEmpty)
                  EmptyState(
                    title: widget.products.isEmpty
                        ? 'Henüz ürün yok.'
                        : 'Bir eşleşme bulamadık.',
                    message: widget.products.isEmpty
                        ? 'Ürünler eklendiğinde burada görünecek.'
                        : 'Başka bir ürün adı yazabilir veya filtreleri temizleyebilirsin.',
                    actionLabel: _query.isNotEmpty || _category != null
                        ? 'Filtreleri temizle'
                        : null,
                    onAction: _query.isNotEmpty || _category != null
                        ? _clearFilters
                        : null,
                  )
                else
                  LayoutBuilder(
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
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                            onTap: widget.onProductSelected == null
                                ? null
                                : () => widget.onProductSelected!(product),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(String label, String? category) {
    final selected = _category == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppTheme.accent,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(color: selected ? Colors.white : AppTheme.ink),
        side: BorderSide(color: selected ? AppTheme.accent : AppTheme.border),
        onSelected: (_) => _selectCategory(category),
      ),
    );
  }
}
