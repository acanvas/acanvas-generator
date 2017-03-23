part of stagexl_example;

class DragExample extends AbstractScreen {
  FlipBook _flipbook;
  Bitmap _background;

  num _originalBgWidth;
  ResourceManager _resourceManager;
  Sprite _holder;

  DragExample(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();

    _resourceManager.addBitmapData("flower1", "assets/stagexl/drag/flower1.png");
    _resourceManager.addBitmapData("flower2", "assets/stagexl/drag/flower2.png");
    _resourceManager.addBitmapData("flower3", "assets/stagexl/drag/flower3.png");
    await _resourceManager.load();
    onLoadComplete();
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // Create 100 random flowers around the center of the Stage

    var random = new Random();
    _holder = new Sprite();

    for (var i = 0; i < 100; i++) {
      var f = 1 + random.nextInt(3);
      var bitmapData = _resourceManager.getBitmapData("flower$f");

      var bitmap = new Bitmap(bitmapData);
      bitmap.pivotX = 64;
      bitmap.pivotY = 64;

      var sprite = new Sprite();
      var randomRadius = random.nextDouble() * 200;
      var randomAngle = random.nextDouble() * 2 * PI;
      sprite.addChild(bitmap);
      sprite.x = spanWidth / 2 + randomRadius * cos(randomAngle);
      sprite.y = spanHeight / 2 + randomRadius * sin(randomAngle);
      sprite.addTo(_holder);

      // add event handlers to start or stop dragging

      void startDrag(Event e) {
        addChild(sprite); // bring to foreground
        sprite.scaleX = sprite.scaleY = 1.2;
        sprite.filters.add(new ColorMatrixFilter.adjust(hue: -0.5));
        sprite.startDrag(true);
      }

      void stopDrag(Event e) {
        sprite.scaleX = sprite.scaleY = 1.0;
        sprite.filters.clear();
        sprite.stopDrag();
      }

      sprite.onMouseDown.listen(startDrag);
      sprite.onTouchBegin.listen(startDrag);
      sprite.onMouseUp.listen(stopDrag);
      sprite.onTouchEnd.listen(stopDrag);
      stage.onMouseLeave.listen(stopDrag);
    }

    addChild(_holder);

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    super.refresh();
    _holder.x = spanWidth / 2 - _holder.width / 2;
    _holder.y = spanHeight / 2 - _holder.height / 2;
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    super.dispose();
    _holder = null;
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
