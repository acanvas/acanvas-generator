part of isometric_example;

/// The AbstractScreen class contains settings applicable to all screens of an application.

class AbstractIsometricScreen extends RockdotLifecycleSprite implements IModelAware {
  /// AppModel as defined by interface. Will be injected by ApplicationContext/factory

  Model model;

  @override
  void set appModel(Model model) {
    model = model;
  }

  Wrap reflow;
  MdText _headline;
  MdText _copy;

  AbstractIsometricScreen(String id) : super(id) {
    padding = 52; // Rd.MOBILE ? 8 : 32;
    inheritSpan = true;
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    reflow = new Wrap(spacing: 16, scrollOrientation: ScrollOrientation.VERTICAL)
      ..x = padding
      ..y = padding
      ..inheritSpan = false
      ..autoRefresh = false;

    _headline = Theme.getHeadline(getProperty("headline"), size: 24);
    reflow.addChild(_headline);

    String copyText = getProperty("copy");
    _copy = Theme.getCopy(copyText, size: 16);
    reflow.addChild(_copy);

    reflow.addChild(new Sprite()
      ..graphics.rect(0, 0, spanWidth - 10, Dimensions.SPACER)
      ..graphics.fillColor(0x00ff0000));
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    reflow.span(spanWidth - padding, spanHeight - padding);
    _copy.width = spanWidth - 2 * padding - 32;
    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }

  /// Set spanWidth and spanHeight according to calculations in Dimensions class.

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    if (Dimensions.WIDTH_STAGE > Dimensions.WIDTH_TO_SHOW_SIDEBAR) {
      super.span(Dimensions.WIDTH_CONTENT - Dimensions.WIDTH_SIDEBAR, Dimensions.HEIGHT_CONTENT);
      x = Dimensions.X_PAGES + Dimensions.WIDTH_SIDEBAR;
    } else {
      super.span(Dimensions.WIDTH_CONTENT, Dimensions.HEIGHT_CONTENT);
      x = Dimensions.X_PAGES;
    }

    y = Dimensions.Y_PAGES;
  }

  /// Use this in case all your fade in / fade out stuff is the same for all screens

  @override
  void appear({double duration: MLifecycle.APPEAR_DURATION_DEFAULT}) {
    super.appear(duration: duration);
  }

  @override
  void disappear({double duration: MLifecycle.DISAPPEAR_DURATION_DEFAULT, bool autoDispose: false}) {
    super.disappear(duration: duration, autoDispose: autoDispose);
  }
}
