// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_cli_cc/src/code/class/class_snippet.dart';
import 'package:test/test.dart';

void main() {
  group('ClassSnippet', () {
    test('should work fine', () {
      expect(
        classSnippet(className: 'HelloWorld'),
        contains('class HelloWorld {'),
      );
    });
  });
}
