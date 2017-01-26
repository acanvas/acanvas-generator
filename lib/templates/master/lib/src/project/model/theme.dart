part of rockdot_template;

class Theme {

  static const int COLOR_BASE = Colors.BF_BASE_GREEN;
  static const int COLOR_TRIAD_GREEN = Colors.BF_TRIAD_GREEN;
  static const int COLOR_TRIAD_BLUE = Colors.BF_TRIAD_BLUE;
  static const int COLOR_TRIAD_BROWN = Colors.BF_TRIAD_BROWN;
  static const int COLOR_TRIAD_ORANGE = Colors.BF_TRIAD_ORANGE;


  static const int HEADLINE_COLOR = Colors.ARCTIC_BLUE;
  static const int HEADLINE_SIZE = 24;
  static const String HEADLINE_FONT = Fonts.ROBOTO_FONTNAME;

  static const int COPY_COLOR = Colors.ARCTIC_BLUE;
  static const int COPY_SIZE = 12;
  static const String COPY_FONT = Fonts.ROBOTO_FONTNAME;

  static const int MD_BUTTON_COLOR = COLOR_BASE;
  static const int MD_BUTTON_WIDTH = 240;
  static const int MD_BUTTON_RIPPLE_COLOR = Colors.WHITE;
  static const int MD_BUTTON_FONT_COLOR = Colors.WHITE;
  static const int MD_BUTTON_ICON_COLOR = Colors.WHITE;

  static const int MD_WRAP_COLOR = 0xFF000000;
  static const int MD_WRAP_FONT_COLOR = 0xFF000000;

  static const int BACKGROUND_COLOR = Colors.GREY_MIDDLE;

  //----------------------------

  static MdText getHeadline(String text, {int size: HEADLINE_SIZE, int color: HEADLINE_COLOR, String fontName: Fonts.ROBOTO_FONTNAME, int weight: Fonts.ROBOTO_WEIGHT_BOLD}){
    return new MdText(text, fontName: fontName, size: size, color: color, weight: weight);
  }
  static MdText getCopy(String text, {int size: COPY_SIZE, int color: COPY_COLOR, String fontName: Fonts.ROBOTO_FONTNAME, int weight: Fonts.ROBOTO_WEIGHT_NORMAL}){
    return new MdText(text, fontName: fontName, size: size, color: color, weight: weight);
  }

  static MdButton getButton({String label: "", int bgColor: Theme.MD_BUTTON_COLOR, int fontColor: Theme.MD_BUTTON_FONT_COLOR, int width: MD_BUTTON_WIDTH, bool shadow: true}){
    return new MdButton(label, bgColor: bgColor, fontName: Theme.HEADLINE_FONT, fontColor: fontColor, width: width, shadow: shadow);
  }

  static MdWrap getWrap({String label: "", int panelColor: MD_BUTTON_COLOR, AlignH align: AlignH.LEFT}){
    return new MdWrap(Theme.getHeadline(label.toUpperCase(), size: 18, color: Colors.WHITE), align: align, panelColor: panelColor);
  }
}