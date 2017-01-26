// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library rockdot_generator.cli;

import 'dart:io' as io;

import 'package:rockdot_generator/rockdot_generator.dart';
import 'package:rockdot_generator/src/cli_app.dart';

void main(List<String> args) {
  CliApp app = new CliApp(generators, new CliLogger());

  try {
    app.process(args).catchError((e, st) {
      if (e is ArgError) {
        // These errors are expected.
        io.exit(1);
      } else {
        print('Unexpected error: ${e}\n${st}');
          io.exit(1);
      }
    }).whenComplete(() {
      // Always exit quickly after performing work. If the user has opted into
      // analytics, the analytics I/O can cause the CLI to wait to terminate.
      // This is annoying to the user, as the tool has already completed its
      // work from their perspective.
      io.exit(0);
    });
  } catch (e, st) {
    print('Unexpected error: ${e}\n${st}');
  }
}
