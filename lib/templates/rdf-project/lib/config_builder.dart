// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
//import 'package:archive/archive.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'src/cli/common.dart';

Builder configBuilder(BuilderOptions options) =>
    new ConfigBuilder(options.config['mode']);

class ConfigBuilder extends Builder {
  @override
  final buildExtensions = const {
    //TODO make this react on all lib/config/*properties, then output and extract tar, so we can be sure that stuff gets rebuilt
    //TODO create explicit builder for template html and css file(s)
    '.buildConfig': const ['.tar.gz']
  };

  // We'll populate a parser to later inject properties into static files (e.g. html, css, php)
  KeyValuePropertiesParser _propertiesParser = new KeyValuePropertiesParser();
  Properties _properties = new Properties();
  String mode;

  ConfigBuilder(this.mode) {}

  @override
  Future<void> build(BuildStep buildStep) async {
    // Each [buildStep] has a single input. We ignore it, though.
    var inputId = buildStep.inputId;

    // Collect and merge private config files.
    await _mergeFiles('lib/config/$mode/private*.properties', buildStep);

    // Collect, merge, and write language files.
    // TODO: support more languages
    await _mergeFiles('lib/config/locale/en/*.properties', buildStep,
        writeTo: path.join('web', 'config', 'locale', 'en.properties'));

    // Collect, merge, and write public config files.
    await _mergeFiles('lib/config/$mode/public*.properties', buildStep,
        writeTo: path.join('web', 'config', 'project.properties'));

    // Read content of index.html, css template
    var html = await buildStep.readAsString(new AssetId(inputId.package,
        path.join('lib', 'config', 'web', 'index.template.html')));
    var css = await buildStep.readAsString(new AssetId(inputId.package,
        path.join('lib', 'config', 'web', 'project.template.css')));

    // Inject properties
    html = html.replaceAllMapped(
        new RegExp('@(.+)@'), (m) => _properties.getProperty(m[1]) ?? m[0]);
    css = css.replaceAllMapped(
        new RegExp('@(.+)@'), (m) => _properties.getProperty(m[1]) ?? m[0]);

    // Write to web/ directory
    _writeFiles(path.join('web', 'index.html'), html);
    _writeFiles(path.join('web', 'html', 'css', 'project.css'), css);

    //TODO add server copy and inject stuff here

    //TODO write tar via build system instead of direct writing files (hack)
    //var archive = new Archive();
    //var archiveId = inputId.changeExtension('tar.gz');
    //return buildStep.writeAsBytes(archiveId, new TarEncoder().encode(archive));
  }

  Future<void> _mergeFiles(String pattern, BuildStep buildStep,
      {String writeTo}) async {
    final files = <String>[];
    await for (final input in buildStep.findAssets(new Glob(pattern))) {
      String content = await buildStep.readAsString(input);
      // TODO remove comments and whitespace
      // Parse properties from content
      _propertiesParser.parseProperties(content, _properties);
      // Add content to merge list
      files.add(content);
    }

    if (writeTo != null) {
      _writeFiles(writeTo, files.join('\n'));
    }
  }

  Future<void> _writeFiles(String fileName, String languageContent) {
    print("writing to: $fileName");
    var file = new File(fileName);
    file.createSync(recursive: true);
    file.writeAsStringSync(languageContent);
  }
}
