/*************************************************************************/
/*      Helper classes extracted from rockdot_spring                     */
/*************************************************************************/

/**
 * The <code>Properties</code> class represents a collection of properties
 * in the form of key-value pairs. All keys and values are of type
 * <code>String</code>
 *
 * @author Christophe Herreman
 * @author Roland Zwaga
 */
class Properties {
  /**
   * Creates a new <code>Properties</code> object.
   */
  Properties() {
    _content = {};
    _propertyNames = new List<String>();
  }

  Map _content;
  List<String> _propertyNames;

  /**
   * The content of the Properties instance as an object.
   * @return an object containing the content of the properties
   */
  Map get content {
    return _content;
  }

  int get length {
    return _propertyNames.length;
  }

  /**
   * Returns an array with the keys of all properties. If no properties
   * were found, an empty array is returned.
   *
   * @return an array with all keys
   */
  List<String> get propertyNames {
    return _propertyNames;
  }

  /**
   * Gets the value of property that corresponds to the given <code>key</code>.
   * If no property was found, <code>null</code> is returned.
   *
   * @param key the name of the property to get
   * @returns the value of the property with the given key, or null if none was found
   */
  dynamic getProperty(String key) {
    return _content[key];
  }

  bool hasProperty(String key) {
    return _content.containsKey(key);
  }

  /**
   * Adds all conIPropertiese given properties object to this Properties.
   */
  void merge(Properties properties, [bool overrideProperty = false]) {
    if ((properties == null) || (properties == this)) {
      return;
    }
    for (String key in properties.content.keys) {
      if (_content[key] == null || (_content[key] != null && overrideProperty)) {
        setProperty(key, properties.content[key]);
        /*addPropertyName(key);
					_content[key] = properties.content[key];*/
      }
    }
  }

  /**
   * Sets a property. If the property with the given key already exists,
   * it will be replaced by the new value.
   *
   * @param key the key of the property to set
   * @param value the value of the property to set
   */
  void setProperty(String key, String value) {
    addPropertyName(key);
    _content[key] = value;
    //logger.finer("Added property: $key = $value");
  }

  void addPropertyName(String key) {
    if (_propertyNames.indexOf(key) < 0) {
      _propertyNames.add(key);
    }
  }
}

/**
 * <p><code>KeyValuePropertiesParser</code> parses a properties source string into a <code>IPropertiesProvider</code>
 * instance.</p>
 *
 * <p>The source string contains simple key-value pairs. Multiple pairs are
 * separated by line terminators (\n or \r or \r\n). Keys are separated from
 * values with the characters '=', ':' or a white space character.</p>
 *
 * <p>Comments are also supported. Just add a '#' or '!' character at the
 * beginning of your comment-line.</p>
 *
 * <p>If you want to use any of the special characters in your key or value you
 * must escape it with a back-slash character '\'.</p>
 *
 * <p>The key contains all of the characters in a line starting from the first
 * non-white space character up to, but not including, the first unescaped
 * key-value-separator.</p>
 *
 * <p>The value contains all of the characters in a line starting from the first
 * non-white space character after the key-value-separator up to the end of the
 * line. You may of course also escape the line terminator and create a value
 * across multiple lines.</p>
 *
 * @see org.springextensions.actionscript.collections.Properties Properties
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @author Christophe Herreman
 * @version 1.0
 */
class KeyValuePropertiesParser {
  static const int HASH_CHARCODE = 35;

  //= "#";
  static const int EXCLAMATION_MARK_CHARCODE = 33;

  //= "!";
  static const String DOUBLE_BACKWARD_SLASH = '\\';
  static const String NEWLINE_CHAR = "\n";
  static final RegExp NEWLINE_REGEX = new RegExp(r'\\n');

  // /\\n/gm;

  /**
   * Constructs a new <code>PropertiesParser</code> instance.
   */
  KeyValuePropertiesParser() : super() {}

  /**
   * Parses the given <code>source</code> and creates a <code>Properties</code> instance from it.
   *
   * @param source the source to parse
   * @return the properties defined by the given <code>source</code>
   */
  void parseProperties(dynamic source, Properties provider) {
    MultilineString lines = new MultilineString((source.toString()));
    num numLines = lines.numLines;
    String key = "";
    String value = "";
    String formerKey = "";
    String formerValue = "";
    bool useNextLine = false;

    for (int i = 0; i < numLines; i++) {
      String line = lines.getLine(i);
      //logger.finer("Parsing line: {0}", [line]);
      // Trim the line
      line = trim(line);

      // Ignore Comments and empty lines
      if (isPropertyLine(line)) {
        // Line break processing
        if (useNextLine) {
          key = formerKey;
          value = formerValue + line;
          useNextLine = false;
        } else {
          int sep = line.indexOf("=");
          key = rightTrim(line.substring(0, sep));
          value = line.substring(sep + 1);
          formerKey = key;
          formerValue = value;
        }
        // Trim the content
        value = leftTrim(value);

        // Allow normal lines
        String end = value == "" ? "" : value.substring(value.length - 1);
        if (end == DOUBLE_BACKWARD_SLASH) {
          formerValue = value = value.substring(0, value.length - 1);
          useNextLine = true;
        } else {
          // restore newlines since these were escaped when loaded
          value = value.replaceAll(NEWLINE_REGEX, NEWLINE_CHAR);
          provider.setProperty(key, value);
        }
      } else {
        //logger.finer("Ignoring commented line.");
      }
    }
  }

