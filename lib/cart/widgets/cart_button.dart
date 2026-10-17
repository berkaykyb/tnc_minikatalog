import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../cart_scope.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.maybeOf(context);
    if (cart == null) return const SizedBox.shrink();

    return IconButton(
      tooltip: 'Sepet (${cart.quantity} ürün)',
      onPressed: () {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.of(context).pushNamed(AppRoutes.cart);
      },
      icon: Badge.count(
        count: cart.quantity,
        isLabelVisible: cart.quantity > 0,
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
