// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:barback/barback.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'src/cli/common.dart';

class InjectProperties extends Transformer {
  final String _prefix = '@';
  final String _postfix = '@';

  List<String> _files = [];

  Properties _properties;
  final BarbackSettings _settings;

  // Only parse files with the following extensions.
  String get allowedExtensions => ".html .css .php .js .dart";

  // A constructor named "asPlugin" is required. It can be empty, but
  // it must be present. It is how pub determines that you want this
  // class to be publicly available as a loadable transformer plugin.
  InjectProperties.asPlugin(this._settings) {
    Directory d = new Directory('config');
    if (d.existsSync()) {
      d.deleteSync(recursive: true);
    }

    /*
    SPECIAL transformer function only for rockdot_generator development.
    Parses and merges project.properties and en.properties from outer language and properties files (rockdot_generator/templates/).
    This way, it is possible to develop the template project by just opening the template folder as webstorm project and have full features.
   */
    _recursiveFolderCopySync("../basic/web/assets", "web/assets");
    _recursiveFolderCopySync("../basic/config", "config");
    _recursiveFolderCopySync("../material", ".");
    _recursiveFolderCopySync("../facebook", ".");
    _recursiveFolderCopySync("../google", ".");
    _recursiveFolderCopySync("../physics", ".");
    _recursiveFolderCopySync("../ugc/config","config");

    /**
     *  copy different properties
     */

    _getDirectory('web/config/locale/');

    if ("@project.debug@" == "false" ? false : true) {
      //copy project.properties from config/debug to web/config
      new File('config/debug/public.properties').copySync('web/config/project.properties');
      //parse private.properties from config/debug
      _files.add('config/debug/private.properties');
    } else {
      //copy project.properties from config/release to web/config
      new File('config/release/public.properties').copySync('web/config/project.properties');
      //parse private.properties from config/release
      _files.add('config/release/private.properties');
    }
    _files.add('web/config/project.properties');

    //copy plugin language files to web folder
    Directory dir = new Directory('config/locale');
    var files = dir.listSync(recursive: false, followLinks: false);
    files.where((e) => e is File).forEach((file) {
      (file as File).copySync('web/config/locale/${path.basename(file.path)}');
    });

    //treat examples properties and examples
    dir = new Directory('lib/examples');
    if (dir.existsSync()) {
      files = dir.listSync(recursive: true, followLinks: false);

      //copy examples language files to web folder (merge if existing)
      files.where((e) => e is Directory && e.path.contains("locale")).forEach((d) {
        _recursiveFolderCopySync(d.path, 'web/config/locale');
      });

      //copy examples assets files to web folder
      files = dir.listSync(recursive: false, followLinks: false);
      files.where((e) => e is Directory).forEach((d) {
        _recursiveFolderCopySync(path.join(d.path, "assets"), 'web/assets/${path.basename(d.path)}/');
      });
    }

    //load and parse properties
    _properties = new Properties();

    KeyValuePropertiesParser propertiesParser = new KeyValuePropertiesParser();
    _files.forEach((String path) {
      String source = new File(path).readAsStringSync();
      //parse properties
      propertiesParser.parseProperties(source, _properties);
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
        //print("newDir: ${newPath}");
        Directory dir3 = _getDirectory(newPath);
      } else {
        throw new Exception('File is neither File nor Directory. HOW?!');
      }
    });
  }

  Future apply(Transform transform) async {
    var content = await transform.primaryInput.readAsString();
    var newContent = content;

    //inject properties
    _properties.propertyNames.forEach((String name) {
      newContent = newContent.replaceAll('${_prefix}${name}${_postfix}', _properties.getProperty(name));
    });

    transform.addOutput(new Asset.fromString(transform.primaryInput.id, newContent));
  }

  /**
   * Return the file pointed to by the given [path]. This method converts the
   * given path to a platform dependent path.
   */
  File getFile(String path) {
    if (Platform.pathSeparator == '/') {
      return new File(path);
    } else {
      return new File(path.replaceAll('/', Platform.pathSeparator));
    }
  }
}
