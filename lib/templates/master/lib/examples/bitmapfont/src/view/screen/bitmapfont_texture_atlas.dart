part of bitmapfont_example;

class BitmapfontTextureAtlas extends AbstractScreen {
  String _text = """
Lorem ipsum dolor sit amet, consetetur
sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna
aliquyam erat, sed diam voluptua. At vero
eos et accusam et justo duo dolores et ea
rebum. Stet clita kasd gubergren, no sea
takimata sanctus est Lorem ipsum dolor sit
amet. Lorem ipsum dolor sit amet, consetetur
sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna
aliquyam erat, sed diam voluptua.""";

  ResourceManager _resourceManager;

  num _originalTextWidth;

  BitmapfontTextureAtlas(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextureAtlas("atlas", "assets/bitmapfont/common/images/font_atlas.json");
    _resourceManager.addTextFile("fnt1", "assets/bitmapfont/common/fonts/fnt/Luckiest_Guy.fnt");
    _resourceManager.addTextFile("fnt2", "assets/bitmapfont/common/fonts/fnt/Fascinate_Inline.fnt");
    _resourceManager.addTextFile("fnt3", "assets/bitmapfont/common/fonts/fnt/Sarina.fnt");
    _resourceManager.addTextFile("fnt4", "assets/bitmapfont/common/fonts/fnt/Sigmar_One.fnt");
    await _resourceManager.load();
    onLoadComplete();
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    TextureAtlas atlas = _resourceManager.getTextureAtlas("atlas");
    String source1 = _resourceManager.getTextFile("fnt1");
    String source2 = _resourceManager.getTextFile("fnt2");
    String source3 = _resourceManager.getTextFile("fnt3");
    String source4 = _resourceManager.getTextFile("fnt4");

    Future.wait([
      BitmapFont.fromTextureAtlas(atlas, "", source1, BitmapFontFormat.FNT),
      BitmapFont.fromTextureAtlas(atlas, "", source2, BitmapFontFormat.FNT),
      BitmapFont.fromTextureAtlas(atlas, "", source3, BitmapFontFormat.FNT),
      BitmapFont.fromTextureAtlas(atlas, "", source4, BitmapFontFormat.FNT)
    ]).then((var fonts) {
      // Create a BitmapText for each line and use a different font

      var lines = _text.split(new RegExp(r"\r\n|\r|\n"));

      for (int i = 0; i < lines.length; i++) {
        var font = fonts[i % fonts.length];
        var bitmapText = new BitmapContainerText(font);
        bitmapText.x = 50;
        bitmapText.y = 50 + i * 64;
        bitmapText.text = lines[i];
        bitmapText.addTo(this);
        _animateBitmapText(bitmapText);
      }

      onInitComplete();
    });
  }

  void _animateBitmapText(BitmapContainerText bitmapText) {
    for (var bitmap in bitmapText.children) {
      bitmap.pivotX = bitmap.width / 2;
      bitmap.pivotY = bitmap.height / 2;
      bitmap.x += bitmap.pivotX;
      bitmap.y += bitmap.pivotY;
    }

    Rd.JUGGLER.onElapsedTimeChange.listen((num elapsedTime) {
      Rd.MATERIALIZE_REQUIRED = true;
      for (var bitmap in bitmapText.children) {
        bitmap.rotation = 0.2 * sin(elapsedTime * 8 + bitmap.x);
      }
    });
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    for (var bitmap in this.children) {
      _originalTextWidth ??= bitmap.width + 350;
      bitmap.scaleX = bitmap.scaleY = (spanWidth) / _originalTextWidth;
    }
    super.refresh();
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
