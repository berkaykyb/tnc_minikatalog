import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tnc_minikatalog/catalog/data/product_repository.dart';

import '../fixtures/product_fixture.dart';

class _ProductBundle extends CachingAssetBundle {
  _ProductBundle(this.content);

  String? content;

  @override
  Future<ByteData> load(String key) async {
    if (key != 'assets/data/products.json' || content == null) {
      throw StateError('Asset is unavailable');
    }
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(content!)));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads eight unique products with decodable bundled images', () async {
    final products = await ProductRepository().loadProducts();

    expect(products, hasLength(8));
    expect(products.map((product) => product.id).toSet(), hasLength(8));
    for (final product in products) {
      final bytes = await rootBundle.load(product.imageAsset);
      final codec = await ui.instantiateImageCodec(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      );
      final frame = await codec.getNextFrame();
      expect(frame.image.width, greaterThan(0));
      expect(frame.image.height, greaterThan(0));
      frame.image.dispose();
      codec.dispose();
    }
    expect(() => products.clear(), throwsUnsupportedError);
  });

  test('rejects malformed JSON and invalid list entries', () async {
    for (final content in ['{', '{}', '[null]']) {
      final repository = ProductRepository(bundle: _ProductBundle(content));
      await expectLater(
        repository.loadProducts(),
        throwsA(isA<ProductLoadException>()),
      );
    }
  });

  test('rejects duplicate product identifiers', () async {
    final content = jsonEncode([productJson(), productJson()]);
    final repository = ProductRepository(bundle: _ProductBundle(content));

    await expectLater(
      repository.loadProducts(),
      throwsA(isA<ProductLoadException>()),
    );
  });

  test('can retry after the bundle becomes available', () async {
    final bundle = _ProductBundle(null);
    final repository = ProductRepository(bundle: bundle);

    await expectLater(
      repository.loadProducts(),
      throwsA(isA<ProductLoadException>()),
    );
    bundle.content = jsonEncode([productJson()]);

    expect(await repository.loadProducts(), hasLength(1));
  });

  test('accepts an empty catalog', () async {
    final repository = ProductRepository(bundle: _ProductBundle('[]'));

    expect(await repository.loadProducts(), isEmpty);
  });
}
