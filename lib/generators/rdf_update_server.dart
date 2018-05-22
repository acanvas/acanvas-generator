import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import '../src/common.dart';

final String SERVER_DIR = "server";

final String DEFAULT_MODE = "debug";
String mode = DEFAULT_MODE;

void main(List<String> args) {
  _setupArgs(args);

  setupProperties(mode);

  String source = path.join(SERVER_DIR, 'source');
  String target = path.join(SERVER_DIR, 'target');
  recursiveFolderCopySync(source, target);
}

/// Manages the script's arguments and provides instructions and defaults for the --help option.
void _setupArgs(List<String> args) {
  ArgParser argParser = new ArgParser();

  argParser.addOption('mode',
      abbr: 'm',
      defaultsTo: DEFAULT_MODE,
      help:
          'The configuration mode to use. Can be either debug or release. Defaults to debug.',
      valueHelp: 'mode', callback: (_mode) {
    mode = _mode;
  });

  argParser.addFlag('help', negatable: false, help: 'Displays the help.',
      callback: (help) {
    if (help) {
      print(argParser.usage);
      exit(1);
    }
  });

  argParser.parse(args);
}
