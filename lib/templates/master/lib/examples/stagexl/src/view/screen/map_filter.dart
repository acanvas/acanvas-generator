part of stagexl_example;

class MapFilter extends AbstractScreen {
  num _originalBgWidth;
  ResourceManager _resourceManager;
  Bitmap _guy;

  TextField _textField;

  NormalMapFilter _normalMapFilter;

  MapFilter(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _resourceManager = new ResourceManager();

    _resourceManager.addBitmapData("guy_pixels", "assets/stagexl/normal_map_filter/character-with-si-logo.png");
    _resourceManager.addBitmapData("guy_normal", "assets/stagexl/normal_map_filter/character-with-si-logo_n.png");
    await _resourceManager.load();
    onLoadComplete();
    return true;
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _textField = new TextField();
    _textField.defaultTextFormat = new TextFormat("Arial", 22, Color.White);
    _textField.defaultTextFormat.align = TextFormatAlign.CENTER;
    _textField.text = "Normal Map created with www.codeandweb.com/spriteilluminator";
    _textField.addTo(this);

    // create the NormalMapFilter with the image from the resource manager.

    var guyNormalBitmapData = _resourceManager.getBitmapData("guy_normal");
    _normalMapFilter = new NormalMapFilter(guyNormalBitmapData);
    _normalMapFilter.ambientColor = 0xFFA0A060;
    _normalMapFilter.lightColor = 0xFFFFFFFF;
    _normalMapFilter.lightRadius = 3000;
    _normalMapFilter.lightX = 0;
    _normalMapFilter.lightY = 0;
    _normalMapFilter.lightZ = 100;

    // create the Bitmap with the image from the resource manager
    // and add the NormalMapFilter to the filters.

    var guyPixelsBitmapData = _resourceManager.getBitmapData("guy_pixels");
    _guy = new Bitmap(guyPixelsBitmapData);
    _guy.filters.add(_normalMapFilter);

    _guy.pivotX = guyPixelsBitmapData.width / 2;
    _guy.pivotY = guyPixelsBitmapData.height / 2;
    _guy.addTo(this);

    // change the light position of the NormalMapFilter when moving
    // the mouse or the touch point.
    stage.onMouseDown.listen(_setLightPosition);
    stage.onMouseMove.listen(_setLightPosition);
    stage.onTouchBegin.listen(_setLightPosition);
    stage.onTouchMove.listen(_setLightPosition);

    Rd.MATERIALIZE_REQUIRED = true;

    onInitComplete();
  }

  void _setLightPosition(InputEvent e) {
    Rd.MATERIALIZE_REQUIRED = true;
    var stagePosition = new Point<num>(e.stageX, e.stageY);
    var guyPosition = _guy.globalToLocal(stagePosition);
    _normalMapFilter.lightX = guyPosition.x;
    _normalMapFilter.lightY = guyPosition.y;
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    _originalBgWidth ??= _guy.width;
    _guy.x = spanWidth / 2;
    _guy.y = spanHeight / 2;
    _guy.scaleX = _guy.scaleY = (spanWidth / _originalBgWidth) * 0.75;

    _textField.width = spanWidth - 40;
    _textField.x = 20;
    _textField.y = _guy.y + _guy.height + Dimensions.SPACER;

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
