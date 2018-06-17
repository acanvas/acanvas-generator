part of acanvas_generator;

class PluginCommand extends AcanvasCommand {
  static final String DEFAULT_PLUGIN_NAME = "GeneratedPlugin";

  static final String TEMPLATE_DIR = "plugin/";
  static final String PACKAGE_REPLACE_STRING = "@package@";

  static final String PLUGIN_REPLACE_STRING = "@plugin@";
  static final String PLUGIN_UPPERCASE_REPLACE_STRING = "@pluginUpperCase@";
  static final String PLUGIN_LOWERCASE_REPLACE_STRING = "@pluginLowerCase@";

  static final String PLUGIN_INSERTION_PLACEHOLDER =
      "// ## PLUGIN INSERTION PLACEHOLDER - DO NOT REMOVE ## //";

  static final String DIR_LIB = "lib";
  static final String DIR_BOOTSTRAP = "$DIR_LIB/src/bootstrap";
  static final String DIR_PROJECT = "$DIR_LIB/src/project";
  static final String DIR_PLUGIN = "$DIR_LIB/src/plugin";

  String pluginNameCamelCase;
  String pluginNameUnderscored;
  String pluginNameUnderscoredUppercase;

  PluginCommand(CliLogger logger, Target writeTarget)
      : super(logger, writeTarget) {
    packageName = _getPackageNameFromDirectory();
    name = "plugin";
    description = "Create a acanvas plugin within your project.";

    argParser.addOption('name',
        abbr: 'n',
        defaultsTo: DEFAULT_PLUGIN_NAME,
        help: 'The name (in CamelCase) of the plugin to be generated.',
        valueHelp: 'name', callback: (_pluginName) {
      pluginNameCamelCase = _pluginName;
    });
  }

  @override
  void run() async {
    pluginNameUnderscored = _getPluginNameUnderscored();
    pluginNameUnderscoredUppercase = pluginNameUnderscored.toUpperCase();

    await _prepare();

    await generate(_getPackageNameFromPubspec());

    _insertPlugin();

    logger.stdout(
        "Done. You can now use the plugin like this: \n\t new AcSignal(${pluginNameCamelCase}Events.SAMPLE, new ${pluginNameCamelCase}VO('message').dispatch();");
  }

  Future _prepare() async {
    var data =
        skeletons_data.data.where((e) => e.contains(TEMPLATE_DIR)).toList();

    String libraryParts = "";
    String dirName;
    String baseName;
    String normd;

    // Copy all assets from source list (everything inside templates/rdf-skeletons/plugin/) to the target list
    List<TemplateFile> templates =
        await decodeConcanenatedData(data, skeletons_data.type);
    templates.forEach((e) {
      dirName = dirname(e.path).replaceFirst(new RegExp(TEMPLATE_DIR), '');
      baseName = basename(e.path);
      baseName =
          baseName.replaceFirst(new RegExp("plugin"), pluginNameUnderscored);
      normd =
          normalize("src/plugin/$pluginNameUnderscored/${dirName}/${baseName}");

      libraryParts += "part '$normd';\n";

      e.path = "lib/$normd";
      e.content =
          e.content.replaceAll(new RegExp(PACKAGE_REPLACE_STRING), packageName);
      e.content = e.content
          .replaceAll(new RegExp(PLUGIN_REPLACE_STRING), pluginNameCamelCase);
      e.content = e.content.replaceAll(
          new RegExp(PLUGIN_LOWERCASE_REPLACE_STRING), pluginNameUnderscored);
      e.content = e.content.replaceAll(
          new RegExp(PLUGIN_UPPERCASE_REPLACE_STRING),
          pluginNameUnderscoredUppercase);

      addTemplateFile(e);
    });

    _addToPackage(libraryParts);
  }

  ///add plugin instantiation call to [DIR_BOOTSTRAP]/ac_bootstrap.dart
  void _insertPlugin() {
    String replace = '''new ${pluginNameCamelCase}Plugin(),
      $PLUGIN_INSERTION_PLACEHOLDER''';

    File file = new File("$DIR_BOOTSTRAP/ac_bootstrap.dart");
    String fileContent = file.readAsStringSync();
    fileContent = fileContent.replaceFirst(
        new RegExp(PLUGIN_INSERTION_PLACEHOLDER), replace);
    file.writeAsStringSync(fileContent);
  }

  /// Adds file imports to the project's package definition file
  void _addToPackage(String defs) {
    String replace = '''$defs
    $PLUGIN_INSERTION_PLACEHOLDER
  ''';

    File file = new File("$DIR_LIB/$packageName.dart");
    String fileContent = file.readAsStringSync();
    fileContent = fileContent.replaceFirst(
        new RegExp(PLUGIN_INSERTION_PLACEHOLDER), replace);
    file.writeAsStringSync(fileContent);
  }

  String _getPluginNameUnderscored() {
    return pluginNameCamelCase
        .replaceAllMapped(new RegExp("([^A-Z-])([A-Z])"),
            (Match m) => (m.group(1) + "_" + m.group(2)))
        .toLowerCase();
  }
}
