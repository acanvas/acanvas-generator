part of acanvas_template;

class Dimensions {
  static const int WIDTH_SIDEBAR = 224; //MdDimensions.WIDTH_MENU;
  static const int WIDTH_TO_SHOW_SIDEBAR = 1000;

  static const int HEIGHT_RASTER = 100;
  static const int SPACER = 10;

  static int get X_PAGES => 0; //Ac.MOBILE ? 10 : 50;
  static const int Y_PAGES = MdDimensions.HEIGHT_APP_BAR; // + 4 * SPACER;

  static const int WIDTH_MIN = 400;
  static const int HEIGHT_MIN = 480;

  static const int WIDTH_MAX = 1280;
  static const int HEIGHT_MAX = 1180;

  static int get WIDTH_CONTENT =>
      min(WIDTH_STAGE - X_PAGES, WIDTH_MAX - X_PAGES);
  static int get HEIGHT_CONTENT => HEIGHT_STAGE - Y_PAGES;

  static int get WIDTH_STAGE_REAL => AcConstants.getStage().stageWidth;
  static int get HEIGHT_STAGE_REAL => AcConstants.getStage().stageHeight;

  static int get WIDTH_STAGE =>
      min(WIDTH_MAX, max(WIDTH_MIN, AcConstants.getStage().stageWidth));
  static int get HEIGHT_STAGE =>
      min(HEIGHT_MAX, max(HEIGHT_MIN, AcConstants.getStage().stageHeight));
}
