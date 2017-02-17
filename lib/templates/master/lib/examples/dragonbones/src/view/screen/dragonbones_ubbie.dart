part of dragonbones_example;

class DragonBonesUbbie extends AbstractScreen {
  ResourceManager _resourceManager;

  num _originalWidth;

  Skeleton _skeleton;

  DragonBonesUbbie(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextureAtlas(
        "dragonTexture", "assets/dragonbones/ubbie/texture.json", TextureAtlasFormat.STARLINGJSON);
    _resourceManager.addTextFile("dragonJson", "assets/dragonbones/ubbie/ubbie.json");
    await _resourceManager.load();
    return true;
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // create a skeleton and play the "walk" animation

    var textureAtlas = _resourceManager.getTextureAtlas("dragonTexture");
    var dragonBonesJson = _resourceManager.getTextFile("dragonJson");
    var dragonBones = DragonBones.fromJson(dragonBonesJson);
    _skeleton = dragonBones.createSkeleton("ubbie");

    _skeleton.setSkin(textureAtlas);
    _skeleton.play("stand");
    _skeleton.showBones = false;
    Rd.JUGGLER.add(_skeleton);
    addChild(_skeleton);

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    _originalWidth ??= 860;
    _skeleton.scaleX = _skeleton.scaleY = spanWidth / _originalWidth / 1.5;
    _skeleton.x = spanWidth / 2 - _skeleton.width / 2 - 130 * _skeleton.scaleX;
    _skeleton.y = spanHeight - 100 * _skeleton.scaleX;

    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_skeleton);
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