  static String trim(String str) {
    if (str == null) {
      return null;
    }
    return str.replaceAll(new RegExp(r'^\s*'), '').replaceAll(new RegExp(r'\s*$'), '');
  }

  /**
   * Removes all empty characters at the beginning of a string.
   *
   * <p>Characters that are removed: spaces <code>" "</code>, line forwards <code>\n</code>
   * and extended line forwarding <code>\t\n</code>.</p>
   *
   * @param string the string to trim
   * @return the trimmed string
   */
  static String leftTrim(String string) {
    return leftTrimForChars(string, "\n\t\n ");
  }

  /**
   * Removes all empty characters at the end of a string.
   *
   * <p>Characters that are removed: spaces <code>" "</code>, line forwards <code>\n</code>
   * and extended line forwarding <code>\t\n</code>.</p>
   *
   * @param string the string to trim
   * @return the trimmed string
   */
  static String rightTrim(String string) {
    return rightTrimForChars(string, "\n\t\n ");
  }

  /**
   * Removes all characters at the beginning of the <code>String</code> that match to the
   * set of <code>chars</code>.
   *
   * <p>This method splits all <code>chars</code> and removes occurencies at the beginning.</p>
   *
   * <p>Example: dynamic <code>
   *   print(StringUtil.rightTrimForChars("ymoynkeym", "ym")); // oynkeym
   *   print(StringUtil.rightTrimForChars("monkey", "mo")); // nkey
   *   print(StringUtil.rightTrimForChars("monkey", "om")); // nkey
   * </code></p>
   *
   * @param string the string to trim
   * @param chars the characters to remove from the beginning of the <code>String</code>
   * @return the trimmed string
   */
  static String leftTrimForChars(String string, String chars) {
    num from = 0;
    num to = string.length;

    while (from < to && chars.indexOf(string[from]) >= 0) {
      from++;
    }
    return (from > 0 ? string.substring(from, to) : string);
  }

  /**
   * Removes all characters at the end of the <code>String</code> that match to the set of
   * <code>chars</code>.
   *
   * <p>This method splits all <code>chars</code> and removes occurencies at the end.</p>
   *
   * <p>Example: dynamic <code>
   *   print(StringUtil.rightTrimForChars("ymoynkeym", "ym")); // ymoynke
   *   print(StringUtil.rightTrimForChars("monkey***", "*y")); // monke
   *   print(StringUtil.rightTrimForChars("monke*y**", "*y")); // monke
   * </code></p>
   *
   * @param string the string to trim
   * @param chars the characters to remove from the end of the <code>String</code>
   * @return the trimmed string
   */
  static String rightTrimForChars(String string, String chars) {
    num from = 0;
    num to = string.length - 1;

    while (from < to && chars.indexOf(string[to]) >= 0) {
      to--;
    }
    return (to >= 0 ? string.substring(from, to + 1) : string);
  }

  bool isPropertyLine(String line) {
    return (line != null &&
        line.length > 0 &&
        line.codeUnitAt(0) != HASH_CHARCODE &&
        line.codeUnitAt(0) != EXCLAMATION_MARK_CHARCODE &&
        line.length != 0);
  }
}

/**
 * <code>MultilineString</code> allows to access all lines of a string separately.
 *
 * <p>To not have to deal with different forms of line breaks (Windows/Apple/Unix)
 * <code>MultilineString</code> automatically standardizes them to the <code>\n</code> character.
 * So the passed-in <code>String</code> will always get standardized.</p>
 *
 * <p>If you need to access the original <code>String</code> you can use
 * <code>getOriginalString</code>.</p>
 *
 * @author Martin Heidegger, Christophe Herreman
 * @version 1.0
 */
class MultilineString {
  /** Character code for the WINDOWS line break. */
  static final String WIN_BREAK = new String.fromCharCodes([13]) + new String.fromCharCodes([10]);

  /** Character code for the APPLE line break. */
  static final String MAC_BREAK = new String.fromCharCodes([13]);

  /** Character used internally for line breaks. */
  static const String NEWLINE_CHAR = "\n";

  /** Original content without standardized line breaks. */
  String _original;

  /** Separation of all lines for the string. */
  List _lines;

  /**
   * Constructs a new MultilineString.
   */
  MultilineString(String string) : super() {
    initMultiString(string);
  }

  void initMultiString(String string) {
    _original = string;
    _lines = string.split(WIN_BREAK).join(NEWLINE_CHAR).split(MAC_BREAK).join(NEWLINE_CHAR).split(NEWLINE_CHAR);
  }

  /**
   * Returns the original used string (without line break standarisation).
   *
   * @return the original used string
   */
  String get originalString {
    return _original;
  }

  /**
   * Returns a specific line within the <code>MultilineString</code>.
   *
   * <p>It will return <code>undefined</code> if the line does not exist.</p>
   *
   * <p>The line does not contain the line break.</p>
   *
   * <p>The counting of lines startes with <code>0</code>.</p>
   *
   * @param line number of the line to get the content of
   * @return content of the line
   */
  String getLine(int line) {
    return _lines[line];
  }

  /**
   * Returns the content as array that contains each line.
   *
   * @return content split into lines
   */
  List get lines {
    return new List.from(_lines);
  }

  /**
   * Returns the amount of lines in the content.
   *
   * @return amount of lines within the content
   */
  int get numLines {
    return _lines.length;
  }
}
