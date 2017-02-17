// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/**
 * Some utilty methods for rockdot_generator.
 */
library rockdot_generator.utils;

import 'dart:async' show Future;
import 'package:resource/resource.dart';
import 'package:resource/src/resource_loader.dart';
import 'dart:convert' show UTF8;
import '../rockdot_generator.dart';

const int _RUNE_SPACE = 32;
final RegExp _binaryFileTypes =
    new RegExp(r'\.(mp3|ogg|zip|gaf|webp|fnt|jpe?g|png|gif|ico|svg|ttf|eot|woff|woff2)$', caseSensitive: false);

Future<List<TemplateFile>> decodeConcanenatedData(List<String> data, String pack) async {
  List<TemplateFile> results = [];
  Resource myResource;
  ResourceLoader loader = new DefaultLoader();
  int counter = 1;

  for (int i = 0; i < data.length; i++) {
    String path = data[i];

    if (path.endsWith(".png")) {
      // continue;
    }

    await new Future.delayed(const Duration(milliseconds: 100));

    myResource = new Resource('package:rockdot_generator/templates/${pack}/${path}', loader: loader);

    print("${counter} - template: ${pack}, resource: $path");

    //  List<int> decoded = BASE64.decode(raw);

    if (_isBinaryFile(path)) {
      try {
        List<int> bytes = await myResource.readAsBytes();
        TemplateFile templateFile = new TemplateFile.fromBinary(path, bytes);
        results.add(templateFile);
        //results.add(new TemplateFile.fromBinary(path, decoded));
      } catch (e) {
        print("${counter} - error: $e");
      }
    } else {
      try {
        String source = await myResource.readAsString(encoding: UTF8);
        //String source = UTF8.decode(decoded);
        results.add(new TemplateFile(path, source));
      } catch (e) {
        print("${counter} - error: $e");
      }
    }
    myResource = null;
    counter++;
  }

  return results;
}

/**
 * Returns true if the given [filename] matches common image file name patterns.
 */
bool _isBinaryFile(String filename) {
  List<String> split = filename.split("/");
  return _binaryFileTypes.hasMatch(split[split.length - 1]);
}

/**
   * Convert a directory name into a reasonably legal pub package name.
   */
String normalizeProjectName(String name) {
  name = name.replaceAll('-', '_').replaceAll(' ', '_');

  // Strip any extension (like .dart).
  if (name.contains('.')) {
    name = name.substring(0, name.indexOf('.'));
  }

  return name;
}

/**
   * Given a String [str] with mustache templates, and a [Map] of String key /
   * value pairs, substitute all instances of `{{key}}` for `value`. I.e.,
   *
   *     Foo {{projectName}} baz.
   *
   * and
   *
   *     {'projectName': 'bar'}
   *
   * becomes:
   *
   *     Foo bar baz.
   */
String substituteVars(String str, Map<String, String> vars) {
  vars.forEach((key, value) {
    String sub = '{{${key}}}';
    str = str.replaceAll(sub, value);
  });
  return str;
}

/**
   * Convert the given String into a String with newlines wrapped at an 80 column
   * boundary, with 2 leading spaces for each line.
   */
String convertToYamlMultiLine(String str) {
  return wrap(str, 78).map((line) => '  ${line}').join('\n');
}

/**
   * Break the given String into lines wrapped on a [col] boundary.
   */
List<String> wrap(String str, [int col = 80]) {
  List<String> lines = [];

  while (str.length > col) {
    int index = col;

    while (index > 0 && str.codeUnitAt(index) != _RUNE_SPACE) {
      index--;
    }

    if (index == 0) {
      index = str.indexOf(' ');

      if (index == -1) {
        lines.add(str);
        str = '';
      } else {
        lines.add(str.substring(0, index).trim());
        str = str.substring(index).trim();
      }
    } else {
      lines.add(str.substring(0, index).trim());
      str = str.substring(index).trim();
    }
  }

  if (str.length > 0) {
    lines.add(str);
  }

  return lines;
}

/**
   * An abstract implementation of a [Generator].
   */
abstract class DefaultGenerator extends Generator {
  DefaultGenerator(String id, String label, String description, {List<String> categories: const []})
      : super(id, label, description, categories: categories);

  TemplateFile addFile(String path, String contents) => addTemplateFile(new TemplateFile(path, contents));

  String getInstallInstructions() {
    if (getFile('pubspec.yaml') != null) {
      return "to provision required packages, run 'pub get'";
    } else {
      return '';
    }
  }
}
