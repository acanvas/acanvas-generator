part of spine_example;

class SpinePowerup extends AbstractScreen {
  ResourceManager _resourceManager;

  SkeletonAnimation _skeletonAnimation;

  SpinePowerup(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextFile("powerup", "assets/spine/powerup/powerup.json");
    _resourceManager.addTextureAtlas("powerup", "assets/spine/powerup/powerup.atlas", TextureAtlasFormat.LIBGDX);
    await _resourceManager.load();
    return true;
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // load Spine skeleton

    var spineJson = _resourceManager.getTextFile("powerup");
    var textureAtlas = _resourceManager.getTextureAtlas("powerup");
    var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
    var skeletonLoader = new SkeletonLoader(attachmentLoader);
    var skeletonData = skeletonLoader.readSkeletonData(spineJson);
    var animationStateData = new AnimationStateData(skeletonData);

    // create the display object showing the skeleton animation

    _skeletonAnimation = new SkeletonAnimation(skeletonData, animationStateData);
    _skeletonAnimation.state.setAnimationByName(0, "animation", true);
    addChild(_skeletonAnimation);
    Rd.JUGGLER.add(_skeletonAnimation);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _skeletonAnimation.x = 250;
    _skeletonAnimation.y = 280;
    _skeletonAnimation.scaleX = _skeletonAnimation.scaleY = 0.7;
  }

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_skeletonAnimation);

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
