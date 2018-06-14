part of rockdot_generator;

class ScreenCommand extends RockdotCommand {
  static final String DEFAULT_SCREEN_NAME = "GeneratedScreen";
  static final String DEFAULT_SCREEN_URL = "/generated-screen";

  static final String TEMPLATE_SCREEN_FILE = "screen.dart";
  static final String PACKAGE_REPLACE_STRING = "@package@";
  static final String SCREEN_REPLACE_STRING = "@screen@";

  static final String DIR_LIB = "lib";
  static final String DIR_PROJECT = "$DIR_LIB/src/project";
  static final String DIR_SCREEN = "$DIR_PROJECT/view/screen";
  static final String DIR_PROPERTIES = "$DIR_LIB/config/locale/en";

  static final String SCREEN_INSERTION_PLACEHOLDER =
      "// ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //";
  static final String SCREEN_PROPERTIES_PLACEHOLDER =
      "## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ##";

  String targetPath;
  String screenUrl;
  String screenNameDashed;
  String screenNameCamelCase;
  String screenNameUnderscored;
  String screenNameUnderscoredUppercase;

  ScreenCommand(CliLogger logger, Target writeTarget)
      : super(logger, writeTarget) {
    packageName = _getPackageNameFromPubspec();
    name = "screen";
    description =
        "Create a Screen class. Also adds Properties and registration to Context.";

    argParser.addOption('name',
        abbr: 'n',
        defaultsTo: DEFAULT_SCREEN_NAME,
        help: 'The name (in CamelCase) of the screen to be generated.',
        valueHelp: 'name', callback: (_commandName) {
      screenNameCamelCase = _commandName;
    });

    argParser.addOption('target',
        abbr: 't',
        defaultsTo: DIR_SCREEN,
        help: 'The target path of the screen to be generated.',
        valueHelp: 'target', callback: (_path) {
      targetPath = _path;
    });

    argParser.addOption('url',
        abbr: 'u',
        defaultsTo: DEFAULT_SCREEN_URL,
        help: 'The rockdot-url of the screen to be generated.',
        valueHelp: 'url', callback: (_url) {
      screenUrl = _url;
    });
  }

  @override
  void run() async {
    screenNameDashed = _getDashed();
    screenNameUnderscored = _getUnderscored();
    screenNameUnderscoredUppercase = screenNameUnderscored.toUpperCase();

    String targetFile = join(targetPath, '$screenNameUnderscored.dart');
    screenUrl =
        screenUrl == DEFAULT_SCREEN_URL ? '/$screenNameDashed' : screenUrl;

    // just decode skeletons_data.data["assets.dart"]
    String assetClassFilePath =
        skeletons_data.data.firstWhere((path) => path == TEMPLATE_SCREEN_FILE);

    List<TemplateFile> templates = await decodeConcanenatedData(
        <String>[assetClassFilePath], skeletons_data.type);

    TemplateFile templateFile = templates.first;
    templateFile.path = targetFile;

    //add command from template to DIR_COMMAND
    templateFile.content = templateFile.content
        .replaceAll(new RegExp(SCREEN_REPLACE_STRING), screenNameCamelCase);
    templateFile.content = templateFile.content
        .replaceAll(new RegExp(PACKAGE_REPLACE_STRING), packageName);

    addTemplateFile(templateFile);

    //this writes to templateFile.content
    logger.stdout(
        "Writing Screen class '$screenNameCamelCase' to file '$targetFile'.");
    await generate(_getPackageNameFromPubspec());

    //add const to events
    _insertProperties();

    //add class name to package spec $DIR_LIB/$packageName.dart
    _addToPackage();

    //add id to $DIR_PROJECT/model/screen_ids.dart
    _registerScreenID();

    //add class to event mapping to $DIR_PROJECT/project.dart
    _registerScreen();

    logger
        .stdout("Done. You can now access your new screen at URL #$screenUrl");
  }

  void _insertProperties() {
    String replace = '''##############################
### Screen: $screenNameUnderscoredUppercase
##############################
screen.$screenNameUnderscored.url = $screenUrl
screen.$screenNameUnderscored.title = $screenNameCamelCase
screen.$screenNameUnderscored.headline = Hello World.

$SCREEN_PROPERTIES_PLACEHOLDER
''';

    String path = "$DIR_PROPERTIES/en.properties";

    File file = new File(path);
    String fileContent = file.readAsStringSync();
    fileContent = fileContent.replaceFirst(
        new RegExp(SCREEN_PROPERTIES_PLACEHOLDER), replace);
    file.writeAsStringSync(fileContent);
  }

  void _addToPackage() {
    String replace =
        "part 'src/project/view/screen/$screenNameUnderscored.dart';\n$SCREEN_INSERTION_PLACEHOLDER";

    File file = new File("$DIR_LIB/$packageName.dart");
    String fileContent = file.readAsStringSync();
    fileContent = fileContent.replaceFirst(
        new RegExp(SCREEN_INSERTION_PLACEHOLDER), replace);
    file.writeAsStringSync(fileContent);
  }

  void _registerScreenID() {
    String replace =
        'static const String $screenNameUnderscoredUppercase = "screen.$screenNameUnderscored";\n\t$SCREEN_INSERTION_PLACEHOLDER';

    File file = new File("$DIR_PROJECT/model/screen_ids.dart");
    String fileContent = file.readAsStringSync();
    fileContent = fileContent.replaceFirst(
        new RegExp(SCREEN_INSERTION_PLACEHOLDER), replace);
    file.writeAsStringSync(fileContent);
  }

  void _registerScreen() {
    //parses to: addScreen(ScreenIDs.HOME, () => new Home(ScreenIDs.HOME), tree_order: 1);
    String replace =
        '''addScreen(ScreenIDs.$screenNameUnderscoredUppercase, () => new $screenNameCamelCase(ScreenIDs.$screenNameUnderscoredUppercase), transition: EffectIDs.DEFAULT, tree_order: 0);
    $SCREEN_INSERTION_PLACEHOLDER''';

    File file = new File("$DIR_PROJECT/project.dart");
    String fileContent = file.readAsStringSync();
    fileContent = fileContent.replaceFirst(
        new RegExp(SCREEN_INSERTION_PLACEHOLDER), replace);
    file.writeAsStringSync(fileContent);
  }

  String _getDashed() {
    return screenNameCamelCase
        .replaceAllMapped(new RegExp("([^A-Z-])([A-Z])"),
            (Match m) => (m.group(1) + "-" + m.group(2)))
        .toLowerCase();
  }

  String _getUnderscored() {
    return screenNameCamelCase
        .replaceAllMapped(new RegExp("([^A-Z-])([A-Z])"),
            (Match m) => (m.group(1) + "_" + m.group(2)))
        .toLowerCase();
  }
}
