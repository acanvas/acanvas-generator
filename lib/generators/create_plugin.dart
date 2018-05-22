import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart';

final String TEMPLATE_DIR = "bin/template/plugin";
const String PACKAGE_REPLACE_STRING = "@package@";

const String PLUGIN_REPLACE_STRING = "@plugin@";
const String PLUGIN_UPPERCASE_REPLACE_STRING = "@pluginUpperCase@";
const String PLUGIN_LOWERCASE_REPLACE_STRING = "@pluginLowerCase@";

const String PLUGIN_INSERTION_PLACEHOLDER =
    "// ## PLUGIN INSERTION PLACEHOLDER - DO NOT REMOVE ## //";

const String DEFAULT_PLUGIN_NAME = "";

const String DIR_LIB = "lib";
const String DIR_BOOTSTRAP = "$DIR_LIB/src/bootstrap";
const String DIR_PROJECT = "$DIR_LIB/src/project";
const String DIR_PLUGIN = "$DIR_LIB/src/plugin";

String pluginNameCamelCase;
String pluginNameUnderscored;
String pluginNameUnderscoredUppercase;

String packageName;

void main(List<String> args) {
  _setupArgs(args);

  if (pluginNameCamelCase == DEFAULT_PLUGIN_NAME) {
    print(
        "Well, at least provide the --name of the Plugin you want to add, will you?");
    exit(1);
  }

  packageName = _getPackageNameFromPubspec();
  pluginNameUnderscored = _getPluginNameUnderscored();
  pluginNameUnderscoredUppercase = pluginNameUnderscored.toUpperCase();

  //iterate through sourceDir and copy to targetDir
  _scanSource();

  //add plugin instantiation call to [DIR_BOOTSTRAP]/rd_bootstrap.dart
  _insertPlugin();

  print(
      "Done. You can now use the plugin like this: \n\t new RdSignal(${pluginNameCamelCase}Events.SAMPLE, new ${pluginNameCamelCase}VO('message').dispatch();");
}

/// Adds the newly created library as dependency to the project's root pubspec.yaml.
String _getPackageNameFromPubspec() {
  File pubspecRootFile = new File('pubspec.yaml').absolute;
  String pubspecRootFileContent = pubspecRootFile.readAsStringSync();
  return new RegExp("name\\s*:\\s*(\\w+)")
      .firstMatch(pubspecRootFileContent)
      .group(1);
}

String _getPluginNameUnderscored() {
  return pluginNameCamelCase
      .replaceAllMapped(new RegExp("([^A-Z-])([A-Z])"),
          (Match m) => (m.group(1) + "_" + m.group(2)))
      .toLowerCase();
}

void _scanSource() {
  String generatedEntries = "";

  /* iterate over source path, grab *.as files */
  Directory sourceDir = new Directory(TEMPLATE_DIR);
  if (sourceDir.existsSync()) {
    sourceDir
        .listSync(recursive: true, followLinks: false)
        .forEach((FileSystemEntity entity) {
      if (FileSystemEntity.typeSync(entity.path) == FileSystemEntityType.FILE) {
        generatedEntries += _createFile(entity.path) + "\n";
      }
    });
    _addToPackage(generatedEntries);
  } else {
    print(
        "The directory that was provided as source directory does not exist: $TEMPLATE_DIR");
    exit(1);
  }
}

/// Copies Plugin template file from [TEMPLATE_DIR] to [DIR_PLUGIN].
/// During the process, all occurences of [PLUGIN_REPLACE_STRING] and [PACKAGE_REPLACE_STRING] are replaced.
String _createFile(String sourcePath) {
  String dirName =
      dirname(sourcePath).replaceFirst(new RegExp(TEMPLATE_DIR), '');
  String baseName = basenameWithoutExtension(sourcePath);
  baseName = baseName.replaceFirst(new RegExp("plugin"), pluginNameUnderscored);
  String normd =
      normalize("src/plugin/$pluginNameUnderscored/${dirName}/${baseName}");
  print(normd);

  File file = new File(sourcePath);
  String fileContent = file.readAsStringSync();

  fileContent =
      fileContent.replaceAll(new RegExp(PACKAGE_REPLACE_STRING), packageName);
  fileContent = fileContent.replaceAll(
      new RegExp(PLUGIN_REPLACE_STRING), pluginNameCamelCase);
  fileContent = fileContent.replaceAll(
      new RegExp(PLUGIN_LOWERCASE_REPLACE_STRING), pluginNameUnderscored);
  fileContent = fileContent.replaceAll(
      new RegExp(PLUGIN_UPPERCASE_REPLACE_STRING),
      pluginNameUnderscoredUppercase);

  new File("lib/$normd")
    ..createSync(recursive: true)
    ..writeAsStringSync(fileContent);

  String entry = '''part '$normd'; ''';
  return entry;
}

/// Adds file imports to the project's package definition file
void _addToPackage(String defs) {
  String replace = '''$defs
    $PLUGIN_INSERTION_PLACEHOLDER
  ''';

  File file = new File("$DIR_LIB/$packageName.dart");
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceFirst(
      new RegExp(PLUGIN_INSERTION_PLACEHOLDER), replace);
  file.writeAsStringSync(fileContent);
}

///add plugin instantiation call to [DIR_BOOTSTRAP]/rd_bootstrap.dart
void _insertPlugin() {
  String replace = '''new ${pluginNameCamelCase}Plugin(),
      $PLUGIN_INSERTION_PLACEHOLDER
  ''';

  File file = new File("$DIR_BOOTSTRAP/rd_bootstrap.dart");
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceFirst(
      new RegExp(PLUGIN_INSERTION_PLACEHOLDER), replace);
  file.writeAsStringSync(fileContent);
}

/// Manages the script's arguments and provides instructions and defaults for the --help option.
void _setupArgs(List<String> args) {
  ArgParser argParser = new ArgParser();

  argParser.addOption('name',
      abbr: 'n',
      defaultsTo: DEFAULT_PLUGIN_NAME,
      help: 'The name (in CamelCase) of the plugin to be generated.',
      valueHelp: 'name', callback: (_pluginName) {
    pluginNameCamelCase = _pluginName;
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
