part of acanvas_generator;

class AcanvasCommandRunner extends CommandRunner {
  AcanvasCommandRunner(CliLogger logger, Target writeTarget)
      : super('acanvas_generator',
            'A CLI to generate acanvas projects and other elements.') {
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
