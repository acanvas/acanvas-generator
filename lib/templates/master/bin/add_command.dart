import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart';

final String TEMPLATE_DIR = "bin/template";
const String TEMPLATE_COMMAND_FILE = "command.dart.tpl";
const String PACKAGE_REPLACE_STRING = "@package@";
const String COMMAND_REPLACE_STRING = "@command@";

const String COMMAND_INSERTION_PLACEHOLDER = "// ## COMMAND INSERTION PLACEHOLDER - DO NOT REMOVE ## //";

const String DEFAULT_COMMAND_NAME = "";

const String DIR_LIB = "lib";
const String DIR_PROJECT = "$DIR_LIB/src/project";
const String DIR_COMMAND = "$DIR_PROJECT/command";

String commandNameCamelCase;
String commandNameUnderscored;
String commandNameUnderscoredUppercase;

String packageName;


void main(List args) {

  _setupArgs(args);
  
  if(commandNameCamelCase == DEFAULT_COMMAND_NAME){
    print("Well, at least provide the --name of the Command (in CamelCase) you want to add, will you?");
    exit(1);
  }
  
  packageName = _getPackageNameFromPubspec();
  commandNameUnderscored = _getCommandNameUnderscored();
  commandNameUnderscoredUppercase = commandNameUnderscored.toUpperCase();
  
  //add const to events
  _insertEvent();
  
  //add command from template to DIR_COMMAND
  _createCommandFile();
  
  //add class name to package spec $DIR_LIB/$packageName.dart
  _addToPackage();
  
  //add class to event mapping to $DIR_PROJECT/project.dart
  _insertEventMapping();

  print("Done. You can now call your new command like this: \n\t new RdSignal(ProjectEvents.$commandNameUnderscoredUppercase).dispatch();");
}

/// Adds the newly created library as dependency to the project's root pubspec.yaml.
String _getPackageNameFromPubspec() {
  File pubspecRootFile = new File('pubspec.yaml').absolute;
  String pubspecRootFileContent = pubspecRootFile.readAsStringSync();
  return new RegExp("name\\s*:\\s*(\\w+)").firstMatch(pubspecRootFileContent).group(1);
}

String _getCommandNameUnderscored() {
  return commandNameCamelCase.replaceAllMapped(new RegExp("([^A-Z-])([A-Z])"), (Match m) => (m.group(1) + "_" + m.group(2))).toLowerCase();
}

void _insertEvent(){
  
  String replace = '''static const String $commandNameUnderscoredUppercase = "ProjectEvents.$commandNameUnderscoredUppercase";
    $COMMAND_INSERTION_PLACEHOLDER
  ''';
  
  File file = new File("$DIR_COMMAND/event/project_events.dart");
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceFirst(new RegExp(COMMAND_INSERTION_PLACEHOLDER), replace);
  file.writeAsStringSync(fileContent);
}

/// Copies Command template file from [TEMPLATE_DIR] to [DIR_COMMAND].
/// During the process, all occurences of [COMMAND_REPLACE_STRING] and [PACKAGE_REPLACE_STRING] are replaced.
void _createCommandFile() {
  File file = new File("$TEMPLATE_DIR/$TEMPLATE_COMMAND_FILE");
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceAll(new RegExp(COMMAND_REPLACE_STRING), commandNameCamelCase);
  fileContent = fileContent.replaceAll(new RegExp(PACKAGE_REPLACE_STRING), packageName);

  new File(join(DIR_COMMAND, "$commandNameUnderscored.dart"))
      ..createSync(recursive: true)
      ..writeAsStringSync(fileContent);
}

void _addToPackage(){
  String replace = '''part 'src/project/command/$commandNameUnderscored.dart';
    $COMMAND_INSERTION_PLACEHOLDER
  ''';
  
  File file = new File("$DIR_LIB/$packageName.dart");
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceFirst(new RegExp(COMMAND_INSERTION_PLACEHOLDER), replace);
  file.writeAsStringSync(fileContent);
}

void _insertEventMapping(){
  //parses to: commandMap[ProjectEvents.APP_INIT] = () => new InitCommand();
  String replace = '''commandMap[ProjectEvents.$commandNameUnderscoredUppercase] = () => new $commandNameCamelCase();
    $COMMAND_INSERTION_PLACEHOLDER
  ''';
  
  File file = new File("$DIR_PROJECT/project.dart");
  String fileContent = file.readAsStringSync();
  fileContent = fileContent.replaceFirst(new RegExp(COMMAND_INSERTION_PLACEHOLDER), replace);
  file.writeAsStringSync(fileContent);
}


/// Manages the script's arguments and provides instructions and defaults for the --help option.
void _setupArgs(List args) {
  ArgParser argParser = new ArgParser();
  
  argParser.addOption('name', abbr: 'n', defaultsTo: DEFAULT_COMMAND_NAME, help: 'The name (in CamelCase) of the command to be generated.', valueHelp: 'name', callback: (_commandName) {
    commandNameCamelCase = _commandName;
  });

  argParser.addFlag('help', negatable: false, help: 'Displays the help.', callback: (help) {
    if (help) {
      print(argParser.usage);
      exit(1);
    }
  });

  argParser.parse(args);
}