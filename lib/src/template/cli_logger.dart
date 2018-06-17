part of acanvas_generator;

class CliLoggerPrint implements CliLogger{
  void stdout(String message) => print(message);
  void stderr(String message) => print(message);
}

abstract class CliLogger {
  void stdout(String message);
  void stderr(String message);
}
