import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:rockdot_template/src/cli/common.dart';


final String SERVER_DIR = "server";
final String PREFIX = "@";
final String POSTFIX = "@";

final String DEFAULT_MODE = "debug";
String mode = DEFAULT_MODE;

Properties _properties;
final RegExp _binaryFileTypes = new RegExp(r'\.(jpe?g|png|gif|ico|svg|ttf|eot|woff|woff2|mp3|ogg)$', caseSensitive: false);
bool _isBinaryFile(String filename) => _binaryFileTypes.hasMatch(filename);

void main(List<String> args){
  _setupArgs(args);

  //setup properties
  List<String> propertyFiles = ["config/$mode/server.properties", "config/$mode/private.properties", "config/$mode/public.properties"];
  _properties = new Properties();
  KeyValuePropertiesParser propertiesParser = new KeyValuePropertiesParser();
  propertyFiles.forEach((String path) {
    String source = new File(path).readAsStringSync();
    propertiesParser.parseProperties(source, _properties);
  });

  String source = path.join(SERVER_DIR, 'source');
  String target = path.join(SERVER_DIR, 'target');
  _recursiveFolderCopySync(source, target);
}

_recursiveFolderCopySync(String path1, String path2) /*async */ {
  Directory dir1 = _getDirectory(path1, create: false);
  if (dir1 == null) {
    return;
  }
  Directory dir2 = _getDirectory(path2);

  dir1.listSync(recursive: true, followLinks: false).forEach((element) {
    String newPath = "${dir2.path}${element.path.replaceAll(dir1.path, '')}";

    //treat files
    if (element is File) {
      //ensure existence of file
      File newFile = new File(newPath);
      if(!newFile.existsSync()){
        newFile.createSync(recursive: true);
      }

      //treat non-binary files: replace placeholders with property content
      if(!_isBinaryFile(element.path)){
        String newContent = element.readAsStringSync();
        _properties.propertyNames.forEach((String name) {
          newContent = newContent.replaceAll('${PREFIX}${name}${POSTFIX}', _properties.getProperty(name));
        });
        newFile.writeAsStringSync(newContent);
      }
      //treat binary files
      else{
        newFile.writeAsBytesSync(element.readAsBytesSync());
      }
    } else if (element is Directory) {
      _getDirectory(newPath);
    } else {
      throw new Exception('File is neither File nor Directory. HOW?!');
    }
  });
}


Directory _getDirectory(String s, {bool recursive: true, bool create: true}) {
  Directory d = new Directory(s);
  if (!d.existsSync()) {
    if (create) {
      d.createSync(recursive: recursive);
    } else {
      return null;
    }
  }
  return d;
}

/// Manages the script's arguments and provides instructions and defaults for the --help option.
void _setupArgs(List<String> args) {
  ArgParser argParser = new ArgParser();


  argParser.addOption('mode',
      abbr: 'm',
      defaultsTo: DEFAULT_MODE,
      help: 'The configuration mode to use. Can be either debug or release. Defaults to debug.',
      valueHelp: 'mode', callback: (_mode) {
        mode = _mode;
      });

  argParser.addFlag('help', negatable: false, help: 'Displays the help.', callback: (help) {
    if (help) {
      print(argParser.usage);
      exit(1);
    }
  });

  argParser.parse(args);
}