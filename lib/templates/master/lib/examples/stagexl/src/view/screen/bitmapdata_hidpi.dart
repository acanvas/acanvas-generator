part of stagexl_example;

class BitmapDataHiDPI extends AbstractScreen {
  FlipBook _flipbook;
  Bitmap _background;

  num _originalBgWidth;

  ResourceManager _resourceManager;

  BitmapDataHiDPI(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addBitmapData("background", "assets/stagexl/bitmapdata_hidpi/background@1x.jpg");
    _resourceManager.addTextureAtlas("atlas", "assets/stagexl/bitmapdata_hidpi/atlas@1x.json");
    await _resourceManager.load();
    onLoadComplete();
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    var bitmapData = _resourceManager.getBitmapData("background");
    _background = new Bitmap(bitmapData);
    addChild(_background);

    var textureAtlas = _resourceManager.getTextureAtlas("atlas");
    var bitmapDatas = textureAtlas.getBitmapDatas("frame");

    _flipbook = new FlipBook(bitmapDatas, 10);
    _flipbook.play();

    addChild(_flipbook);
    Rd.JUGGLER.add(_flipbook);

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    super.refresh();

    _originalBgWidth ??= _background.width;

    _background.scaleX = _background.scaleY = spanWidth / _originalBgWidth;
    _flipbook.scaleX = _flipbook.scaleY = _background.scaleX;

    _flipbook.x = spanWidth / 2 - _flipbook.width / 2;
    _flipbook.y = spanHeight / 2 - _flipbook.height / 2;
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_flipbook);
    _flipbook.stop();
    super.dispose();
    _flipbook = null;
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
