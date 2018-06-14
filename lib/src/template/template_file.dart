part of rockdot_generator;

/**
 * This class represents a file in a generator template. The contents could
 * either be binary or text. If text, the contents may contain mustache
 * variables that can be substituted (`{{myVar}}`).
 */
class TemplateFile {
  String path;
  String content;

  List<int> _binaryData;

  TemplateFile(this.path, this.content);

  TemplateFile.fromBinary(this.path, this._binaryData) : this.content = null;

  FileContents runSubstitution(Map<String, String> parameters) {
    var newPath = substituteVars(path, parameters);
    var newContents = _createContent(parameters);

    return new FileContents(newPath, newContents);
  }

  bool get isBinary => _binaryData != null;

  List<int> _createContent(Map<String, String> vars) {
    if (isBinary) {
      return _binaryData;
    } else {
      //raw substitution of "rockdot_template" with "${projectName}"
      String c_content =
          content.replaceAll('rockdot_template', vars['projectName']);

      return utf8.encode(substituteVars(c_content, vars));
    }
  }

  /**
   * Given a String [str] with mustache templates, and a [Map] of String key /
   * value pairs, substitute all instances of `{{key}}` for `value`. I.e.,
   *
   *     Foo {{projectName}} baz.
   *
   * and
   *
   *     {'projectName': 'bar'}
   *
   * becomes:
   *
   *     Foo bar baz.
   */
  String substituteVars(String str, Map<String, String> vars) {
    vars.forEach((key, value) {
      String sub = '{{${key}}}';
      str = str.replaceAll(sub, value);
    });
    return str;
  }
}
