part of acanvas_generator;

class ProjectCommand extends AcanvasCommand {
  ProjectCommand(CliLogger logger, Target writeTarget)
      : super(logger, writeTarget) {
    packageName = _getPackageNameFromDirectory();
    name = "project";
    description =
        "Create a full acanvas project with optional plugins and examples.";

    Map<String, String> argsMap = new Map<String, String>();

    //argsMap["stagexl"] = "Install StageXL Minimal Template";
    argsMap["stagexlExamples"] =
        "Install StageXL Examples (sprite sheets, tweening, ect.)";

    argsMap["material"] = "Add Material Design Extension to Acanvas";
    argsMap["materialExamples"] = "Install Material Design Examples";
    argsMap["google"] = "Add Google API Extension to Acanvas";
    argsMap["googleExamples"] = "Install Google API Examples";
    argsMap["facebook"] = "Add Facebook Extension to Acanvas";
    argsMap["facebookExamples"] = "Install Facebook API Examples";
    argsMap["physics"] = "Add Physics Extension to Acanvas";
    argsMap["physicsExamples"] = "Install Physics Examples";
    argsMap["ugc"] =
        "Add User Generated Content (UGC) Extension to Acanvas, needs LAMP";
    argsMap["ugcExamples"] = "Install UGC Examples";
    argsMap["babylon"] = "Add BabylonJS Extension to Acanvas";
    argsMap["babylonExamples"] = "Install BabylonJS Examples";

    //StageXL Options
    argsMap["bitmapFont"] = "Add BitmapFont Extension to StageXL";
    argsMap["bitmapFontExamples"] = "Install BitmapFont Examples";
    argsMap["dragonBones"] = "Add Dragonbones Extension to StageXL";
    argsMap["dragonBonesExamples"] = "Install Dragonbones Examples";
    argsMap["flump"] = "Add Flump Extension to StageXL";
    argsMap["flumpExamples"] = "Install Flump Examples";
    argsMap["gaf"] = "Add GAF Extension to StageXL";
    argsMap["gafExamples"] = "Install GAF Examples";
    argsMap["spine"] = "Add Spine Extension to StageXL";
    argsMap["spineExamples"] = "Install Spine Examples";
    argsMap["isometric"] = "Add Isometric Extension to StageXL";
    argsMap["isometricExamples"] = "Install Isometric Example";
    argsMap["particle"] = "Add Particle Extension to StageXL";
    argsMap["particleExamples"] = "Install Particle Example";

    //Demos
    argsMap["moppiFlowerExamples"] = "Install Flower Demo";

    argsMap.forEach((flag, description) {
      argParser.addFlag(flag, negatable: false, help: description);
    });
  }

  @override
  void run() async {
    // Require override option if file exists or dir not empty
    if (!globalResults.wasParsed('override') && !_exists(writeTarget.cwd)) {
      String err =
          'The target file or directory exists and is not empty. Use --override to force overwriting.';

      try {
        usageException(err);
      } on UsageException catch (e) {
        logger.stderr(e.toString());
      }
      return;
    }

    await _prepare();

    // Write out files
    await generate(_getPackageNameFromDirectory());

    logger.stdout(
        "Done. To run your new app, first run 'pub get', and then 'pub serve'\n");
  }

