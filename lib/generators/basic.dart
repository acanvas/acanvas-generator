// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library rockdot_generator.rockdot.basic;

import '../rockdot_generator.dart';
import '../src/common.dart';
import 'dart:async';
import 'master_data.dart' as master_data;
import 'basic_data.dart' as basic_data;
import 'facebook_data.dart' as facebook_data;
import 'google_data.dart' as google_data;
import 'material_data.dart' as material_data;
import 'physics_data.dart' as physics_data;
import 'ugc_data.dart' as ugc_data;
import 'package:args/args.dart';

/**
 * A generator for a template web application.
 */
class BasicGenerator extends DefaultGenerator {
  ArgResults options;
  TemplateFile pubspecTemplateFile;

  BasicGenerator()
      : super('basic', 'röckdöt framewörk Basic Template',
            "A mobile-friendly html5 canvas app with röckdöt's convenience implementations for routing, responsiveness, showcasing material design and physics.",
            categories: const ['dart', 'web']) {}

  /**
     * 'master_data' is the full repository, which you can open as a project.
     * this makes development of this library easier for the authors.
     * when generating a project though, the [BasicGenerator]
     * - first resets everything
     * - second, build up the project depending on the
     */
  @override
  Future prepare(ArgResults options) async {
    this.options = options;
    bool hasExamples = options.arguments.where((t) => t.contains("Examples")).length > 0;

    List<String> extensions = [
      "stagexl",
      "material",
      "google",
      "facebook",
      "physics",
      "ugc",
      "babylon",
      "bitmapFont",
      "dragonBones",
      "flump",
      "gaf",
      "spine",
      "isometric",
      "particle"
    ];


    // Remove example content assets from source list according to option
    extensions.forEach((element) {
      if (!options["${element}Examples"]) {
        master_data.data.removeWhere((t) => t.contains("examples/${element.toLowerCase()}"));
      }
    });

    // Copy all assets from source list (files inside the package) to the target list
    List<TemplateFile> templates = await decodeConcanenatedData(master_data.data, "master");

    // Iterate over extensions and add example files to write list, if applicable
    if (hasExamples) {
      extensions.forEach((element) {
        if (options["${element}Examples"]) {
          templates.where((t) => t.path.contains("examples/${element.toLowerCase()}"))
            ..forEach((t) {
              addTemplateFile(t);
              print("adding example: ${t.path}");
            });
        }
      });
    }

    // Remove all examples from source list
    templates.removeWhere((t) => t.path.contains("examples"));

    // Iterate over source list
    for (TemplateFile file in templates) {

      /*
        Skip config and view/element, if NO examples are to be installed
       */
      if (file.path.contains("config/") || (file.path.contains("view/element/") && !hasExamples)) {
        continue;
      }

      /*
        if NO examples are to be generated at all:
       */
      if (!hasExamples) {
        if (file.path.contains("displacement")) {
          continue;
        }

        // IMPORTS
        if (file.path.contains("rockdot_template.dart")) {
          // remove imports for views not needed in simple mode
          file.content = file.content.replaceAll("part 'src/project/view/element/navigation_sidebar.dart';", "");
          file.content = file.content.replaceAll("part 'src/project/view/element/cell/list_menu_cell.dart';", "");
          file.content =
              file.content.replaceAll("part 'src/project/view/element/pager/abstract_photo_pager.dart';", "");
          // activate imports for screen two and layer for simple mode
          file.content = file.content
              .replaceAll("//part 'src/project/view/screen/two.dart'", "part 'src/project/view/screen/two.dart'");
          file.content = file.content
              .replaceAll("//part 'src/project/view/layer/layer.dart'", "part 'src/project/view/layer/layer.dart'");
        }

        // PROJECT PLUGIN
        if (file.path.contains("project/project.dart")) {
          file.content = file.content.replaceAll("//addScreen(ScreenIDs.TWO", "addScreen(ScreenIDs.TWO");
          file.content = file.content.replaceAll("//addLayer(ScreenIDs.LAYER_PHOTO", "addLayer(ScreenIDs.LAYER_PHOTO");
        }
      }

      /*
        Manage Plugin Activation in Bootstrap (plugins.dart) according to command line options
       */
      if (file.path.contains("\/plugins.dart")) {
        //check flag values of extensions
        extensions.forEach((ext) {
          //uninstall all from bootstrap
          if (!options[ext]) {
            file.content = _uninstallPluginBootstrap(ext, file.content);
            file.content = _uninstallPluginExamplesBootstrap(ext, file.content);
          }
          //uninstall only examples from bootstrap
          else if (!options["${ext}Examples"]) {
            file.content = _uninstallPluginExamplesBootstrap("${ext}Examples", file.content);
          }
        });
      }

      /*
        Manage Plugin package imports according to command line options
       */
      if (file.path.contains("rockdot_template_plugins.dart")) {
        //check flag values of extensions
        extensions.forEach((ext) {
          print("extension: $ext ${options[ext]} / examples: ${options["${ext}Examples"]}");

          //uninstall all imports
          if (!options[ext]) {
            file.content = _uninstallPluginImports(ext, file.content);
            file.content = _uninstallPluginExamplesImports(ext, file.content);
          }
          //uninstall only examples imports
          else if (!options["${ext}Examples"]) {
            file.content = _uninstallPluginExamplesImports(ext, file.content);
          }
        });
      }

      addTemplateFile(file);
    } //foreach master_data

    /*
      Install basic_data, overwriting some files from master_data (e.g. transformer)
     */
    List<String> data = basic_data.data;
    List<TemplateFile> files = await decodeConcanenatedData(data, "basic");

    for (TemplateFile file in files) {
      /*
       Do not install simple elements if examples get installed (keeping the sophisticated ones from master_data).
       */
      if (file.path.contains("view/element/") && hasExamples) {
        continue;
      }
      /*
       Save pubspec file for later manipulation
       */
      if (file.path.contains("pubspec.yaml")) {
        pubspecTemplateFile = file;
        continue;
      }

      addTemplateFile(file);
    }

    /*
      Install plugin_data and manage presence of libraries in pubspec.yaml
     */

    if (!options['stagexl']) {
      _addLibraryToRootPubspec("rockdot_framework", "https://github.com/blockforest/rockdot-framework");
    }

    //check flag values of extensions
    extensions.forEach((ext) {
      //uninstall all from bootstrap
      if (options[ext]) {
        switch (ext) {
          case "material":
            _installPluginData(material_data.type, material_data.data);
            break;
          case "facebook":
            _installPluginData(facebook_data.type, facebook_data.data);
            break;
          case "google":
            _installPluginData(google_data.type, google_data.data);
            break;
          case "physics":
            _installPluginData(physics_data.type, physics_data.data);
            _addLibraryToRootPubspec("rockdot_physics", "https://github.com/blockforest/rockdot-physics");
            break;
          case "ugc":
            _installPluginData(ugc_data.type, ugc_data.data);
            break;
          case "babylon":
            _addLibraryToRootPubspec("babylonjs_facade", "https://github.com/blockforest/babylonjs-dart-facade");
            break;
          case "bitmapFont":
          case "dragonBones":
          case "flump":
          case "gaf":
          case "spine":
          case "isometric":
          case "particle":
            _addLibraryToRootPubspec("stagexl_${ext.toLowerCase()}");
            break;
        }
      }
    });

    addTemplateFile(pubspecTemplateFile);

    setEntrypoint(getFile('web/public/index.html'));
  }

