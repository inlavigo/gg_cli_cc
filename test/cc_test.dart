// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:async';

import 'package:test/test.dart';

import '../bin/cc.dart';

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
    await Zone.current.fork(specification: zoneSpecification).run(
          () async => generateCode(args),
        );
  }

  group('gg', () {
    // #########################################################################
    group('cc', () {
      // #######################################################################
      group('without arguments', () {
        test('should print "Missing subcommand for "aud cc""', () async {
          await exec(['cc']);
          expect(messages.last, contains('Missing subcommand for "aud cc"'));
        });
      });

      // #######################################################################
      group('class', () {
        // .....................................................................
        test('should throw if no class name is given"', () async {
          await exec(['cc', 'class']);
          expect(messages.last, contains('Option name is mandatory'));
        });
      });
    });
  });
}
