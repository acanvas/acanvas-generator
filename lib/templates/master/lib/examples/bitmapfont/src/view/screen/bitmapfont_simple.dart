part of bitmapfont_example;

class BitmapfontSimple extends AbstractScreen {
  BitmapText _bitmapText;
  BitmapFont _bitmapFont;
  ResourceManager _resourceManager;

  num _originalTextWidth;

  BitmapfontSimple(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    var fontUrl = "assets/bitmapfont/common/fonts/fnt/Luckiest_Guy.fnt";
    //var fontUrl = "assets/bitmapfont/common/fonts/fnt/Fascinate_Inline.fnt";
    //var fontUrl = "assets/bitmapfont/common/fonts/fnt/Orbitron.fnt";
    //var fontUrl = "assets/bitmapfont/common/fonts/fnt/Permanent_Marker.fnt";
    //var fontUrl = "assets/bitmapfont/common/fonts/fnt/Sarina.fnt";
    //var fontUrl = "assets/bitmapfont/common/fonts/fnt/Sigmar_One.fnt";

    _bitmapFont = await BitmapFont.load(fontUrl, BitmapFontFormat.FNT);
    onLoadComplete();
  }

  /// This is the place where you add anything to this method that needs initialization.
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

    _bitmapText.addTo(this);
    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    _bitmapText.x = 50;
    //_bitmapText.width = spanWidth - _bitmapText.x;
    _bitmapText.y = 50;
    //_bitmapText.height = spanHeight - _bitmapText.y;

    _originalTextWidth ??= _bitmapText.width;
    _bitmapText.scaleX = _bitmapText.scaleY = (spanWidth - 100) / _originalTextWidth;
    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
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
  void disappear({double duration: MLifecycle.DISAPPEAR_DURATION_DEFAULT, bool autoDispose: false}) {
    super.disappear(duration: duration, autoDispose: autoDispose);
  }
}
