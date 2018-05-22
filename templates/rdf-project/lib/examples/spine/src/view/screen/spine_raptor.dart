part of spine_example;

class SpineRaptor extends AbstractScreen {
  ResourceManager _resourceManager;

  SkeletonAnimation _skeletonAnimation;
  num _originalSkeletonWidth;

  StreamSubscription<num> _subscription;

  SpineRaptor(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextFile("raptor", "assets/spine/raptor/raptor.json");
    _resourceManager.addTextureAtlas(
        "raptor", "assets/spine/raptor/atlas3/raptor.json");
    await _resourceManager.load();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // load Spine skeleton

    var spineJson = _resourceManager.getTextFile("raptor");
    var textureAtlas = _resourceManager.getTextureAtlas("raptor");
    var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
    var skeletonLoader = new SkeletonLoader(attachmentLoader);
    var skeletonData = skeletonLoader.readSkeletonData(spineJson);
    var animationStateData = new AnimationStateData(skeletonData);

    // create the display object showing the skeleton animation

    _skeletonAnimation =
        new SkeletonAnimation(skeletonData, animationStateData);
    _skeletonAnimation.state.setAnimationByName(0, "walk", true);

    addChild(_skeletonAnimation);
    Rd.JUGGLER.add(_skeletonAnimation);

    _subscription = Rd.JUGGLER.onElapsedTimeChange.listen((time) {
      _skeletonAnimation.timeScale = 0.7 + 0.5 * sin(time / 2);
    });

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _originalSkeletonWidth ??= 880;
    _skeletonAnimation.scaleX =
        _skeletonAnimation.scaleY = spanWidth / _originalSkeletonWidth / 1.5;
    _skeletonAnimation.x = spanWidth / 2 - _skeletonAnimation.width / 2;
    _skeletonAnimation.y = spanHeight - _skeletonAnimation.height - 10;
  }

  @override
  void dispose({bool removeSelf: true}) {
    _subscription.cancel();
    Rd.JUGGLER.remove(_skeletonAnimation);

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
