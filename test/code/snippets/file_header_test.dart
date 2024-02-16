// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_cli_cc/src/code/snippets/file_header.dart';
import 'package:test/test.dart';

void main() {
  group('FileHeader', () {
    test('should work fine', () {
      final year = fileHeaderYear();

      expect(fileHeader, contains('2019 - $year'));
    });
  });
}
