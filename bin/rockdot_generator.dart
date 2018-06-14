// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library rockdot_generator.cli;

import 'package:args/command_runner.dart';
import 'package:rockdot_generator/rockdot_generator.dart';

void main(List<String> args) {
  CommandRunner runner =
      new RockdotCommandRunner(new CliLogger(), new FileTarget());
  runner.run(args);
}
