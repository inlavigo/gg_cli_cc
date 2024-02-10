// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:aud_cli_gc/src/tools/string_tools.dart';

/// Creates a class snippet
String classTestSnippet({
  required String className,
  required String packageName,
  required String filePathRelativeToSrc,
}) =>
    '''
import 'package:$packageName/src/$filePathRelativeToSrc';
import 'package:test/test.dart';

void main() {
  const ${className.firstLetterLowerCase} = $className.example;

  group('$className', () {

    // #########################################################################
    group('foo0(b)',(){

      // .......................................................................
      group('should return', (){

        // .....................................................................
        test('true for b == true', () {
          expect(${className.firstLetterLowerCase}.foo0(true), isTrue);
        });

        // .....................................................................
        test('false for b == false', () {
          expect(${className.firstLetterLowerCase}.foo0(false), isFalse);
        });
      });
    });


    // #########################################################################
    group('foo1(b)',(){

      // .......................................................................
      group('should return', (){

        // .....................................................................
        test('true for b == true', () {
          expect(${className.firstLetterLowerCase}.foo1(true), isTrue);
        });

        // .....................................................................
        test('false for b == false', () {
          expect(${className.firstLetterLowerCase}.foo1(false), isFalse);
        });
      });
    });
  });
}
'''
        .trim();
