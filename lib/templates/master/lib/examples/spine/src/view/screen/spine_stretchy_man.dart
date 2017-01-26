part of spine_example;

class SpineStretchyMan extends AbstractScreen {
  ResourceManager _resourceManager;

  SkeletonAnimation _skeletonAnimation;
  num _originalSkeletonWidth;

  SpineStretchyMan(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextFile("stretchyman", "assets/spine/stretchyman/stretchyman.json");
    _resourceManager.addTextureAtlas(
        "stretchyman", "assets/spine/stretchyman/stretchyman.atlas", TextureAtlasFormat.LIBGDX);
    await _resourceManager.load();
    return true;
  }

  @override
  void init({Map params: null}) {
    super.init(params: params);

    var spineJson = _resourceManager.getTextFile("stretchyman");
    var textureAtlas = _resourceManager.getTextureAtlas("stretchyman");
    var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
    var skeletonLoader = new SkeletonLoader(attachmentLoader);
    var skeletonData = skeletonLoader.readSkeletonData(spineJson);
    var animationStateData = new AnimationStateData(skeletonData);

    // create the display object showing the skeleton animation

    _skeletonAnimation = new SkeletonAnimation(skeletonData, animationStateData);
    _skeletonAnimation.state.setAnimationByName(0, "sneak", true);

    addChild(_skeletonAnimation);
    Rd.JUGGLER.add(_skeletonAnimation);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _originalSkeletonWidth ??= 380;
    _skeletonAnimation.scaleX = _skeletonAnimation.scaleY = spanWidth / _originalSkeletonWidth / 1.5;
    _skeletonAnimation.x = -100;
    _skeletonAnimation.y = spanHeight - _skeletonAnimation.height - 10;
  }

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_skeletonAnimation);

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
