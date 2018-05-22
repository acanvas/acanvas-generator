// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library rockdot_generator.rockdot.project;

import 'dart:async';
import 'package:args/args.dart';
import '../rockdot_generator.dart';
import '../src/common.dart';
import 'data/rdf-project_data.g.dart' as project_data;
import 'data/rdf-minimal_data.g.dart' as basic_data;

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
    bool hasExamples =
        options.arguments.where((t) => t.contains("Examples")).length > 0;

    List<String> examples = [
      "stagexl",
      "material",
      "google",
      "facebook",
      "physics",
      "babylon",
      "bitmapFont",
      "dragonBones",
      "flump",
      "gaf",
      "spine",
      "isometric",
      "particle",
      "ugc",
      "moppiFlower" //examples only
    ];

    bool deleteExample = false;
    examples.forEach((element) {
      deleteExample = false;

      // Remove plugins from source list according to option
      if (!options[element]) {
        // Assets
        project_data.data
            .removeWhere((t) => t.contains("assets/${element.toLowerCase()}/"));

        // Configuration and language properties
        project_data.data.removeWhere(
            (t) => t.contains("plugin-${element.toLowerCase()}.properties"));

        // Set flag to delete examples for this plugin, too
        deleteExample = true;
      }

      // Remove example content assets from source list according to option
      if (!options["${element}Examples"] || deleteExample) {
        // classes and assets
        project_data.data.removeWhere(
            (t) => t.contains("lib/examples/${element.toLowerCase()}"));
        // configuration and language properties
        project_data.data.removeWhere((t) =>
            t.contains("plugin-${element.toLowerCase()}-examples.properties"));
      }
    });

    // if NO examples are to be generated at all, we want a simpler home page example
    if (!hasExamples) {
      // Skip config and view/element
      project_data.data.removeWhere((t) => t.contains("config/"));
      project_data.data.removeWhere((t) => t.contains("view/element/"));
      project_data.data.removeWhere((t) => t.contains("displacement"));
    }

    // Copy all assets from source list (everything inside templates/rdf-project/) to the target list
    List<TemplateFile> templates =
        await decodeConcanenatedData(project_data.data, project_data.type);

    TemplateFile packageImports = templates
        .firstWhere((t) => t.content.contains("rockdot_template.dart"));
    TemplateFile pluginImports = templates
        .firstWhere((t) => t.content.contains("rockdot_template_plugins.dart"));
    TemplateFile pluginBootstrap =
        templates.firstWhere((t) => t.content.contains("\/plugins.dart"));
    TemplateFile pubspec =
        templates.firstWhere((t) => t.content.contains("pubspec.yaml"));

    // if NO examples are to be generated at all, we want a simpler home page example
    if (!hasExamples) {
      // Remove advanced view class imports
      var reg = new RegExp(
          '?<=\\/\\/ ### ADVANCED SCREEN CONFIG(?s).*?=\\/\\/ ### END ADVANCED SCREEN CONFIG');
      packageImports.content = packageImports.content
          .replaceAll(reg, '// ### ADVANCED SCREEN CONFIG');
    } else {
      var reg = new RegExp(
          '?<=\\/\\/ ### BASIC SCREEN CONFIG(?s).*?=\\/\\/ ### END BASIC SCREEN CONFIG');
      packageImports.content =
          packageImports.content.replaceAll(reg, '// ### BASIC SCREEN CONFIG');
    }

    //check flag values of extensions
    examples.forEach((ext) {
      bool deleteExample = false;

      //uninstall plugin from bootstrap
      if (options.options.contains(ext) && !options[ext]) {
        pluginImports.content =
            _uninstallPluginImports(ext, pluginImports.content);
        pluginBootstrap.content =
            _uninstallPluginBootstrap(ext, pluginBootstrap.content);
        pubspec.content = _uninstallPluginFromYaml(ext, pubspec.content);
        deleteExample = true;
      }

      //uninstall examples from bootstrap
      if (!options[ext] || deleteExample) {
        pluginImports.content =
            _uninstallPluginExamplesImports(ext, pluginImports.content);
        pluginBootstrap.content =
            _uninstallPluginExamplesBootstrap(ext, pluginBootstrap.content);
      }
    });

    // Iterate over target list
    for (TemplateFile file in templates) {
      addTemplateFile(file);
    }

    // Install basic_data, overwriting some files from master_data (e.g. transformer)
    List<TemplateFile> files =
        await decodeConcanenatedData(basic_data.data, basic_data.type);

    for (TemplateFile file in files) {
      // Do not install simple elements if examples get installed (keeping the sophisticated ones from master_data).
      if (file.path.contains("view/element/") && hasExamples) {
        continue;
      }

      addTemplateFile(file);
    }

    setEntrypoint(getFile('web/index.html'));
  }

  /// Removes references to plugin from plugins.dart
  String _uninstallPluginBootstrap(String plugin, String content) {
    switch (plugin) {
      case "physics":
        //do nothing, it's not a plugin
        break;
      default:
        plugin = plugin[0].toUpperCase() + plugin.substring(1);
        content = content.replaceAllMapped(
            new RegExp("new ${plugin}Plugin([^,]+)"),
            (m) => "//new ${plugin}Plugin${m[1]},");
        break;
    }

    return content;
  }

  /// Removes references to plugin example from plugins.dart
  String _uninstallPluginExamplesBootstrap(String plugin, String content) {
    plugin = plugin[0].toUpperCase() + plugin.substring(1);
    if (plugin == "Gaf") {
      plugin = "GAF"; //stupid hack
    }
    print("uninstalling ${plugin}");
    content = content.replaceAllMapped(
        new RegExp("new ${plugin}ExamplePlugin([^,]+)"),
        (m) => "//new ${plugin}ExamplePlugin${m[1]},");
    return content;
  }

  /// Removes references to plugin from rockdot_template_plugins.dart
  String _uninstallPluginImports(String plugin, String content) {
    plugin = plugin.toLowerCase();
    content =
        content.replaceAll(new RegExp("\\/\\/$plugin\\s*\\n\\s*"), "//$plugin");
    return content;
  }

  /// Removes references to plugin example from rockdot_template_plugins.dart
  String _uninstallPluginExamplesImports(String plugin, String content) {
    plugin = plugin.toLowerCase();
    content = content.replaceAll(
        new RegExp("\\/\\/$plugin-examples\\s*\\n\\s*"), "//$plugin-examples");
    return content;
  }

  /// Removes references to plugin from pubspec.yaml
  String _uninstallPluginFromYaml(String plugin, String content) {
    plugin = plugin.toUpperCase();
    var reg = new RegExp('?<=### $plugin(?s).*?=### END $plugin');
    content = content.replaceAll(reg, '### $plugin');
    return content;
  }

  String getInstallInstructions() => "${super.getInstallInstructions()}\n"
      "to run your app, use 'pub serve' and hit http://localhost:xxxx in the browser\n";
}
