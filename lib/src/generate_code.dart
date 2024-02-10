// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:args/command_runner.dart';
import 'package:aud_cli_gc/src/code/code.dart';

/// Generates code
class GenerateCode extends Command<dynamic> {
  /// Constructor
  GenerateCode({
    required this.log,
  }) {
    addSubcommand(Class(log: log));
  }

  @override
  final name = 'gc';

  @override
  final description = 'Generate code.';

  // ...........................................................................
  /// The log function
  final void Function(String message) log;
}
