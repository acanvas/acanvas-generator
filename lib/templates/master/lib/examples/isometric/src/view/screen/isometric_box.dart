part of isometric_example;

class IsometricGoblins extends AbstractReflowScreen {
  ResourceManager _resourceManager;

  num _originalTextWidth;

  IsoApplication _iso;

  IsometricGoblins(String id) : super(id) {}

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map params: null}) {
    super.init(params: params);

    addChild(reflow);

    _iso = new IsoApplication();
    addChild(_iso);

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    super.refresh();

    _iso.x = spanWidth/2;
    _iso.y = spanHeight/2;
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    super.dispose();
  }

  /// Set spanWidth and spanHeight according to calculations in Dimensions class.

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(spanWidth, spanHeight, refresh: refresh);
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
