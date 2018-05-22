// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:build/build.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'src/cli/common.dart';

Builder templateBuilder(BuilderOptions options) =>
    new RockdotTemplateBuilder(options.config['mode']);

class RockdotTemplateBuilder extends Builder {
  final String _prefix = '@';
  final String _postfix = '@';

  List<String> _files = [];

  Properties _properties;
  String mode;

  RockdotTemplateBuilder(this.mode) {
    //load and parse properties
    _properties = new Properties();

    _files.add(path.join('config', mode, 'public.properties'));
    _files.add(path.join('config', mode, 'private.properties'));
    _files.add(path.join('config', mode, 'server.properties'));

    KeyValuePropertiesParser propertiesParser = new KeyValuePropertiesParser();
    _files.forEach((String path) {
      String source = new File(path).readAsStringSync();
      //parse properties
      propertiesParser.parseProperties(source, _properties);
    });

    _inject();
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    // Each [buildStep] has a single input.
    var inputId = buildStep.inputId;

    // Create a new target [AssetId] based on the old one.
    var contents = await buildStep.readAsString(inputId);
    //inject properties
    _properties.propertyNames.forEach((String name) {
      contents = contents.replaceAll(
          '${_prefix}${name}${_postfix}', _properties.getProperty(name));
    });

    var rename =
        new AssetId(inputId.package, inputId.path.replaceAll(".template", ""));

    // Write out the new asset.
    await buildStep.writeAsString(rename, contents);
  }

  @override
  final buildExtensions = const {
    '.template.html': const [
      '.html'
    ] /*,
    '.template.php': const ['.php'],
    '.template.js': const ['.js'],
    '.template.dart': const ['.dart'],
    '.template.css': const ['.css'],
    '.template.properties': const ['.properties']*/
  };

  void _inject() {
    /*
    SPECIAL transformer function only for rockdot_generator development.
    Parses and merges project.properties and en.properties from outer language and properties files (rockdot_generator/templates/).
    This way, it is possible to develop the template project by just opening the template folder as webstorm project and have full features.
   */

    Directory d = new Directory('config');
    if (d.existsSync()) {
      d.deleteSync(recursive: true);
    }

    _recursiveFolderCopySync("../basic/web/assets", "web/assets");
    _recursiveFolderCopySync("../basic/config", "config");
    _recursiveFolderCopySync("../material", ".");
    _recursiveFolderCopySync("../facebook", ".");
    _recursiveFolderCopySync("../google", ".");
    _recursiveFolderCopySync("../physics", ".");
    _recursiveFolderCopySync("../ugc/config", "config");

    /*
    END of SPECIAL transformer function
    */

    //copy project.properties from config/debug to web/config
    new File(path.join('config', mode, 'public.properties'))
        .copySync(path.join('web', 'config', 'project.template.properties'));

    //copy plugin language files to web folder
    Directory dir = new Directory('config/locale');
    _getDirectory('web/config/locale/');
    var files = dir.listSync(recursive: false, followLinks: false);
    files.where((e) => e is File).forEach((file) {
      (file as File).copySync('web/config/locale/${path.basename(file.path)}');
    });

    //treat examples properties and examples
    dir = new Directory('lib/examples');
    if (dir.existsSync()) {
      files = dir.listSync(recursive: true, followLinks: false);

      //copy examples language files to web folder (merge if existing)
      files
          .where((e) => e is Directory && e.path.contains("locale"))
          .forEach((d) {
        _recursiveFolderCopySync(d.path, 'web/config/locale');
      });

      //copy examples assets files to web folder
      files = dir.listSync(recursive: false, followLinks: false);
      files.where((e) => e is Directory).forEach((d) {
        _recursiveFolderCopySync(path.join(d.path, "assets"),
            'web/assets/${path.basename(d.path)}/');
      });
    }
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

  _recursiveFolderCopySync(String path1, String path2) /*async */ {
    Directory dir1 = _getDirectory(path1, create: false);
    if (dir1 == null) {
      return;
    }
    Directory dir2 = _getDirectory(path2);

    dir1.listSync(recursive: true, followLinks: false).forEach((element) {
      String newPath = "${dir2.path}${element.path.replaceAll(dir1.path, '')}";
      //print("newPath: ${newPath}");
      if (element is File) {
        File newFile = new File(newPath);

        var writeMode = FileMode.WRITE;
        if (newFile.existsSync() && newFile.path.contains(".properties")) {
          //print("merging: \n ${newFile.readAsStringSync()}");
          writeMode = FileMode.APPEND;
        }

        newFile.writeAsBytesSync(element.readAsBytesSync(), mode: writeMode);
      } else if (element is Directory) {
        _getDirectory(newPath);
      } else {
        throw new Exception('File is neither File nor Directory. HOW?!');
      }
    });
  }
}
