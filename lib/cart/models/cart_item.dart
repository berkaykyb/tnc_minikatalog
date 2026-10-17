import '../../catalog/models/product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1}) {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'Must be positive');
    }
  }

  final Product product;
  final int quantity;

  int get totalCents => (product.price * 100).round() * quantity;

  CartItem withQuantity(int quantity) =>
      CartItem(product: product, quantity: quantity);
}
