import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

class CatalogBanner extends StatelessWidget {
  const CatalogBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 224,
          minWidth: double.infinity,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/products/homepod.png',
                fit: BoxFit.cover,
                alignment: const Alignment(0.3, 0.1),
                cacheWidth: 1240,
                excludeFromSemantics: true,
                errorBuilder: (context, error, stackTrace) =>
                    const ColoredBox(color: AppTheme.ink),
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xE620252B), Color(0x4420252B)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'MASANA BİR MOLA',
                    style: textTheme.labelSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Masanın bir\nritmi olsun.',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'İyi ses, iyi bir başlangıç.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFECECE8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
