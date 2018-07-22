// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:ghpages_generator/ghpages_generator.dart' as ghpages;
import 'package:path/path.dart' as path;

final Directory BUILD_DIR = new Directory('build');

main(List<String> args) => grind(args);

@DefaultTask(
    'Concatenate the template files into data files that the generators can consume.')
@Depends(checkInit)
void prepare() {
  Directory dir = new Directory('lib/templates');
  dir.listSync(followLinks: false).forEach((element) {
    String templateName = path.basename(element.path);
    _concatenateFiles(
        getDir('lib/templates/${templateName}'),
        getFile('lib/src/template/data/${templateName}_data.g.dart'),
        templateName);
  });
}

@Task()
@Depends(checkInit, analyze, coverage, clean)
void buildbot() => null;

@Task()
void analyze() {
  //new PubApplication('tuneup')..run(['check']);
}

@Task('Check that the generated init grind script analyzes well')
checkInit() {
  Analyzer.analyze(FilePath.current.join('tool', 'grind.dart').path,
      fatalWarnings: true);
}


@Task('Gather and send coverage data.')
void coverage() {
  final String coverageToken = Platform.environment['COVERALLS_TOKEN'];

  if (coverageToken != null) {
    PubApp coverallsApp = new PubApp.global('dart_coveralls');
    coverallsApp.run([
      'report',
      '--token',
      coverageToken,
      '--retry',
      '2',
      '--exclude-test-files',
      'test/all.dart'
    ]);
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

void _concatenateFiles(Directory src, File target, [String generator_id]) {
  log('Creating ${target.path}');

  List<String> results = _listFiles(beneath: src.path);

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

/// Returns a list of files that are considered to be part of this package.
///
/// If [beneath] is passed, this will only return files beneath that path,
/// which is expected to be relative to the package's root directory. If
/// [recursive] is true, this will return all files beneath that path;
/// otherwise, it will only return files one level beneath it.
///
/// Note that the returned paths won't always be beneath [beneath]. To safely
/// convert them to paths relative to the package root, use [relative].

List<String> _listFiles({String beneath, bool recursive: true}) {
  // Later versions of git do not allow a path for ls-files that appears to
  // be outside of the repo, so make sure we give it a relative path.
  String relativeBeneath = path.relative(beneath, from: path.current);

  // List all files that aren't gitignored, including those not checked in
  // to Git.
  ProcessResult result = Process.runSync(
      "git",
      [
        "ls-files",
        "--cached",
        "--others",
        "--exclude-standard",
        relativeBeneath
      ],
      workingDirectory: path.current);

  // Create List with corrected relative path
  List<String> lines = (result.stdout as String)
      .split("\n")
      .map((line) => line.replaceFirst(new RegExp(r"\r$"), ""))
      .toList();
  lines = lines.map((file) {
    return file.replaceAll("$relativeBeneath/", "");
  }).toList();

  if (!lines.isEmpty && lines.last == "") lines.removeLast();

  return lines;
}