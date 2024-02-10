// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:test/test.dart';

import '../bin/aud.dart';

void main() {
  // ...........................................................................
  final messages = <String>[];
  final zoneSpecification = ZoneSpecification(
    print: (_, __, ___, String msg) {
      messages.add(msg);
    },
  );

  // ...........................................................................
  setUp(() {
    messages.clear();
  });

  // ...........................................................................
  Future<void> exec(List<String> args) async {
    Zone.current.fork(specification: zoneSpecification).run(
          () async => generateCode(args),
        );
  }

  // ...........................................................................
  late Directory targetDir;
  late Directory tmpDir;
  late Directory workSpaceDir;

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

  group('aud', () {
    // #########################################################################
    group('gc', () {
      // #######################################################################
      group('without arguments', () {
        test('should print "Missing subcommand for "aud gc""', () async {
          await exec(['gc']);
          expect(messages.last, contains('Missing subcommand for "aud gc"'));
        });
      });

      // #######################################################################
      group('class', () {
        // .....................................................................
        test('should throw if no class name is given"', () async {
          await exec(['gc', 'class']);
          expect(messages.last, contains('Option name is mandatory'));
        });

        // .....................................................................
        test('should throw if current directory is within lib/src directory',
            () async {
          setupDirectories();
          Directory.current = tmpDir;

          // Class file already exists
          await exec(['gc', 'class', '-n', 'MyClass']);
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

          await exec(['gc', 'class', '-n', 'MyClass']);
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

          await exec(['gc', 'class', '-n', 'MyClass']);
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

          await exec(['gc', 'class', '-n', 'MyClass']);
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
            await exec(['gc', 'class', '-n', className]);

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
                'const myClass = MyClass.example;',
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
    });
  });
}
