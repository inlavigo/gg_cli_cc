// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

/// Creates a class snippet
String classSnippet({required String className}) => '''

/// $className
class $className {
  /// Constructor
  const $className();

  /// First example function
  bool foo0(bool b) => b;

  /// Second example function
  bool foo1(bool b) => b;

  /// Example instance for test purposes
  static const example = $className();
}
'''
    .trim();
