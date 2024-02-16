// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_cli_cc/src/code/class/class_snippet.dart';
import 'package:gg_cli_cc/src/code/class/class_test_snippet.dart';
import 'package:gg_cli_cc/src/code/snippets/file_header.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:dart_style/dart_style.dart';

/// Generates a class and tests
class Class extends Command<dynamic> {
  /// Constructor
  Class({
    required this.log,
  }) {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The name of the class, e.g. FooBar',
      mandatory: true,
    );
  }

  @override
  final name = 'class';

  @override
  final description = 'Generates a class and associated tests.';

  @override
  void run() {
    var className = argResults?['name'] as String;
    className = className.camelCase;
    className = className.pascalCase;

    _Class(
      log: log,
      className: className,
    );
  }

  /// The log function
  final void Function(String message) log;
}

// .............................................................................
class _Class {
  _Class({
    required this.log,
    required this.className,
  }) {
    _checkIsInSrcDir();
    _initPathes();
    _checkDoesNotExist();
    _generateClass();
    _generateTest();
  }

  // ...........................................................................
  /// The log function
  final void Function(String message) log;
  final String className;
  final _formatter = DartFormatter();

  late String _workSpaceDir;
  late String _testDir;
  late String _srcDir;
  late String _srcFile;
  late String _srcFileRelativeToSrc;
  late String _testFile;

  // ...........................................................................
  void _checkIsInSrcDir() {
    var dir = Directory.current;
    if (!dir.path.contains('lib/src')) {
      throw Exception('Current directory is not within lib/src directory.');
    }
  }

  // ...........................................................................
  void _checkDoesNotExist() {
    if (File(_srcFile).existsSync()) {
      final relativeFileName = relative(_srcFile, from: _workSpaceDir);
      throw Exception('File $relativeFileName already exists.');
    }
  }

  // ...........................................................................
  void _initPathes() {
    // Init workspace directory
    final workSpaceDir = Directory.current.path.split(join('lib', 'src'))[0];
    final pubspec = File('$workSpaceDir/pubspec.yaml');
    if (!pubspec.existsSync()) {
      throw Exception('No pubspec.yaml file found in current directory.');
    }

    // Init source directory
    final sourceRoot = Directory(join(workSpaceDir, 'lib', 'src'));

    // Init test directory
    final testDir = Directory(join(workSpaceDir, 'test'));
    if (!testDir.existsSync()) {
      throw Exception('No test directory found in workspace.');
    }

    _workSpaceDir = workSpaceDir;
    _srcDir = Directory.current.path;
    final relativeSrcDir = relative(_srcDir, from: sourceRoot.path);
    _testDir = join(testDir.path, relativeSrcDir);

    final classNameSnakeCase = className.snakeCase;
    final srcFileName = '$classNameSnakeCase.dart';
    _srcFile = join(_srcDir, srcFileName);
    _srcFileRelativeToSrc =
        join(relativeSrcDir, srcFileName).replaceAll('/./', '/');
    _testFile = join(_testDir, '${classNameSnakeCase}_test.dart');
  }

  // ...........................................................................
  void _generateClass() {
    var code = '';

    // Add file header
    code += fileHeader;
    code += '\n';
    code += '\n';

    // Add class
    code += classSnippet(className: className);

    // Format code
    code = _formatter.format(code);

    // Write file
    var file = File(_srcFile);
    file.writeAsStringSync(code);
  }

  // ...........................................................................
  void _generateTest() {
    var code = '';

    // Add file header
    code += fileHeader;
    code += '\n';
    code += '\n';

    // Add test
    code += classTestSnippet(
      className: className,
      packageName: basename(_workSpaceDir),
      filePathRelativeToSrc: _srcFileRelativeToSrc,
    );

    // Format code
    try {
      code = _formatter.format(code);
    } catch (e) {
      log('Error formatting test file: $e'); // coverage:ignore-line
    }

    // Create test directory when not exists
    if (!Directory(_testDir).existsSync()) {
      Directory(_testDir).createSync(recursive: true);
    }

    // Write test file
    var file = File(_testFile);
    file.writeAsStringSync(code);
  }
}
