// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:which/which.dart';
import 'package:grinder/src/run.dart' as run_lib;
import 'package:ghpages_generator/ghpages_generator.dart' as ghpages;
import 'package:path/path.dart' as path;
import 'package:rockdot_generator/rockdot_generator.dart' as rockdot_generator;

final Directory BUILD_DIR = new Directory('build');

main(List<String> args) => grind(args);

@DefaultTask('Concatenate the template files into data files that the generators can consume.')
@Depends(checkInit)
void prepare() {
  Directory dir = new Directory('lib/templates');
  dir.listSync(followLinks: false).forEach((element) {
    String templateName = path.basename(element.path);
    _concatenateFiles(
        getDir('lib/templates/${templateName}'), getFile('lib/generators/${templateName}_data.dart'), templateName);
  });
}

@Task()
@Depends(checkInit, analyze, test, coverage, clean)
void buildbot() => null;

@Task()
void analyze() {
  //new PubApplication('tuneup')..run(['check']);
}

@Task('Check that the generated init grind script analyzes well')
checkInit() {
  Analyzer.analyze(FilePath.current.join('tool', 'grind.dart').path, fatalWarnings: true);
}

@Task('Run each generator and analyze the output.')
void test() {
  Tests.runCliTests();

  Directory fooDir = new Directory('foo');

  try {
    for (rockdot_generator.Generator generator in rockdot_generator.generators) {
      if (fooDir.existsSync()) fooDir.deleteSync(recursive: true);
      fooDir.createSync();

      log('${generator.id} template:');

      List<String> args = [
        generator.id,
        '--material',
        /*
        '--materialExamples'
        '--google',
        '--facebook',
        '--physics',
        '--bitmapFont',
        '--bitmapFontExamples',
        '--dragonBones',
        '--dragonBonesExamples',
        '--flump',
        '--flumpExamples',
        '--gaf',
        '--gafExamples',
        '--spine',
        '--spineExamples',
        '--stagexlExamples',
        '--ugc',
        */
      ];

      Dart.run(FilePath.current.join('bin', 'rockdot_generator.dart').path,
          arguments: args, workingDirectory: fooDir.path);

      File pubspec = joinFile(fooDir, ['pubspec.yaml']);

      if (pubspec.existsSync()) {
        if (Platform.isWindows) {
          run('pub.bat', arguments: ['get'], workingDirectory: fooDir.path);
        } else {
          run('pub', arguments: ['get'], workingDirectory: fooDir.path);
        }
      }

      File entrypoint = joinFile(fooDir, ['web', 'public', 'index.html']);
      String filePath = _locateDartFile(entrypoint).path;
      filePath = filePath.replaceAll('projectName', 'foo');

      // Analyzer doesn't support package config file, workaround further down
      /* Analyzer.analyze(filePath, fatalWarnings: true); */

      List<String> aargs = [];
      aargs.add('--packages=foo/.packages');
      aargs.add('--fatal-warnings');
      aargs.add(filePath);
      run_lib.run(_sdkBin('dartanalyzer'), arguments: aargs);

    }
  } catch (e) {}
  try {
    fooDir.deleteSync(recursive: true);
  } catch (_) {}
}

/// Taken from grinder package because of workaround
String _sdkBin(String name) {
  bool _sdkOnPath;
  if (Platform.isWindows) {
    return name == 'dart' ? 'dart.exe' : '${name}.bat';
  } else if (Platform.isMacOS) {
    // If `dart` is not visible, we should join the sdk path and `bin/$name`.
    // This is only necessary in unusual circumstances, like when the script is
    // run from the Editor on macos.
    if (_sdkOnPath == null) {
      _sdkOnPath = whichSync('dart', orElse: () => null) != null;
    }

    return _sdkOnPath ? name : '${sdkDir.path}/bin/${name}';
  } else {
    return name;
  }
}

@Task('Gather and send coverage data.')
void coverage() {
  final String coverageToken = Platform.environment['COVERALLS_TOKEN'];

  if (coverageToken != null) {
    PubApp coverallsApp = new PubApp.global('dart_coveralls');
    coverallsApp.run(['report', '--token', coverageToken, '--retry', '2', '--exclude-test-files', 'test/all.dart']);
  } else {
    log('Skipping coverage task: no environment variable `COVERALLS_TOKEN` found.');
  }
}

@Task('Generate a new version of gh-pages.')
void updateGhPages() {
  log('Updating gh-pages branch of the project');
  new ghpages.Generator(rootDir: getDir('.').absolute.path)
    ..templateDir = getDir('site').absolute.path
    ..generate();
}

@Task('Delete all generated artifacts.')
void clean() {
  // Delete the build/ dir.
  delete(BUILD_DIR);
}

// These tasks require a frame buffer to run.

@Task()
Future testsWeb() => Tests.runWebTests(directory: 'web', htmlFile: 'index.html');

@Task()
Future testsBuildWeb() {
  return Pub.buildAsync(directories: ['web']).then((_) {
    return Tests.runWebTests(directory: 'build/web', htmlFile: 'index.html');
  });
}

void _concatenateFiles(Directory src, File target, [String generator_id]) {
  log('Creating ${target.path}');

  List<String> results = [];

  _traverse(src, '', results);

  String str = results.map((s) => '  ${_toStr(s)}').join(',\n');

  target.writeAsStringSync("""
// Copyright (c) 2016, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
String type = "${path.basename(src.path)}";
List<String> data = [
${str}
];
""");
}

String _toStr(String s) {
  if (s.contains('\n')) {
    return '"""${s}"""';
  } else {
    return '"${s}"';
  }
}

void _traverse(Directory dir, String root, List<String> results) {
  var files = _listSync(dir, recursive: false, followLinks: false);
  for (FileSystemEntity entity in files) {
    String name = path.basename(entity.path);

    if (entity is Link) continue;
    if (name == 'pubspec.lock') continue;
    if (name.startsWith('.')) continue;

    if (entity is Directory) {
      _traverse(entity, '${root}${name}/', results);
    } else {
      results.add('${root}${name}');
    }
  }
}


File _locateDartFile(File file) {
  if (file.path.endsWith('.dart')) return file;

  return _listSync(file.parent).firstWhere((f) => f.path.endsWith('.dart'), orElse: () => null);
}

/**
 * Return the list of children for the given directory. This list is normalized
 * (by sorting on the file path) in order to prevent large merge diffs in the
 * generated template data files.
 */
List<FileSystemEntity> _listSync(Directory dir, {bool recursive: false, bool followLinks: true}) {
  List<FileSystemEntity> results = dir.listSync(recursive: recursive, followLinks: followLinks);
  results.sort((entity1, entity2) => entity1.path.compareTo(entity2.path));
  return results;
}
