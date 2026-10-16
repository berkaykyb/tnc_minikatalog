import 'package:flutter/material.dart';

String formatPrice(double amount, String currency) {
  if (!amount.isFinite || amount < 0) {
    throw ArgumentError.value(amount, 'amount', 'Invalid price');
  }
  final cents = (amount * 100).round();
  final whole = (cents ~/ 100).toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]}.',
  );
  final fraction = cents % 100;
  final number = fraction == 0
      ? whole
      : '$whole,${fraction.toString().padLeft(2, '0')}';
  const symbols = {'USD': r'$', 'TRY': '₺', 'EUR': '€', 'GBP': '£'};
  final symbol = symbols[currency];
  return symbol == null ? '$number $currency' : '$symbol$number';
}

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.amount,
    required this.currency,
    this.style,
  });

  final double amount;
  final String currency;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatPrice(amount, currency),
      style: style ?? Theme.of(context).textTheme.titleMedium,
    );
  }
}
