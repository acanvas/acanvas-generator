// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library rockdot_generator.cli_app;

import 'dart:async';
import 'dart:convert' show JSON;
import 'dart:io' as io;
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'package:rockdot_generator/src/common.dart';
import 'package:rockdot_generator/rockdot_generator.dart';

const String APP_NAME = 'rockdot_generator';

// This version must be updated in tandem with the pubspec version.
const String APP_VERSION = '0.9.3';

const String APP_PUB_INFO = 'https://pub.dartlang.org/packages/${APP_NAME}.json';

class CliApp {
  final List<Generator> generators;
  final CliLogger logger;

  GeneratorTarget target;
  io.Directory _cwd;

  Map<String, String> _argsMap;

  CliApp(this.generators, this.logger, [this.target]) {
    assert(generators != null);
    assert(logger != null);
    generators.sort();
  }

  io.Directory get cwd => _cwd != null ? _cwd : io.Directory.current;

  /**
   * An override for the directory to generate into; public for testing.
   */
  set cwd(io.Directory value) {
    _cwd = value;
  }

  Future process(List<String> args) async {
    ArgParser argParser = _createArgParser();

    ArgResults options;

    try {
      options = argParser.parse(args);
    } catch (e, st) {
      // FormatException: Could not find an option named "foo".
      if (e is FormatException) {
        _out('Error: ${e.message}');
        return new Future.error(new ArgError(e.message));
      } else {
        return new Future.error(e, st);
      }
    }

    if (options['version']) {
      _out('${APP_NAME} version: ${APP_VERSION}');
      return http.get(APP_PUB_INFO).then((response) {
        List versions = JSON.decode(response.body)['versions'];
        if (APP_VERSION != versions.last) {
          _out("Version ${versions.last} is available! Run `pub global activate"
              " ${APP_NAME}` to get the latest.");
        }
      }).catchError((e) => null);
    }

    if (options['help'] || args.isEmpty) {
      _usage(argParser);
      return new Future.value(true);
    }

    // The `--machine` option emits the list of available generators to stdout
    // as Json. This is useful for tools that don't want to have to parse the
    // output of `--help`. It's an undocumented command line flag, and may go
    // away or change.
    if (options['machine']) {
      logger.stdout(_createMachineInfo(generators));
      return new Future.value(true);
    }

    if (options.rest.length >= 2) {
      logger.stderr("Error: too many arguments given.\n");
      _usage(argParser);
      return new Future.error(new ArgError('Error: too many arguments given.'));
    }

    String generatorName = options.rest.first;
    Generator generator = _getGenerator(generatorName);

    if (generator == null) {
      logger.stderr("'${generatorName}' is not a valid generator.\n");
      _usage(argParser);
      return new Future.error(new ArgError("'${generatorName}' is not a valid generator."));
    }

    io.Directory dir = cwd;

    if (!options.wasParsed('override') && !_isDirEmpty(dir)) {
      String err =
          'The current directory is not empty. Please create a new project directory, or use --override to force generation into the current directory.';
      logger.stderr(err);
      return new Future.error(new ArgError(err));
    }

    // Normalize the project name.
    String projectName = path.basename(dir.path);
    projectName = normalizeProjectName(projectName);

    if (target == null) {
      target = new _DirectoryGeneratorTarget(logger, dir);
    }

    await generator.prepare(options);

    _out("Creating ${generator.id} application '${projectName}':");

    String author = options['author'];
    Map<String, String> vars = {'author': author};

    if(options["ugc"]){
      //Download zend.zip, extract to server/target/Zend

      HttpClientRequest request = await new HttpClient().getUrl(Uri.parse('http://rockdot.sounddesignz.com/downloads/rockdot-zend-library.zip'));
      HttpClientResponse response = await request.close();
      File file = new File(path.join(dir.path, 'server', 'rockdot-zend-library.zip'));
      await response.pipe(file.openWrite());

      List<int> bytes = new File('test.zip').readAsBytesSync();

      // Decode the Zip file
      Archive archive = new ZipDecoder().decodeBytes(bytes);

      // Extract the contents of the Zip archive to disk.
      for (ArchiveFile file in archive) {
        String filename = file.name;
        List<int> data = file.content;
        new File(path.join(dir.path, 'server', 'target', 'zend', filename))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }

    }


    Future f = generator.generate(projectName, target, additionalVars: vars);
    return f.then((_) {
      _out("${generator.numFiles()} files written.");


      String message = generator.getInstallInstructions();
      if (message != null && message.isNotEmpty) {
        message = message.trim();
        message = message.split('\n').map((line) => "--> ${line}").join("\n");
        _out("\n${message}");
      }
    });
  }

