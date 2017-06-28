// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/**
 * Stagehand is a Dart project generator.
 *
 * Stagehand helps you get your Dart projects set up and ready for the big show.
 * It is a Dart project scaffolding generator, inspired by tools like Web
 * Starter Kit and Yeoman.
 *
 * It can be used as a command-line application, or as a regular Dart library
 * composed it a larger development tool. To use as a command-line app, run:
 *
 *     `pub global run rockdot_generator`
 *
 * to see a list of all app types you can create, and:
 *
 *     `pub global run rockdot_generator -o foobar webapp`
 *
 * to create a new instance of the `webapp` template in a `foobar` subdirectory.
 */
library rockdot_generator;

import 'dart:async';
import 'dart:convert';

import 'src/common.dart';
import 'generators/basic.dart';
import 'package:args/args.dart';

/// A curated, prescriptive list of Dart project generators.
final List<Generator> generators = [new BasicGenerator()];

Generator getGenerator(String id) {
  return generators.firstWhere((g) => g.id == id, orElse: () => null);
}

/**
 * An abstract class which both defines a template generator and can generate a
 * user project baed on this template.
 */
abstract class Generator implements Comparable<Generator> {
  final String id;
  final String label;
  final String description;
  final List<String> categories;

  final List<TemplateFile> files = [];
  TemplateFile _entrypoint;

  Generator(this.id, this.label, this.description, {this.categories: const []});

  /**
   * The entrypoint of the application; the main file for the project, which an
   * IDE might open after creating the project.
   */
  TemplateFile get entrypoint => _entrypoint;

  /**
   * Some Generators need command line args in order to be able to perform
   */
  Future prepare(ArgResults options) async {}

  /**
   * Add a new template file.
   */
  TemplateFile addTemplateFile(TemplateFile file, [bool append = false]) {
    TemplateFile existingFile = files.firstWhere((t) => t.path == file.path, orElse: () => null);
    if (existingFile != null) {
      files.removeWhere((t) => t.path == existingFile.path);
      if (append && !_isBinaryFile(existingFile.path)) {
        file.content = existingFile.content + file.content;
      }
    }

    files.add(file);
    return file;
  }

  /**
   * Return the template file wih the given [path].
   */
  TemplateFile getFile(String path) {
    return files.firstWhere((file) => file.path == path, orElse: () => null);
  }

  final RegExp _binaryFileTypes = new RegExp(r'\.(jpe?g|png|gif|ico|svg|ttf|eot|woff|woff2|mp3|ogg)$', caseSensitive: false);

  /**
   * Returns true if the given [filename] matches common image file name patterns.
   */
  bool _isBinaryFile(String filename) => _binaryFileTypes.hasMatch(filename);

  /**
   * Set the main entrypoint of this template. This is the 'most important' file
   * of this template. An IDE might use this information to open this file after
   * the user's project is generated.
   */
  void setEntrypoint(TemplateFile entrypoint) {
    if (_entrypoint != null) throw new StateError('entrypoint already set');
    if (entrypoint == null) throw new StateError('entrypoint is null');
    this._entrypoint = entrypoint;
  }

  Future generate(String projectName, GeneratorTarget target, {Map<String, String> additionalVars}) {
    Map<String, String> vars = {
      'projectName': projectName,
      'rockdot_template': projectName,
      'description': description,
      'year': new DateTime.now().year.toString()
    };

    if (additionalVars != null) {
      additionalVars.keys.forEach((key) {
        vars[key] = additionalVars[key];
      });
    }

    if (!vars.containsKey('author')) {
      vars['author'] = '<your name>';
    }

    return Future.forEach(files, (TemplateFile file) {
      var resultFile = file.runSubstitution(vars);
      String filePath = resultFile.path;
      filePath = filePath.replaceAll('rockdot_template', projectName);

      return target.createFile(filePath, resultFile.content);
    });
  }

  int numFiles() => files.length;

  int compareTo(Generator other) => this.id.toLowerCase().compareTo(other.id.toLowerCase());

  /**
   * Return some user facing instructions about how to finish installation of
   * the template.
   */
  String getInstallInstructions() => '';

  String toString() => '[${id}: ${description}]';
}

/**
 * A target for a [Generator]. This class knows how to create files given a path
 * for the file (relavtive to the particular [GeneratorTarget] instance), and
 * the binary content for the file.
 */
abstract class GeneratorTarget {
  /**
   * Create a file at the given path with the given contents.
   */
  Future createFile(String path, List<int> contents);
}

/**
 * This class represents a file in a generator template. The contents could
 * either be binary or text. If text, the contents may contain mustache
 * variables that can be substituted (`{{myVar}}`).
 */
class TemplateFile {
  String path;
  String content;

  List<int> _binaryData;

  TemplateFile(this.path, this.content);

  TemplateFile.fromBinary(this.path, this._binaryData) : this.content = null;

  FileContents runSubstitution(Map<String, String> parameters) {
    var newPath = substituteVars(path, parameters);
    var newContents = _createContent(parameters);

    return new FileContents(newPath, newContents);
  }

  bool get isBinary => _binaryData != null;

  List<int> _createContent(Map<String, String> vars) {
    if (isBinary) {
      return _binaryData;
    } else {
      //raw substitution of "rockdot_template" with "${projectName}"
      String c_content = content.replaceAll('rockdot_template', vars['projectName']);

      return UTF8.encode(substituteVars(c_content, vars));
    }
  }
}

class FileContents {
  final String path;
  final List<int> content;

  FileContents(this.path, this.content);
}
