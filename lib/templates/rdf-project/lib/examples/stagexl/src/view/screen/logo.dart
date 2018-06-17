part of stagexl_example;

class Logo extends AbstractScreen {
  StreamSubscription<int> _subscription;
  ResourceManager _resourceManager;

  Logo(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addBitmapData("logo", "assets/stagexl/logo/logo.png");
    await _resourceManager.load();
    onLoadComplete();
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    num delay = 0.1;
    Random random = new Random();

    _subscription = Ac.JUGGLER.interval(delay).take(666).listen((int counter) {
      var rect = stage.contentRectangle;
      var hue = random.nextDouble() * 2.0 - 1.0;
      var hueFilter = new ColorMatrixFilter.adjust(hue: hue);
      var logoBitmapData = _resourceManager.getBitmapData("logo");

      var logoBitmap = new Bitmap(logoBitmapData)
        ..pivotX = logoBitmapData.width / 2
        ..pivotY = logoBitmapData.height / 2
        ..x = rect.left + rect.width * random.nextDouble()
        ..y = rect.top + rect.height * random.nextDouble()
        ..rotation = 0.4 * random.nextDouble() - 0.2
        ..filters = [hueFilter]
        ..scaleX = 0.0
        ..scaleY = 0.0
        ..addTo(this);

      Ac.JUGGLER.addTween(logoBitmap, 1.0, Transition.easeOutBack)
        ..animate.scaleX.to(1.0)
        ..animate.scaleY.to(1.0);

      Ac.JUGGLER.addTween(logoBitmap, 1.0, Transition.easeInBack)
        ..delay = 1.5
        ..animate.scaleX.to(0.0)
        ..animate.scaleY.to(0.0)
        ..onComplete = logoBitmap.removeFromParent;
    });

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    _subscription?.cancel();
    _subscription = null;
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
  void disappear(
      {double duration: MLifecycle.DISAPPEAR_DURATION_DEFAULT,
      bool autoDispose: false}) {
    super.disappear(duration: duration, autoDispose: autoDispose);
  }
}
