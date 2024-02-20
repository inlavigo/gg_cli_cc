// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_cli_cc/gg_cli_cc.dart';
import 'package:test/test.dart';

void main() {
  group('GenerateCode', () {
    test('should work fine', () {
      final messages = <String>[];
      final generateCode = GenerateCode(log: messages.add);
      expect(generateCode.name, 'cc');
      expect(generateCode.description, 'Create code.');
    });
  });
}
