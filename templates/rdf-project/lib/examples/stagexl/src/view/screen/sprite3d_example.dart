part of stagexl_example;

class Sprite3DExample extends AbstractScreen {
  num _originalBgWidth;

  TextureAtlas _textureAtlas;

  Sprite3D _cube;

  StreamSubscription<num> _subscription;

  Sprite3DExample(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _textureAtlas =
        await TextureAtlas.load('assets/stagexl/sprite3d/Flowers.json');
    onLoadComplete();
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    var flower1 = _textureAtlas.getBitmapData("Flower1");
    var flower2 = _textureAtlas.getBitmapData("Flower2");
    var flower3 = _textureAtlas.getBitmapData("Flower3");

    // Create cube faces and set the position and orientation in 3D space.

    List<CubeFace> cubeFaces = [
      new CubeFace(0xFFFF8080, flower1)
        ..offsetX = -75
        ..rotationY = pi / 2,
      new CubeFace(0xFF80FF80, flower1)
        ..offsetX = 75
        ..rotationY = -pi / 2,
      new CubeFace(0xFF8080FF, flower2)
        ..offsetY = -75
        ..rotationX = -pi / 2,
      new CubeFace(0xFFFFFF80, flower2)
        ..offsetY = 75
        ..rotationX = pi / 2,
      new CubeFace(0xFF80FFFF, flower3)
        ..offsetZ = -75
        ..rotationY = 0,
      new CubeFace(0xFFFF80FF, flower3)
        ..offsetZ = 75
        ..rotationY = pi
    ];

    // Create a cube and rotate it in the 3D space.

    _cube = new Sprite3D();
    _cube.children.addAll(cubeFaces);
    _cube.perspectiveProjection = new PerspectiveProjection.fromDepth(1000, 2);
    _cube.addTo(this);

    _subscription = Rd.JUGGLER.timespan(3600.0).listen((time) {
      Rd.MATERIALIZE_REQUIRED = true;
      _cube.x = spanWidth / 2 + sin(time) * 80;
      _cube.y = spanHeight / 2 + cos(time) * 80;
      _cube.rotationX = time * 0.5;
      _cube.rotationY = time * 0.7;
      _cube.rotationZ = time * 0.9;
      _cube.scaleX = _cube.scaleY = 2 + (sin(time) * 1.5);
    });

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    super.refresh();

    _cube.x = spanWidth / 2;
    _cube.y = spanHeight / 2;
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
