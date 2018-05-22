part of spine_example;

class SpineGoblinsFfd extends AbstractScreen {
  ResourceManager _resourceManager;

  SkeletonAnimation _skeletonAnimation;
  num _originalSkeletonWidth;

  SpineGoblinsFfd(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextFile(
        "goblins", "assets/spine/goblins-ffd/goblins-mesh.json");
    _resourceManager.addTextureAtlas(
        "goblins",
        "assets/spine/goblins-ffd/goblins-mesh.atlas",
        TextureAtlasFormat.LIBGDX);
    await _resourceManager.load();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // load Spine skeleton

    var spineJson = _resourceManager.getTextFile("goblins");
    var textureAtlas = _resourceManager.getTextureAtlas("goblins");
    var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
    var skeletonLoader = new SkeletonLoader(attachmentLoader);
    var skeletonData = skeletonLoader.readSkeletonData(spineJson);
    var animationStateData = new AnimationStateData(skeletonData);

    // create the display object showing the skeleton animation

    _skeletonAnimation =
        new SkeletonAnimation(skeletonData, animationStateData);
    _skeletonAnimation.state.setAnimationByName(0, "walk", true);
    _skeletonAnimation.skeleton.skinName = "goblin";
    addChild(_skeletonAnimation);
    Rd.JUGGLER.add(_skeletonAnimation);

    // feature: change the skin used for the skeleton

    //skeletonAnimation.skeleton.skinName = "goblin";
    //skeletonAnimation.skeleton.skinName = "goblingirl";

    // feature: change the attachments assigned to slots

    //skeletonAnimation.skeleton.setAttachment("left hand item", "dagger");
    //skeletonAnimation.skeleton.setAttachment("right hand item", null);
    //skeletonAnimation.skeleton.setAttachment("right hand item 2", null);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _originalSkeletonWidth ??= 280;
    _skeletonAnimation.scaleX =
        _skeletonAnimation.scaleY = spanWidth / _originalSkeletonWidth / 1.5;
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
