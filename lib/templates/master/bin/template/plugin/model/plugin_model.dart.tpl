part of @package@;

/**
 * @author Nils Doehring (nilsdoehring@gmail.com)
 */

class @plugin@Model {

  final Logger _log = new Logger("@plugin@Model");

  String _sample;
  void set sample(String s){
    _sample = s;
  }
  String get sample {
    return _sample;
  }
}
