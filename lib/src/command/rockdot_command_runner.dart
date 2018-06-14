part of rockdot_generator;

class RockdotCommandRunner extends CommandRunner {
  RockdotCommandRunner(CliLogger logger, Target writeTarget)
      : super('rockdot_generator',
            'A CLI to generate rockdot projects and other elements.') {
    // Flags

    argParser.addFlag('override',
        negatable: false,
        help: 'Disable write protection for non-empty directories or files.');

    // Options

    argParser.addOption('author',
        defaultsTo: '<your name>',
        help: 'The author name to use for file headers.');

    // Commands

    addCommand(new ProjectCommand(logger, writeTarget));
    addCommand(new AssetCommand(logger, writeTarget));
    addCommand(new CommandCommand(logger, writeTarget));
    addCommand(new ScreenCommand(logger, writeTarget));
    addCommand(new ElementCommand(logger, writeTarget));
    addCommand(new PluginCommand(logger, writeTarget));
  }
}

class ArgError implements Exception {
  final String message;

  ArgError(this.message);

  String toString() => message;
}
