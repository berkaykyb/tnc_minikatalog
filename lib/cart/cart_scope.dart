import 'package:flutter/widgets.dart';

import '../catalog/models/product.dart';
import 'models/cart_item.dart';

class CartScope extends InheritedWidget {
  CartScope({
    super.key,
    required List<CartItem> items,
    required this.onAdd,
    required this.onDecrease,
    required this.onRemove,
    required super.child,
  }) : items = List.unmodifiable(items);

  final List<CartItem> items;
  final ValueChanged<Product> onAdd;
  final ValueChanged<int> onDecrease;
  final ValueChanged<int> onRemove;

  int get quantity => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, int> get totalsByCurrency {
    final totals = <String, int>{};
    for (final item in items) {
      totals.update(
        item.product.currency,
        (amount) => amount + item.totalCents,
        ifAbsent: () => item.totalCents,
      );
    }
    return Map.unmodifiable(totals);
  }

  static CartScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CartScope>();

  static CartScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'CartScope is missing');
    return scope!;
  }

  @override
  bool updateShouldNotify(CartScope oldWidget) => items != oldWidget.items;
}
