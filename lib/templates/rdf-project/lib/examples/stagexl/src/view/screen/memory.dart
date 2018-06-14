part of stagexl_example;

class MemoryExample extends AbstractScreen implements Animatable {
  num _originalBgWidth;
  ResourceManager _resourceManager;

  PlayingField _playingField;

  MemoryExample(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();

    _resourceManager.addTextureAtlas(
        "atlas", "assets/stagexl/memory/atlas.json");
    await _resourceManager.load();
    onLoadComplete();
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _playingField = new PlayingField(_resourceManager);
    _playingField.rotationX = -0.6;
    _playingField.addTo(this);

    this.on(Event.COMPLETE).listen(_gameCompleted);

    _startGame();

    Rd.JUGGLER.add(this);

    onInitComplete();
  }

  void _startGame() {
    _playingField.dealCards(4, 3).then((_) {
      stage.onMouseDown.first.then((e) => _playingField.concealAllCards());
      stage.onTouchBegin.first.then((e) => _playingField.concealAllCards());
    });
  }

  void _gameCompleted(Event event) {
    _playingField.removeCards().then((_) => _startGame());
  }

  bool advanceTime(num time) {
    _playingField.advanceTime(time);
    return true;
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    _originalBgWidth ??= _playingField.width;

    _playingField.scaleX = _playingField.scaleY = spanWidth / _originalBgWidth;
    _playingField.x = spanWidth / 2;
    _playingField.y = _playingField.height / 2;

    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(this);
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
