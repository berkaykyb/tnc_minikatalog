import 'package:flutter/material.dart';

import '../catalog/data/product_repository.dart';
import '../catalog/screens/home_screen.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class MiniKatalogApp extends StatelessWidget {
  const MiniKatalogApp({super.key, this.repository});

  final ProductRepository? repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Katalog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: HomeScreen(repository: repository),
      onGenerateRoute: AppRoutes.generate,
    );
  }
}
