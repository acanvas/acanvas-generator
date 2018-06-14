part of rockdot_generator;

class FileTarget implements Target {
  Directory _cwd = Directory.current;
  @override
  Directory get cwd => _cwd;

  @override
  Future createFile(String path, List<int> contents) {
    var dir = Directory.current;
    File file = new File(join(dir.path, path));

    print('  ${file.path}');

    return file
        .create(recursive: true)
        .then((_) => file.writeAsBytes(contents));
  }
}

abstract class Target {
  Directory get cwd;
  Future createFile(String path, List<int> contents);
}
