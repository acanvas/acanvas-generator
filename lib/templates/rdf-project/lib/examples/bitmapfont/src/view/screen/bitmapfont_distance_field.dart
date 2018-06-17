part of bitmapfont_example;

class BitmapfontDistanceField extends AbstractScreen {
  BitmapText _bitmapText;
  BitmapFont _bitmapFont;
  ResourceManager _resourceManager;

  num _originalTextWidth;

  StreamSubscription<num> _listener;

  BitmapfontDistanceField(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    var fontUrl = "assets/bitmapfont/distance_field/font.fnt";

    _bitmapFont = await BitmapFont.load(fontUrl, BitmapFontFormat.FNT);
    onLoadComplete();
  }

  /// This is the place where you add anything to this class that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _bitmapText = new BitmapText(_bitmapFont);
    _bitmapText.text = """
Hello World!
Grumpy wizards make
toxic brew for the
evil Queen and Jack.""";

    _bitmapText.alignPivot();
    _bitmapText.addTo(this);

    // add the DistanceFieldFilter for sharp edges

    var config1 = new DistanceFieldConfig(0.70, 0.20, Color.White);
    var config2 = new DistanceFieldConfig(0.30, 0.20, Color.Black);

    var filter1 = new DistanceFieldFilter(config1);
    var filter2 = new DistanceFieldOutlineFilter(config1, config2);

    var filters = [filter1, filter2];
    var filterIndex = 0;

    _bitmapText.filters.clear();
    _bitmapText.filters.add(filters[0]);

    this.onMouseClick.listen((mouseEvent) {
      filterIndex = (filterIndex + 1) % filters.length;
      _bitmapText.filters.clear();
      _bitmapText.filters.add(filters[filterIndex]);
    });

    _listener = Ac.JUGGLER.onElapsedTimeChange.listen((num elapsedTime) {
      Ac.MATERIALIZE_REQUIRED = true;
      var scale = 2.0 + 1.5 * sin(elapsedTime * 0.5);
      _bitmapText.scaleX = _bitmapText.scaleY = scale;
    });

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    _bitmapText.x = spanWidth / 2;
    _bitmapText.y = spanHeight / 2;

    _bitmapText.alignPivot();

    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    if (_listener != null) _listener.cancel();
    _listener = null;
    super.dispose();
    _bitmapText = null;
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
  void disappear(
      {double duration: MLifecycle.DISAPPEAR_DURATION_DEFAULT,
      bool autoDispose: false}) {
    super.disappear(duration: duration, autoDispose: autoDispose);
  }
}
