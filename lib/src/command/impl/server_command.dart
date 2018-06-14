part of rockdot_generator;

class ServerCommand extends RockdotCommand {
  final String SERVER_DIR = "server";
  final String DEFAULT_MODE = "debug";

  final String PREFIX = "@";
  final String POSTFIX = "@";

  String mode;
  Properties properties = new Properties();

  ServerCommand(CliLogger logger, Target writeTarget):super(logger, writeTarget) {

    argParser.addFlag('update',
        abbr: 'u',
        negatable: false,
        help: "Update an existing server by copying from 'source' to 'target'.",
      );

    argParser.addOption('mode',
        abbr: 'm',
        defaultsTo: DEFAULT_MODE,
        help:
        'The configuration mode to use. Can be either debug or release. Defaults to debug.',
        valueHelp: 'mode', callback: (_mode) {
          mode = _mode;
        });
  }

  // [run] may also return a Future.
  void run() async {

    if(argResults["update"]){
      _setupProperties(mode);
      String source = join(SERVER_DIR, 'source');
      String target = join(SERVER_DIR, 'target');
      _recursiveFolderCopySync(source, target);
    }else{
      List<TemplateFile> templates =
      await decodeConcanenatedData(server_data.data, server_data.type);
      templates.forEach((t){
        addTemplateFile(t);
      });

      await generate(_getPackageNameFromPubspec());
    }

  }

  void _setupProperties(String mode) {
    //setup properties
    List<String> propertyFiles = [
      "config/$mode/server.properties",
      "config/$mode/private.properties",
      "config/$mode/public.properties"
    ];
    KeyValuePropertiesParser propertiesParser = new KeyValuePropertiesParser();
    propertyFiles.forEach((String path) {
      String source = new File(path).readAsStringSync();
      propertiesParser.parseProperties(source, properties);
    });
  }

  _recursiveFolderCopySync(String path1, String path2) /*async */ {
    Directory dir1 = getDirectory(path1, create: false);
    if (dir1 == null) {
      return;
    }
    Directory dir2 = getDirectory(path2);

    dir1.listSync(recursive: true, followLinks: false).forEach((element) {
      String newPath = "${dir2.path}${element.path.replaceAll(dir1.path, '')}";

      //treat files
      if (element is File) {
        //ensure existence of file
        File newFile = new File(newPath);
        if (!newFile.existsSync()) {
          newFile.createSync(recursive: true);
        }

        //treat non-binary files: replace placeholders with property content
        if (!_isBinaryFile(element.path)) {
          String newContent = element.readAsStringSync();
          properties.propertyNames.forEach((String name) {
            newContent = newContent.replaceAll(
                '${PREFIX}${name}${POSTFIX}', properties.getProperty(name));
          });
          newFile.writeAsStringSync(newContent);
        }
        //treat binary files
        else {
          newFile.writeAsBytesSync(element.readAsBytesSync());
        }
      } else if (element is Directory) {
        getDirectory(newPath);
      } else {
        throw new Exception('File is neither File nor Directory. HOW?!');
      }
    });
  }

  void _installUGC() async{
    if (argResults["ugc"]) {
      //Download zend.zip, extract to server/target/Zend
      logger.stdout("Downloading Zend for your UGC backend ...");

      new Directory(join('server', 'target', 'zend'))
          .createSync(recursive: true);

      HttpClientRequest request = await new HttpClient().getUrl(Uri.parse(
          'http://rockdot.sounddesignz.com/downloads/rockdot-zend-library.zip'));
      HttpClientResponse response = await request.close();
      File file =
      new File(join('server', 'rockdot-zend-library.zip'));
      await response.pipe(file.openWrite());

      logger.stdout("Extracting Zend for your UGC backend ...");

      List<int> bytes = file.readAsBytesSync();
      Archive archive = new ZipDecoder().decodeBytes(bytes);

      // Extract the contents of the Zip archive to disk.
      for (ArchiveFile file in archive) {
        if (file.isFile) {
          String filename = file.name;
          List<int> data = file.content;
          new File(join('server', 'target', filename))
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        }
      }

      file.deleteSync();
    }
  }

  Directory getDirectory(String s, {bool recursive: true, bool create: true}) {
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
}
