part of acanvas_template;

class Theme {
  static const int HIGHLIGHT_MAIN = Colors.AC_BLUE;
  static const int HIGHLIGHT_MAIN_COMP = Colors.AC_BLUE_BOOM;

  static const int BG = Colors.GREY_MIDDLE;

  static const int TOP_BAR_BG = Colors.GREY_MIDDLE;

  static const String HEADLINE_FONT = Fonts.ROBOTO_FONTNAME;
  static const int HEADLINE_SIZE = 24;
  static const int HEADLINE_COLOR = Colors.WHITE;

  static const String COPY_FONT = Fonts.ROBOTO_FONTNAME;
  static const int COPY_SIZE = 16;
  static const int COPY_COLOR = Colors.WHITE;

  static const int MD_BUTTON_COLOR = HIGHLIGHT_MAIN;
  static const int MD_BUTTON_WIDTH = 240;
  static const int MD_BUTTON_RIPPLE_COLOR = Colors.WHITE;
  static const int MD_BUTTON_FONT_COLOR = Colors.WHITE;
  static const int MD_BUTTON_ICON_COLOR = Colors.WHITE;

  static const int MD_WRAP_COLOR = 0xFF000000;
  static const int MD_WRAP_FONT_COLOR = 0xFF000000;

  static const int EXAMPLES_HIGHLIGHT_MAIN = Colors.AC_BLUE;
  static const int EXAMPLES_HIGHLIGHT_MAIN_ALT = Colors.AC_BLUE_BOOM;
  static const int EXAMPLES_BG = Colors.GREY_MIDDLE;
  static const int EXAMPLES_HEADLINE_COLOR = Colors.WHITE;
  static const int EXAMPLES_MD_BUTTON_COLOR = HIGHLIGHT_MAIN;
  static const int EXAMPLES_MD_BUTTON_FONT_COLOR = Colors.WHITE;
  static const int EXAMPLES_MD_BUTTON_ICON_COLOR = Colors.WHITE;

  static MdText getHeadline(String text,
      {int size: HEADLINE_SIZE,
      int color: HEADLINE_COLOR,
      String fontName: Fonts.ROBOTO_FONTNAME,
      int weight: Fonts.ROBOTO_WEIGHT_BOLD}) {
    return new MdText(text,
        fontName: fontName, size: size, color: color, weight: weight);
  }

  static MdText getCopy(String text,
      {int size: COPY_SIZE,
      int color: COPY_COLOR,
      String fontName: Fonts.ROBOTO_FONTNAME,
      int weight: Fonts.ROBOTO_WEIGHT_NORMAL}) {
    return new MdText(text,
        fontName: fontName, size: size, color: color, weight: weight);
  }

  static MdButton getButton(
      {String label: "",
      int bgColor: Theme.MD_BUTTON_COLOR,
      int fontColor: Theme.MD_BUTTON_FONT_COLOR,
      int width: MD_BUTTON_WIDTH,
      bool shadow: true}) {
    return new MdButton(label,
        bgColor: bgColor,
        fontName: Theme.HEADLINE_FONT,
        fontColor: fontColor,
        width: width,
        shadow: shadow);
  }

  static MdInput getInput(
      {String label: "",
      String name: "",
      String required: "",
      int textColor: Colors.GREY_MIDDLE,
      bool password: false}) {
    MdInput input = new MdInput(label,
        fontName: Theme.COPY_FONT, textColor: textColor, password: password);
    if (name != "") {
      input.name = name;
    }
    ;
    return input;
  }

  static MdWrap getWrap(
      {String label: "",
      int panelColor: MD_BUTTON_COLOR,
      AlignH align: AlignH.LEFT}) {
    return new MdWrap(
        Theme.getHeadline(label.toUpperCase(), size: 18, color: Colors.WHITE),
        align: align,
        panelColor: panelColor);
  }
}
