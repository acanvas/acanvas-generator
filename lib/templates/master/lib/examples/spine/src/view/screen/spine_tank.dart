part of spine_example;

class SpineTank extends AbstractScreen {
  ResourceManager _resourceManager;

  SkeletonAnimation _skeletonAnimation;
  num _originalSkeletonWidth;

  SpineTank(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextFile("tank", "assets/spine/tank/tank.json");
    _resourceManager.addTextureAtlas("tank", "assets/spine/tank/tank.atlas", TextureAtlasFormat.LIBGDX);
    await _resourceManager.load();
    return true;
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    var spineJson = _resourceManager.getTextFile("tank");
    var textureAtlas = _resourceManager.getTextureAtlas("tank");
    var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
    var skeletonLoader = new SkeletonLoader(attachmentLoader);
    var skeletonData = skeletonLoader.readSkeletonData(spineJson);
    var animationStateData = new AnimationStateData(skeletonData);

    // create the display object showing the skeleton animation

    _skeletonAnimation = new SkeletonAnimation(skeletonData, animationStateData);
    _skeletonAnimation.state.setAnimationByName(0, "drive", true);

    addChild(_skeletonAnimation);
    Rd.JUGGLER.add(_skeletonAnimation);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _originalSkeletonWidth ??= 1000;
    _skeletonAnimation.scaleX = _skeletonAnimation.scaleY = spanWidth / _originalSkeletonWidth / 1.5;
    _skeletonAnimation.x = spanWidth;
    _skeletonAnimation.y = spanHeight - _skeletonAnimation.height;
  }

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_skeletonAnimation);

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
