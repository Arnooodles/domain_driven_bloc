import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const String svgStr = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <circle cx="12" cy="12" r="10" />
  <line x1="12" y1="8" x2="12" y2="16" />
  <line x1="8" y1="12" x2="16" y2="12" />
</svg>''';

class MockAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async => svgStr;

  @override
  Future<ByteData> load(String key) async => Uint8List.fromList(utf8.encode(svgStr)).buffer.asByteData();
}
