part of spine_example;

class SpineVine extends AbstractScreen {
  ResourceManager _resourceManager;

  SkeletonAnimation _skeletonAnimation;
  num _originalSkeletonWidth;

  SpineVine(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextFile("vine", "assets/spine/vine/vine.json");
    _resourceManager.addTextureAtlas("vine", "assets/spine/vine/vine.atlas", TextureAtlasFormat.LIBGDX);
    await _resourceManager.load();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // load Spine skeleton

    var spineJson = _resourceManager.getTextFile("vine");
    var textureAtlas = _resourceManager.getTextureAtlas("vine");
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

    _originalSkeletonWidth ??= 580;
    //_skeletonAnimation.scaleX = _skeletonAnimation.scaleY = spanWidth / _originalSkeletonWidth / 1.5;
    _skeletonAnimation.x = spanWidth / 2 - _skeletonAnimation.width / 2;
    _skeletonAnimation.y = spanHeight - _skeletonAnimation.height - 10;
  }

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_skeletonAnimation);
    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
