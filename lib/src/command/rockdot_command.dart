part of rockdot_generator;

abstract class RockdotCommand extends Command {
  final List<TemplateFile> files = [];
  String packageName;
  // The [name] and [description] properties must be defined by every
  // subclass.
  @override
  String name;
  @override
  String description;
  CliLogger logger;
  Target writeTarget;

  RockdotCommand(this.logger, this.writeTarget);

  /// Add a new template file.
  TemplateFile addTemplateFile(TemplateFile file, [bool append = false]) {
    TemplateFile existingFile =
        files.firstWhere((t) => t.path == file.path, orElse: () => null);
    if (existingFile != null) {
      files.removeWhere((t) => t.path == existingFile.path);
      if (append && !_isBinaryFile(existingFile.path)) {
        file.content = existingFile.content + file.content;
      }
    }

    files.add(file);
    return file;
  }

  Future generate(String projectName, {Map<String, String> additionalVars}) {
    Map<String, String> vars = {
      'projectName': projectName,
      'rockdot_template': projectName,
      'description': description,
      'year': new DateTime.now().year.toString()
    };

    if (additionalVars != null) {
      additionalVars.keys.forEach((key) {
        vars[key] = additionalVars[key];
      });
    }

    if (!vars.containsKey('author')) {
      vars['author'] = '<your name>';
    }

    return Future.forEach(files, (TemplateFile file) {
      var resultFile = file.runSubstitution(vars);
      String filePath = resultFile.path;
      filePath = filePath.replaceAll('rockdot_template', projectName);

      return _createFile(filePath, resultFile.content);
    });
  }

  Future _createFile(String filePath, List<int> contents) {
    writeTarget.createFile(filePath, contents);
  }

  final RegExp _binaryFileTypes = new RegExp(
      r'\.(mp3|ogg|zip|gaf|webp|fnt|jpe?g|png|gif|ico|svg|ttf|eot|woff|woff2)$',
      caseSensitive: false);

  Future<List<TemplateFile>> decodeConcanenatedData(
      List<String> data, String pack) async {
    List<TemplateFile> results = [];
    Resource myResource;
    ResourceLoader loader = new DefaultLoader();
    int counter = 1;

    for (int i = 0; i < data.length; i++) {
      String path = data[i];

      await new Future.delayed(const Duration(milliseconds: 100));

      myResource = new Resource(
          'package:rockdot_generator/templates/${pack}/${path}',
          loader: loader);

      print("${counter} - template: ${pack}, resource: $path");

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
          String source = await myResource.readAsString(encoding: utf8);
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

  /// Returns true if the given [filename] matches common image file name patterns.
  bool _isBinaryFile(String filename) {
    List<String> split = filename.split("/");
    return _binaryFileTypes.hasMatch(split[split.length - 1]);
  }

  String _getPackageNameFromPubspec() {
    if(!new File('pubspec.yaml').existsSync()){
      return "this_name_should_not_happen";
    }
    File pubspecRootFile = new File('pubspec.yaml').absolute;
    String pubspecRootFileContent = pubspecRootFile.readAsStringSync();
    return new RegExp("name\\s*:\\s*(\\w+)")
        .firstMatch(pubspecRootFileContent)
        .group(1);
  }

  /// retrieves the project's package name from its root pubspec.yaml.
  String _getPackageNameFromDirectory() {
    String projectName = basename(writeTarget.cwd.path);
    projectName = normalizeProjectName(projectName);
    return projectName;
  }

  /// Convert a directory name into a reasonably legal pub package name.
  String normalizeProjectName(String name) {
    name = name.replaceAll('-', '_').replaceAll(' ', '_');

    // Strip any extension (like .dart).
    if (name.contains('.')) {
      name = name.substring(0, name.indexOf('.'));
    }

    return name;
  }
}