  ArgParser _createArgParser() {
    var argParser = new ArgParser(allowTrailingOptions: true);

    _argsMap = new Map<String, String>();

    _argsMap["stagexl"] = "Install StageXL Minimal Template";
    _argsMap["stagexlExamples"] = "Install StageXL Examples (sprite sheets, tweening, ect.)";

    _argsMap["material"] = "Add Material Design Extension to Rockdot";
    _argsMap["materialExamples"] = "Install Material Design Examples";
    _argsMap["google"] = "Add Google API Extension to Rockdot";
    _argsMap["googleExamples"] = "Install Google API Examples";
    _argsMap["facebook"] = "Add Facebook Extension to Rockdot";
    _argsMap["facebookExamples"] = "Install Facebook API Examples";
    _argsMap["physics"] = "Add Physics Extension to Rockdot";
    _argsMap["physicsExamples"] = "Install Physics Examples";
    _argsMap["ugc"] = "Add User Generated Content (UGC) Extension to Rockdot, needs LAMP";
    _argsMap["ugcExamples"] = "Install UGC Examples";
    _argsMap["babylon"] = "Add BabylonJS Extension to Rockdot";
    _argsMap["babylonExamples"] = "Install BabylonJS Examples";

    //StageXL Options
    _argsMap["bitmapFont"] = "Add BitmapFont Extension to StageXL";
    _argsMap["bitmapFontExamples"] = "Install BitmapFont Examples";
    _argsMap["dragonBones"] = "Add Dragonbones Extension to StageXL";
    _argsMap["dragonBonesExamples"] = "Install Dragonbones Examples";
    _argsMap["flump"] = "Add Flump Extension to StageXL";
    _argsMap["flumpExamples"] = "Install Flump Examples";
    _argsMap["gaf"] = "Add GAF Extension to StageXL";
    _argsMap["gafExamples"] = "Install GAF Examples";
    _argsMap["spine"] = "Add Spine Extension to StageXL";
    _argsMap["spineExamples"] = "Install Spine Examples";
    _argsMap["isometric"] = "Add Isometric Extension to StageXL";
    _argsMap["isometricExamples"] = "Install Isometric Example";
    _argsMap["particle"] = "Add Particle Extension to StageXL";
    _argsMap["particleExamples"] = "Install Particle Example";

    //Demos
    _argsMap["moppiFlowerExamples"] = "Install Flower Demo";

    _argsMap.forEach((flag, description) {
      argParser.addFlag(flag, negatable: false, help: description);
    });

    // Output the list of available projects as json to stdout (required by IntelliJ plugin).
    argParser.addFlag('machine', negatable: false, hide: true);

    argParser.addFlag('help', abbr: 'h', negatable: false, help: 'Help!');
    argParser.addFlag('version', negatable: false, help: 'Display the version for ${APP_NAME}.');
    argParser.addOption('author', defaultsTo: '<your name>', help: 'The author name to use for file headers.');

    // Really, really generate into the current directory.
    argParser.addFlag('override',
        negatable: false,
        help:
            'Disable write protection for non-empty directories.' /*, callback: (mode) => print('Got override mode $mode')*/);

    return argParser;
  }

  void _usage(ArgParser argParser) {
    _out('Röckdöt Generator will generate a Röckdöt project skeleton into the current directory.');
    _out('');
    _out('usage: ${APP_NAME} <generator-name>');
    _out(argParser.usage);
    _out('');
    _out('Available generators:');
    int len = generators.map((g) => g.id.length).fold(0, (a, b) => max(a, b));
    generators.map((g) => "  ${_pad(g.id, len)} - ${g.description}").forEach(logger.stdout);
  }

  String _createMachineInfo(List<Generator> generators) {
    Iterable itor = generators.map((Generator generator) {
      Map m = {'name': generator.id, 'label': generator.label, 'description': generator.description};

      if (generator.entrypoint != null) {
        m['entrypoint'] = generator.entrypoint.path;
      }

      return m;
    });
    return JSON.encode(itor.toList());
  }

  Generator _getGenerator(String id) {
    return generators.firstWhere((g) => g.id == id, orElse: () => null);
  }

  void _out(String str) => logger.stdout(str);

  /**
   * Return true if there are any non-symlinked, non-hidden sub-directories in
   * the given directory.
   */
  bool _isDirEmpty(io.Directory dir) {
    var isHiddenDir = (dir) => path.basename(dir.path).startsWith('.');

    return dir
        .listSync(followLinks: false)
        .where((entity) => entity is io.Directory)
        .where((entity) => !isHiddenDir(entity))
        .isEmpty;
  }
}

class ArgError implements Exception {
  final String message;
  ArgError(this.message);
  String toString() => message;
}

class CliLogger {
  void stdout(String message) => print(message);
  void stderr(String message) => print(message);
}

class _DirectoryGeneratorTarget extends GeneratorTarget {
  final CliLogger logger;
  final io.Directory dir;

  _DirectoryGeneratorTarget(this.logger, this.dir) {
    dir.createSync();
  }

  Future createFile(String filePath, List<int> contents) {
    io.File file = new io.File(path.join(dir.path, filePath));

    logger.stdout('  ${file.path}');

    return file.create(recursive: true).then((_) => file.writeAsBytes(contents));
  }
}

String _pad(String str, int len) {
  while (str.length < len) str += ' ';
  return str;
}
