import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart';

final String TEMPLATE_DIR = "bin/template";
const String TEMPLATE_SCREEN_FILE = "screen.dart.tpl";
const String PACKAGE_REPLACE_STRING = "@package@";
const String SCREEN_REPLACE_STRING = "@screen@";

const String SCREEN_INSERTION_PLACEHOLDER = "// ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //";
const String SCREEN_PROPERTIES_PLACEHOLDER = "## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ##";

const String DIR_PROPERTIES = "config/locale";
const String DIR_LIB = "lib";
const String DIR_PROJECT = "$DIR_LIB/src/project";

const String DEFAULT_SCREEN_NAME = "";
const String DEFAULT_SCREEN_URL = "";
const String DEFAULT_SCREEN_ROOT = DIR_LIB;

String screenNameDashed;
String screenNameCamelCase;
String screenNameUnderscored;
String screenNameUnderscoredUppercase;
String screenRoot;
String screenDir;
String screenModelDir;

String packageName;

void main(List<String> args) {
  _setupArgs(args);

  if (screenNameCamelCase == DEFAULT_SCREEN_NAME) {
    print("Well, at least provide the --name of the Screen you want to add, will you?");
    exit(1);
  }

  packageName = _getPackageNameFromPubspec();
  screenNameDashed = _getScreenNameDashed();
  screenNameUnderscored = _getScreenNameUnderscored();
  screenNameUnderscoredUppercase = screenNameUnderscored.toUpperCase();

  if (screenRoot != DIR_LIB) {
    screenDir = "src/view/screen";
    screenModelDir = "src/model";
  } else {
    screenDir = "src/project/view/screen";
    screenModelDir = "src/project/model";
  }

  //add const to events
  _insertProperties();

  //add command from template to DIR_SCREEN
  _createScreenFile();

  //add class name to package spec $DIR_LIB/$packageName.dart
  _addToPackage();

  //add id to $DIR_PROJECT/model/screen_ids.dart
  _registerScreenID();

  //add class to event mapping to $DIR_PROJECT/project.dart
  _registerScreen();

  print("Done. You can now access your new screen at URL #/$screenNameDashed");
}

/// Adds the newly created library as dependency to the project's root pubspec.yaml.
String _getPackageNameFromPubspec() {
  if (screenRoot != DIR_LIB) {
    Directory dir = new Directory(screenRoot);
    File file = dir.listSync(followLinks: false).where((entity) => entity is File).first;
    String content = file.readAsStringSync();
    return new RegExp("library\\s*(\\w+);").firstMatch(content).group(1);
  } else {
    File pubspecRootFile = new File('pubspec.yaml').absolute;
    String pubspecRootFileContent = pubspecRootFile.readAsStringSync();
    return new RegExp("name\\s*:\\s*(\\w+)").firstMatch(pubspecRootFileContent).group(1);
  }
}

String _getScreenNameDashed() {
  return screenNameCamelCase
      .replaceAllMapped(new RegExp("([^A-Z-])([A-Z])"), (Match m) => (m.group(1) + "-" + m.group(2)))
      .toLowerCase();
}

String _getScreenNameUnderscored() {
  return screenNameCamelCase
      .replaceAllMapped(new RegExp("([^A-Z-])([A-Z])"), (Match m) => (m.group(1) + "_" + m.group(2)))
      .toLowerCase();
}

void _insertProperties() {
  String replace = '''##############################
### Screen: $screenNameUnderscoredUppercase
##############################
screen.$screenNameUnderscored.url = /$screenNameDashed
screen.$screenNameUnderscored.title = $screenNameCamelCase
screen.$screenNameUnderscored.headline = Hello World.

$SCREEN_PROPERTIES_PLACEHOLDER
''';

  String path = (screenRoot != DIR_LIB) ? "$screenRoot/$DIR_PROPERTIES/en.properties" : "$DIR_PROPERTIES/en.properties";

  File file = new File(path);
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceFirst(new RegExp(SCREEN_PROPERTIES_PLACEHOLDER), replace);
  file.writeAsStringSync(fileContent);
}

/// Copies Screen template file from [TEMPLATE_DIR] to [screenDir].
/// During the process, all occurences of [SCREEN_REPLACE_STRING] and [PACKAGE_REPLACE_STRING] are replaced.
void _createScreenFile() {
  File file = new File("$TEMPLATE_DIR/$TEMPLATE_SCREEN_FILE");
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceAll(new RegExp(SCREEN_REPLACE_STRING), screenNameCamelCase);
  fileContent = fileContent.replaceAll(new RegExp(PACKAGE_REPLACE_STRING), packageName);

  new File(join(screenRoot, screenDir, "$screenNameUnderscored.dart"))
    ..createSync(recursive: true)
    ..writeAsStringSync(fileContent);
}

void _addToPackage() {
  String replace = '''part '${screenDir}/$screenNameUnderscored.dart';
    $SCREEN_INSERTION_PLACEHOLDER
  ''';

  File file = new File("$screenRoot/$packageName.dart");
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceFirst(new RegExp(SCREEN_INSERTION_PLACEHOLDER), replace);
  file.writeAsStringSync(fileContent);
}

void _registerScreenID() {
  String replace = '''static const String $screenNameUnderscoredUppercase = "screen.$screenNameUnderscored";
    $SCREEN_INSERTION_PLACEHOLDER
  ''';

  File file = new File("$screenRoot/$screenModelDir/screen_ids.dart");
  if (!file.existsSync()) {
    Directory dir = new Directory("$screenRoot/$screenModelDir");
    file = dir.listSync(followLinks: false).where((entity) => entity is File).first;
  }
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceFirst(new RegExp(SCREEN_INSERTION_PLACEHOLDER), replace);
  file.writeAsStringSync(fileContent);
}

void _registerScreen() {
  //parses to: addScreen(ScreenIDs.HOME, () => new Home(ScreenIDs.HOME), tree_order: 1);
  String replace =
      '''addScreen(ScreenIDs.$screenNameUnderscoredUppercase, () => new $screenNameCamelCase(ScreenIDs.$screenNameUnderscoredUppercase), transition: EffectIDs.DEFAULT, tree_order: 0);
    $SCREEN_INSERTION_PLACEHOLDER
  ''';

  File file = new File("$screenRoot/src/project/project.dart");
  if (!file.existsSync()) {
    Directory dir = new Directory("$screenRoot/src");
    file = dir.listSync(followLinks: false).where((entity) => entity is File).first;
  }
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceFirst(new RegExp(SCREEN_INSERTION_PLACEHOLDER), replace);
  file.writeAsStringSync(fileContent);
}

/// Manages the script's arguments and provides instructions and defaults for the --help option.
void _setupArgs(List<String> args) {
  ArgParser argParser = new ArgParser();

  argParser.addOption('name',
      abbr: 'n',
      defaultsTo: DEFAULT_SCREEN_NAME,
      help: 'The name (in CamelCase) of the screen to be generated.',
      valueHelp: 'name', callback: (_screenName) {
    screenNameCamelCase = _screenName;
  });

  argParser.addOption('root',
      abbr: 'r',
      defaultsTo: DEFAULT_SCREEN_ROOT,
      help: 'The src directory of the screen to be generated.',
      valueHelp: 'root', callback: (_screenRoot) {
    screenRoot = _screenRoot;
  });

  argParser.addFlag('help', negatable: false, help: 'Displays the help.', callback: (help) {
    if (help) {
      print(argParser.usage);
      exit(1);
    }
  });

  argParser.parse(args);
}
