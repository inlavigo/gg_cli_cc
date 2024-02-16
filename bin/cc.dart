#!/usr/bin/env dart
// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:args/command_runner.dart';
import 'package:gg_cli_cc/gg_cli_cc.dart';
import 'package:colorize/colorize.dart';

// #############################################################################
Future<void> generateCode(List<String> arguments) async {
  try {
    final r = CommandRunner<dynamic>(
      'aud',
      'Our cli to create various kind of code snippets.',
    )..addCommand(GenerateCode(log: print));

    await r.run(arguments);
  } catch (e) {
    final msg = e.toString().replaceAll('Exception: ', '');
    print(Colorize(msg).red());
  }
}

// .............................................................................
Future<void> main(List<String> arguments) async {
  await generateCode(arguments);
}
