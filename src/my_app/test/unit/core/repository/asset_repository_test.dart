// ignore_for_file: prefer-match-file-name

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_core/core/data/repository/asset_repository.dart';
import 'package:very_good_core/core/domain/interface/i_asset_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(AssetRepository, () {
    late AssetRepository assetRepository;

    setUp(() {
      assetRepository = AssetRepository();
    });

    test('can be instantiated', () {
      expect(assetRepository, isNotNull);
      expect(assetRepository, isA<IAssetRepository>());
    });

    test('preloadSVGs completes successfully when no assets', () async {
      await expectLater(assetRepository.preloadSVGs(), completes);
    });

    test('preloadSVGs caches assets correctly', () async {
      bool mockCalled = false;
      final FakeAssetRepository fakeAssetRepository = FakeAssetRepository();

      // Mock the asset loading
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', (
        ByteData? message,
      ) async {
        mockCalled = true;
        final Uint8List svgBytes = Uint8List.fromList(
          utf8.encode('<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="5"/></svg>'),
        );
        return ByteData.view(svgBytes.buffer);
      });

      try {
        await expectLater(fakeAssetRepository.preloadSVGs(), completes);

        // Verify the mock was called (assets were loaded)
        expect(mockCalled, isTrue, reason: 'Asset should have been loaded via binary messenger');
      } finally {
        // Clean up
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
      }
    });
  });
}

class FakeAssetRepository extends AssetRepository {
  @override
  List<String> getSvgAssets() => <String>['assets/test.svg'];
}