  /// Adds dependency to the project's root pubspec.yaml.
  void _addLibraryToRootPubspec(String dart_library_name, [String git_url = null]) {
    String insertionString;
    if (git_url == null) {
      insertionString = '''
dependencies:
  $dart_library_name: any
''';
    } else {
      insertionString = '''
dependencies:
  $dart_library_name:
    git: $git_url
''';
    }

    if (!pubspecTemplateFile.content.contains(dart_library_name)) {
      pubspecTemplateFile.content =
          pubspecTemplateFile.content.split(new RegExp("\\ndependencies\\s*:")).join("\n${insertionString}");
    }
  }

  /// Removes references to plugin from plugins.dart
  String _uninstallPluginBootstrap(String plugin, String content) {
    switch (plugin) {
      case "physics":
        //do nothing, it's not a plugin
        break;
      default:
        plugin = plugin[0].toUpperCase() + plugin.substring(1);
        content = content.replaceAllMapped(new RegExp("new ${plugin}Plugin([^,]+)"), (m) => "//new ${plugin}Plugin${m[1]},");
        break;
    }

    return content;
  }

  /// Removes references to plugin examples from plugins.dart
  String _uninstallPluginExamplesBootstrap(String plugin, String content) {
    plugin = plugin[0].toUpperCase() + plugin.substring(1);
    //TODO doesn't seem to work
    print("uninstalling ${plugin}");
    content = content.replaceAllMapped(new RegExp("new ${plugin}ExamplePlugin([^,]+)"), (m) => "//new ${plugin}ExamplePlugin${m[1]},");
    return content;
  }

  String _uninstallPluginImports(String plugin, String content) {
    plugin = plugin.toLowerCase();
    switch (plugin) {
      case "bitmapfont":
      case "dragonbones":
      case "flump":
      case "gaf":
      case "isometric":
      case "particle":
      case "spine":
        content = content.replaceAll("export 'package:stagexl_${plugin}/stagexl_${plugin}.dart'",
            "//export 'stagexl:rockdot_${plugin}/stagexl_${plugin}.dart'");
        break;
      case "physics":
        content = content.replaceAll("export 'package:rockdot_${plugin}/rockdot_${plugin}.dart'",
            "//export 'package:rockdot_${plugin}/rockdot_${plugin}.dart'");
        break;
      default: //all other rockdot plugins
        content = content.replaceAll("export 'package:rockdot_framework/src/${plugin}.dart'",
            "//export 'package:rockdot_framework/src/${plugin}.dart'");
        break;
    }

    return content;
  }

  String _uninstallPluginExamplesImports(String plugin, String content) {
    plugin = plugin.toLowerCase();
    content = content.replaceAll(
        "export 'examples/${plugin}/${plugin}_example.dart'", "//export 'examples/${plugin}/${plugin}_example.dart'");
    return content;
  }

  _installPluginData(String type, List<String> data) async {
    bool append = false;

    List<TemplateFile> decdata = await decodeConcanenatedData(data, type);
    for (TemplateFile file in decdata) {
      append = false;
      if (file.path.contains(".properties")) {
        append = true;
      }

      addTemplateFile(file, append);
    }
  }

  String getInstallInstructions() => "${super.getInstallInstructions()}\n"
      "to run your app, use 'pub serve'\n";
}
