// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:recase/recase.dart';

/// Creates a class snippet
String classTestSnippet({
  required String className,
  required String packageName,
  required String filePathRelativeToSrc,
}) =>
    '''
// import 'package:$packageName/src/$filePathRelativeToSrc';
import 'package:test/test.dart';

void main() {
  final ${className.camelCase} = $className.example;

  group('$className', () {

    // #########################################################################
    group('example',(){

      // .......................................................................
      test('true for b == true', () {
        // expect(${className.camelCase}, isNotNull);
      });
    });
  });
}
'''
        .trim();
