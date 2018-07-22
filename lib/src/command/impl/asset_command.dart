part of acanvas_generator;

class AssetCommand extends AcanvasCommand {
  static final String PACKAGE_REPLACE_STRING = "@package@";
  static final String GETTER_REPLACE_STRING = "@getter@";
  static final String MAPENTRY_REPLACE_STRING = "@entry@";

  static final String ASSETNAME_REPLACE_STRING = "@asset@";
  static final String ASSETNAM_SAFE_REPLACE_STRING = "@asset_stripped@";
  static final String ASSETTYPE_REPLACE_STRING = "@type@";
  static final String ASSETDIR_REPLACE_STRING = "@dir@";

  static final String DEFAULT_ASSET_SOURCE_DIR = "web/assets/autoload";
  static final String DEFAULT_ASSET_TARGET_FILE =
      "lib/src/project/model/assets.dart";
  static final String TEMPLATE_SOURCE = "assets.dart";

  String assetSourceDir = DEFAULT_ASSET_SOURCE_DIR;
  String assetClassFile = DEFAULT_ASSET_TARGET_FILE;

  AssetCommand(CliLogger logger, Target writeTarget)
      : super(logger, writeTarget) {
    packageName = _getPackageNameFromPubspec();
    name = "collect";
    description =
        "Collect assets from a source path and generate an asset model class.";

    argParser.addOption('source',
        abbr: 's',
        defaultsTo: DEFAULT_ASSET_SOURCE_DIR,
        help: 'The source directory where to search the assets.',
        valueHelp: 'sourcedir', callback: (_sourceDir) {
      assetSourceDir = _sourceDir;
    });

    argParser.addOption('target',
        abbr: 't',
        defaultsTo: DEFAULT_ASSET_TARGET_FILE,
        help: 'The target class, <path><filename>.dart',
        valueHelp: 'targetfile', callback: (_targetFile) {
      assetClassFile = _targetFile;
    });
  }

  @override
  void run() async {
    // [argResults] is set before [run()] is called and contains the options
    // passed to this command.

    // just decode skeletons_data.data["assets.dart"]
    String assetClassFilePath = skeletons_data.data
        .firstWhere((path) => path.contains(TEMPLATE_SOURCE));

    List<TemplateFile> templates = await decodeConcanenatedData(
        <String>[assetClassFilePath], skeletons_data.type);

    TemplateFile templateFile = templates.first;
    templateFile.path = assetClassFile;

    templateFile.content = _scanAndInsert(templateFile.content);
    addTemplateFile(templateFile);

    //this writes to templateFile.content
    logger.stdout(
        "Collecting assets from $assetSourceDir and generate an asset model class file $assetClassFile.");

    await generate(_getPackageNameFromPubspec());

    logger.stdout(
        "Done. You can now access Assets like this: \n\tBitmapData bmd = Assets.assetname \n\tSound snd = Assets.assetname");
  }

  String _scanAndInsert(String templateFile) {
    String imageGetter = '''
  static BitmapData get @asset_stripped@ {
    return _singleton.mgr.getBitmapData("@asset_stripped@");
  }
''';
    String soundGetter = '''
  static Sound get @asset@ {
    return _singleton.mgr.getSound("@asset@");
  }
''';

    String imageEntry =
        '_singleton.mgr.addBitmapData("@asset_stripped@", "@dir@/@asset@.@type@");\n\t\t';
    String soundEntry =
        '_singleton.mgr.addSound("@asset@", "@dir@/@asset@.@type@");\n\t\t';

    String generatedGetters = "";
    String generatedEntries = "";

    // Traverse asset source directory and create class entries
    Directory sourceDir = new Directory(assetSourceDir);
    if (sourceDir.existsSync()) {
      sourceDir
          .listSync(recursive: true, followLinks: false)
          .forEach((FileSystemEntity entity) {
        if (FileSystemEntity.typeSync(entity.path) ==
            FileSystemEntityType.file) {
          String ext = extension(entity.path).toLowerCase().substring(1);
          String dir = dirname(entity.path);
          String baseName = basenameWithoutExtension(entity.path).toLowerCase();
          if (!baseName.contains(new RegExp("@[23]+x"))) {
            String baseNameStripped = baseName.replaceFirst("@1x", "").replaceAll("-", "_");
            if (ext == "jpg" || ext == "png") {
              generatedGetters += imageGetter
                  .replaceAll(ASSETNAME_REPLACE_STRING, baseName)
                  .replaceAll(ASSETNAM_SAFE_REPLACE_STRING, baseNameStripped);
              generatedEntries += imageEntry
                  .replaceAll(ASSETNAME_REPLACE_STRING, baseName)
                  .replaceAll(ASSETNAM_SAFE_REPLACE_STRING, baseNameStripped)
                  .replaceAll(ASSETTYPE_REPLACE_STRING, ext)
                  .replaceAll(ASSETDIR_REPLACE_STRING, dir)
                  .replaceAll('web\/', '');
            }
            if (ext == "mp3") {
              generatedGetters +=
                  soundGetter.replaceAll(ASSETNAME_REPLACE_STRING, baseName);
              generatedEntries += soundEntry
                  .replaceAll(ASSETNAME_REPLACE_STRING, baseName)
                  .replaceAll(ASSETTYPE_REPLACE_STRING, ext)
                  .replaceAll(ASSETDIR_REPLACE_STRING, dir)
                  .replaceAll('web\\/', '');
            }
          }
        }
      });

      // replace all [GETTER_REPLACE_STRING], [MAPENTRY_REPLACE_STRING] and [PACKAGE_REPLACE_STRING].
      templateFile = templateFile.replaceAll(
          new RegExp(GETTER_REPLACE_STRING), generatedGetters);
      templateFile = templateFile.replaceAll(
          new RegExp(MAPENTRY_REPLACE_STRING), generatedEntries);
      templateFile = templateFile.replaceAll(
          new RegExp(PACKAGE_REPLACE_STRING), packageName);
      return templateFile;
    } else {
      throw new StateError(
          "The directory that was provided as source directory does not exist: $assetSourceDir");
    }
  }
}
