part of rockdot_generator;

class CommandCommand extends RockdotCommand {
  static final String DEFAULT_COMMAND_NAME = "GeneratedCommand";
  static final String TEMPLATE_COMMAND_FILE = "command.dart";
  static final String PACKAGE_REPLACE_STRING = "@package@";
  static final String COMMAND_REPLACE_STRING = "@command@";

  static final String COMMAND_INSERTION_PLACEHOLDER =
      "// ## COMMAND INSERTION PLACEHOLDER - DO NOT REMOVE ## //";

  static final String DIR_LIB = "lib";
  static final String DIR_PROJECT = "$DIR_LIB/src/project";
  static final String DIR_COMMAND = "$DIR_PROJECT/command";

  String targetPath;
  String commandNameCamelCase;
  String commandNameUnderscored;
  String commandNameUnderscoredUppercase;

  CommandCommand(CliLogger logger, Target writeTarget)
      : super(logger, writeTarget) {
    packageName = _getPackageNameFromPubspec();
    name = "command";
    description = "Create a Command class. Also adds an Event type.";

    argParser.addOption('name',
        abbr: 'n',
        defaultsTo: DEFAULT_COMMAND_NAME,
        help: 'The name (in CamelCase) of the command to be generated.',
        valueHelp: 'name', callback: (_commandName) {
      commandNameCamelCase = _commandName;
    });

    argParser.addOption('target',
        abbr: 't',
        defaultsTo: DIR_COMMAND,
        help: 'The target path of the command to be generated.',
        valueHelp: 'target', callback: (_path) {
      targetPath = _path;
    });
  }
  @override
  void run() async {
    commandNameUnderscored = _getCommandNameUnderscored();
    commandNameUnderscoredUppercase = commandNameUnderscored.toUpperCase();

    String targetFile = join(targetPath, '$commandNameUnderscored.dart');

    // just decode skeletons_data.data["assets.dart"]
    String assetClassFilePath =
        skeletons_data.data.firstWhere((path) => path == TEMPLATE_COMMAND_FILE);

    List<TemplateFile> templates = await decodeConcanenatedData(
        <String>[assetClassFilePath], skeletons_data.type);

    TemplateFile templateFile = templates.first;
    templateFile.path = targetFile;

    //add command from template to DIR_COMMAND
    templateFile.content = templateFile.content
        .replaceAll(new RegExp(COMMAND_REPLACE_STRING), commandNameCamelCase);
    templateFile.content = templateFile.content
        .replaceAll(new RegExp(PACKAGE_REPLACE_STRING), packageName);

    addTemplateFile(templateFile);

    //this writes to templateFile.content
    logger.stdout(
        "Writing Command class '$commandNameCamelCase' to file '$targetFile'.");
    await generate(_getPackageNameFromPubspec());

    //add const to events
    _insertEvent();

    //add class name to package spec $DIR_LIB/$packageName.dart
    _addToPackage();

    //add class to event mapping to $DIR_PROJECT/project.dart
    _insertEventMapping();

    logger.stdout("Done. Command written and registered successfully.");
  }

  void _insertEvent() {
    String replace =
        'static const String $commandNameUnderscoredUppercase = "ProjectEvents.$commandNameUnderscoredUppercase";\n\t$COMMAND_INSERTION_PLACEHOLDER';

    File file = new File("$DIR_COMMAND/event/project_events.dart");
    String fileContent = file.readAsStringSync();
    fileContent = fileContent.replaceFirst(
        new RegExp(COMMAND_INSERTION_PLACEHOLDER), replace);
    file.writeAsStringSync(fileContent);
  }

  /// Adds Command class part to library definition
  void _addToPackage() {
    String replace =
        "part 'src/project/command/$commandNameUnderscored.dart';\n$COMMAND_INSERTION_PLACEHOLDER";

    File file = new File("$DIR_LIB/$packageName.dart");
    String fileContent = file.readAsStringSync();
    fileContent = fileContent.replaceFirst(
        new RegExp(COMMAND_INSERTION_PLACEHOLDER), replace);
    file.writeAsStringSync(fileContent);
  }

  /// Adds an entry to 'project.dart' mapping the Event to the Command
  void _insertEventMapping() {
    //parses to: commandMap[ProjectEvents.APP_INIT] = () => new InitCommand();
    String replace =
        'commandMap[ProjectEvents.$commandNameUnderscoredUppercase] = () => new $commandNameCamelCase();\n\t\t$COMMAND_INSERTION_PLACEHOLDER';

    File file = new File("$DIR_PROJECT/project.dart");
    String fileContent = file.readAsStringSync();
    fileContent = fileContent.replaceFirst(
        new RegExp(COMMAND_INSERTION_PLACEHOLDER), replace);
    file.writeAsStringSync(fileContent);
  }

  String _getCommandNameUnderscored() {
    return commandNameCamelCase
        .replaceAllMapped(new RegExp("([^A-Z-])([A-Z])"),
            (Match m) => (m.group(1) + "_" + m.group(2)))
        .toLowerCase();
  }
}
