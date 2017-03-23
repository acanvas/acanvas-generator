part of dragonbones_example;

class DragonBonesDemon extends AbstractScreen {
  ResourceManager _resourceManager;
  num _originalWidth;

  Skeleton _skeleton;

  DragonBonesDemon(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextureAtlas(
        "demonTexture", "assets/dragonbones/demon/texture.json", TextureAtlasFormat.STARLINGJSON);
    _resourceManager.addTextFile("demonJson", "assets/dragonbones/demon/demon.json");
    await _resourceManager.load();
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // create a skeleton and play the "run" animation

    var textureAtlas = _resourceManager.getTextureAtlas("demonTexture");
    var dragonBonesJson = _resourceManager.getTextFile("demonJson");
    var dragonBones = DragonBones.fromJson(dragonBonesJson);
    _skeleton = dragonBones.createSkeleton("armatureName");

    _skeleton.setSkin(textureAtlas);
    //skeleton.play("run");
    _skeleton.play("uniqueAttack");
    //skeleton.showBones = true;
    Rd.JUGGLER.add(_skeleton);
    addChild(_skeleton);

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    _originalWidth ??= 1000;
    _skeleton.scaleX = _skeleton.scaleY = spanWidth / _originalWidth / 1.5;
    _skeleton.x = spanWidth / 2 - _skeleton.width / 2;
    _skeleton.y = spanHeight - 50;

    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_skeleton);
    _skeleton.removeCache();
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
