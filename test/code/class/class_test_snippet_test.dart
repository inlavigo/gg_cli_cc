// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_cli_cc/src/code/class/class_test_snippet.dart';
import 'package:test/test.dart';

void main() {
  group('ClassTestSnippet', () {
    test('should work fine', () {
      final snippet = classTestSnippet(
        className: 'ClassName',
        packageName: 'package_name',
        filePathRelativeToSrc: 'file_path_relative_to_src',
      );

      expect(
        snippet,
        contains(
          'import \'package:package_name/src/file_path_relative_to_src\';',
        ),
      );

      expect(snippet, contains('final className = ClassName.example;'));
      expect(snippet, contains('group(\'ClassName\', () {'));
    });
  });
}
