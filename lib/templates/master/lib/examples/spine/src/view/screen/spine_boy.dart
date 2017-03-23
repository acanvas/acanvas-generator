part of spine_example;

class SpineBoy extends AbstractScreen {
  ResourceManager _resourceManager;

  TextField _textField;

  SkeletonAnimation _skeletonAnimation;
  num _originalSkeletonWidth;

  SpineBoy(String id) : super(id) {
    requiresLoading = true;
    ;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addTextFile("spineboy", "assets/spine/spineboy/spineboy.json");
    _resourceManager.addTextureAtlas("spineboy", "assets/spine/spineboy/spineboy.atlas", TextureAtlasFormat.LIBGDX);
    await _resourceManager.load();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // add TextField to show user information

    _textField = new TextField();
    _textField.defaultTextFormat = new TextFormat("Arial", 24, Color.White);
    //_textField.defaultTextFormat.align = TextFormatAlign.CENTER;
    _textField.text = "tap to change animation";
    _textField.addTo(this);

    // load Spine skeleton

    var spineJson = _resourceManager.getTextFile("spineboy");
    var textureAtlas = _resourceManager.getTextureAtlas("spineboy");
    var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
    var skeletonLoader = new SkeletonLoader(attachmentLoader);
    var skeletonData = skeletonLoader.readSkeletonData(spineJson);

    // configure Spine animation mix

    var animationStateData = new AnimationStateData(skeletonData);
    animationStateData.setMixByName("idle", "walk", 0.2);
    animationStateData.setMixByName("walk", "run", 0.2);
    animationStateData.setMixByName("run", "walk", 0.2);
    animationStateData.setMixByName("walk", "idle", 0.2);

    // create the display object showing the skeleton animation

    _skeletonAnimation = new SkeletonAnimation(skeletonData, animationStateData);
    _skeletonAnimation.state.setAnimationByName(0, "idle", true);
    addChild(_skeletonAnimation);
    Rd.JUGGLER.add(_skeletonAnimation);

    // change the animation on every mouse click

    var animations = ["idle", "shoot", "walk", "run", "death"];
    var animationIndex = 0;

    stage.onMouseClick.listen((me) {
      animationIndex = (animationIndex + 1) % animations.length;
      if (animationIndex == 1) {
        _skeletonAnimation.state.setAnimationByName(1, "shoot", false);
      } else {
        _skeletonAnimation.state.setAnimationByName(0, animations[animationIndex], true);
      }
    });

    // register track events

    _skeletonAnimation.state.onTrackStart.listen((TrackEntryStartEvent e) {
      print("${e.trackEntry.trackIndex} start: ${e.trackEntry}");
    });

    _skeletonAnimation.state.onTrackEnd.listen((TrackEntryEndEvent e) {
      print("${e.trackEntry.trackIndex} end: ${e.trackEntry}");
    });

    _skeletonAnimation.state.onTrackComplete.listen((TrackEntryCompleteEvent e) {
      print("${e.trackEntry.trackIndex} complete: ${e.trackEntry}");
    });

    _skeletonAnimation.state.onTrackEvent.listen((TrackEntryEventEvent e) {
      var ev = e.event;
      var text = "${ev.data.name}: ${ev.intValue}, ${ev.floatValue}, ${ev.stringValue}";
      print("${e.trackEntry.trackIndex} event: ${e.trackEntry}, $text");
    });

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _textField.width = spanWidth / 1.5;
    _textField.x = spanWidth / 2 - _textField.textWidth / 2;
    _textField.y = 20;

    _originalSkeletonWidth ??= 580;
    _skeletonAnimation.scaleX = _skeletonAnimation.scaleY = spanWidth / _originalSkeletonWidth / 1.5;
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