  Future _prepare() async {
    bool hasExamples =
        argResults.arguments.where((t) => t.contains("Examples")).length > 0;

    //tODO use argsMap.keys
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

    examples.forEach((element) {
      // Remove plugin and example content assets from source list according to option
      if (!_installOption(element)) {
        // Configuration and language properties
        project_data.data.removeWhere(
            (t) => t.contains("plugin-${element.toLowerCase()}.properties"));
      }
      if (!_installExamples(element)) {
        // Assets
        project_data.data
            .removeWhere((t) => t.contains("assets/${element.toLowerCase()}/"));
        // Classes
        project_data.data.removeWhere(
            (t) => t.contains("lib/examples/${element.toLowerCase()}"));
        // Configuration and language properties
        project_data.data.removeWhere((t) =>
            t.contains("plugin-${element.toLowerCase()}-examples.properties"));
      }
    });

    // remove sandbox content
    project_data.data.removeWhere((t) => t.contains("sandbox/"));

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

    TemplateFile packageImports =
        templates.firstWhere((t) => t.path.contains("acanvas_template.dart"));
    TemplateFile projectConfig =
        templates.firstWhere((t) => t.path.contains("\/project.dart"));
    TemplateFile pluginImports = templates
        .firstWhere((t) => t.path.contains("acanvas_template_plugins.dart"));
    TemplateFile pluginBootstrap =
        templates.firstWhere((t) => t.path.contains("\/plugins.dart"));
    TemplateFile pubspec =
        templates.firstWhere((t) => t.path.contains("pubspec.yaml"));

    // if NO examples are to be generated at all, we want a simpler home page example
    if (!hasExamples) {
      // Remove advanced view class imports
      var reg = new RegExp(
          '\\/\\/ ### ADVANCED SCREEN CONFIG[\\s\\S]*?\\/\\/ ### END ADVANCED SCREEN CONFIG');
      packageImports.content = packageImports.content.replaceAll(reg, '');
      //uncomment BASIC SCREEN CONFIG
      reg = new RegExp(
          '\\/\\/ ### BASIC SCREEN CONFIG\n\\s*\\/\\*([\\s\\S]*?)\\*\\/\n\\s*\\/\\/ ### END BASIC SCREEN CONFIG');
      packageImports.content = packageImports.content.replaceAllMapped(
          reg, (m) => '// ### BASIC SCREEN CONFIG\n\t\t${m[1]}');
      projectConfig.content = projectConfig.content.replaceAllMapped(
          reg, (m) => '// ### BASIC SCREEN CONFIG\n\t\t${m[1]}');
    } else {
      var reg = new RegExp(
          '\\/\\/ ### BASIC SCREEN CONFIG[\\s\\S]*?\\/\\/ ### END BASIC SCREEN CONFIG');
      packageImports.content = packageImports.content.replaceAll(reg, '');
    }

    //check flag values of extensions
    examples.forEach((ext) {
      //uninstall plugin, examples from imports, bootstrap
      if (!_installOption(ext)) {
        pluginImports.content =
            _uninstallPluginFromClass(ext, pluginImports.content);

        pluginBootstrap.content =
            _uninstallPluginFromClass(ext, pluginBootstrap.content);
        pubspec.content = _uninstallPluginFromYaml(ext, pubspec.content);
      }
      if (!_installExamples(ext)) {
        pluginImports.content =
            _uninstallPluginFromClass('$ext-example', pluginImports.content);

        pluginBootstrap.content =
            _uninstallPluginFromClass('$ext-example', pluginBootstrap.content);
      }
    });

    // Iterate over target list
    for (TemplateFile file in templates) {
      addTemplateFile(file);
    }

    if (!hasExamples) {
      // Install basic_data, overwriting some files from master_data
      List<TemplateFile> files =
          await decodeConcanenatedData(minimal_data.data, minimal_data.type);

      for (TemplateFile file in files) {
        addTemplateFile(file);
      }
    }
  }

  /// Removes references to plugin from plugins.dart
  String _uninstallPluginFromClass(String plugin, String content) {
    plugin = plugin.toLowerCase();
    content = content.replaceAll(
        new RegExp("\\/\\/$plugin\\s*\\n\\s*"), "//$plugin\n\t\t\t//");
    return content;
  }

  /// Removes references to plugin from pubspec.yaml
  String _uninstallPluginFromYaml(String plugin, String content) {
    plugin = plugin.toUpperCase();
    var reg = new RegExp('### $plugin[\\s\\S]*?### END $plugin');
    content = content.replaceAll(reg, '### $plugin');
    return content;
  }

  /// Return true if there are any non-symlinked, non-hidden sub-directories in
  /// the given directory.
  bool _exists(Directory dir) {
    var isHiddenDir = (dir) => basename(dir.path).startsWith('.');

    return dir
        .listSync(followLinks: false)
        .where((entity) => entity is Directory)
        .where((entity) => !isHiddenDir(entity))
        .isEmpty;
  }

  bool _installOption(String element) {
    return argParser.options.containsKey(element) &&
        (_installExamples(element) || argResults[element]);
  }

  bool _installExamples(String element) {
    return argParser.options.containsKey("${element}Examples") &&
        argResults["${element}Examples"];
  }
}
