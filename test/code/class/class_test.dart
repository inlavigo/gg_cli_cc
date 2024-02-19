// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_cli_cc/src/code/code.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  // ...........................................................................
  late Directory targetDir;
  late Directory tmpDir;
  late Directory workSpaceDir;
  final messages = <String>[];

  // ...........................................................................
  setUp(() {
    messages.clear();
  });

  // ...........................................................................
  void setupDirectories({
    bool createPubSpec = true,
    bool createTestDir = true,
  }) {
    tmpDir = Directory.systemTemp;
    final package = Directory(join(tmpDir.path, 'aud_test'));
    if (package.existsSync()) {
      package.deleteSync(recursive: true);
    }
    package.createSync();

    final lib = Directory(join(package.path, 'lib'))..createSync();
    final src = Directory(join(lib.path, 'src'))..createSync();
    final a = Directory(join(src.path, 'a'))..createSync();
    final b = Directory(join(a.path, 'b'))..createSync();
    final c = Directory(join(b.path, 'c'))..createSync();

    if (createTestDir) {
      Directory(join(package.path, 'test')).createSync();
    }

    if (createPubSpec) {
      File(join(package.path, 'pubspec.yaml'))
        ..createSync()
        ..writeAsStringSync('name: package');
    }

    workSpaceDir = package;
    targetDir = c;
  }

  // ...........................................................................
  Future<void> exec(List<String> args) async {
// Run class
    final c = Class(log: messages.add);
    expect(c.name, 'class');
    expect(c.description, 'Generates a class and associated tests.');

    final r = CommandRunner<dynamic>('cc', 'des')..addCommand(c);
    try {
      await r.run(args);
    } catch (e) {
      messages.add(e.toString());
    }
  }

  group('Class', () {
    // #######################################################################

    // .....................................................................
    test('should throw if no class name is given"', () async {
      await exec(['class']);
      expect(messages.last, contains('Option name is mandatory'));
    });

    // .....................................................................
    test('should throw if current directory is within lib/src directory',
        () async {
      setupDirectories();
      Directory.current = tmpDir;

      // Class file already exists
      await exec(['class', '-n', 'MyClass']);
      expect(
        messages.last,
        contains('Current directory is not within lib/src'),
      );
    });

    // .....................................................................
    test('should throw if no pubspec.yaml is found, (){}', () async {
      setupDirectories(createPubSpec: false);

      // Change into lib/src/a/b/c
      Directory.current = targetDir;

      await exec(['class', '-n', 'MyClass']);
      expect(
        messages.last,
        contains('pubspec.yaml file found in current directory'),
      );
    });

    // .....................................................................
    test('should throw if no test direcotry is found, (){}', () async {
      setupDirectories(createTestDir: false);

      // Change into lib/src/a/b/c
      Directory.current = targetDir;

      await exec(['class', '-n', 'MyClass']);
      expect(
        messages.last,
        contains('No test directory found in workspace'),
      );
    });

    // .....................................................................
    test('should throw if class already exists, (){}', () async {
      setupDirectories();
      // Change into lib/src/a/b/c
      Directory.current = targetDir;

      // Class file already exists
      File(join(targetDir.path, 'my_class.dart'))
        ..createSync()
        ..writeAsStringSync('// MyClass');

      await exec(['class', '-n', 'MyClass']);
      expect(
        messages.last,
        contains('lib/src/a/b/c/my_class.dart already exists'),
      );
    });

    // .....................................................................
    for (final className in [
      'my_class',
      'My_class',
      'MyClass',
      'myClass',
    ]) {
      test('should create test and implementation file, (){}', () async {
        setupDirectories();
        // Change into lib/src/a/b/c
        Directory.current = targetDir;

        // Create class
        await exec(['class', '-n', className]);

        // ........
        // Test file
        final testFile =
            File(join(workSpaceDir.path, 'test/a/b/c/my_class_test.dart'));
        expect(testFile.existsSync(), isTrue);

        // Header exists
        final testFileContent = testFile.readAsStringSync();
        final currentYear = DateTime.now().year;

        expect(
          testFileContent,
          contains(
            '// Copyright (c) 2019 - $currentYear Dr. Gabriel Gatzsche',
          ),
        );

        // File under test is imported
        expect(
          testFileContent,
          contains(
            'final myClass = MyClass.example;',
          ),
        );

        // File under test is imported
        expect(
          testFileContent,
          contains(
            "import 'package:aud_test/src/a/b/c/my_class.dart';",
          ),
        );

        // ...................
        // Implementation file
        final srcFile = File(join(targetDir.path, 'my_class.dart'));
        expect(srcFile.existsSync(), isTrue);

        // Header exists
        final srcFileContent = srcFile.readAsStringSync();
        expect(
          srcFileContent,
          contains(
            '// Copyright (c) 2019 - $currentYear Dr. Gabriel Gatzsche',
          ),
        );
      });
    }
  });
}
