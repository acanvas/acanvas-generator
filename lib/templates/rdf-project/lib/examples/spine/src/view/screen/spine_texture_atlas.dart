part of spine_example;

class SpineTextureAtlas extends AbstractScreen {
  ResourceManager _resourceManager;

  List<SkeletonAnimation> _skeletonAnimations;

  SpineTextureAtlas(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();

    _resourceManager.addTextureAtlas(
        "combined", "assets/spine/texture-atlas/combined.json");
    _resourceManager.addTextFile(
        "goblins-mesh-spine", "assets/spine/texture-atlas/goblins-mesh.json");
    _resourceManager.addTextFile(
        "goblins-mesh-atlas", "assets/spine/texture-atlas/goblins-mesh.atlas");
    _resourceManager.addTextFile(
        "hero-mesh-spine", "assets/spine/texture-atlas/hero-mesh.json");
    _resourceManager.addTextFile(
        "hero-mesh-atlas", "assets/spine/texture-atlas/hero-mesh.atlas");
    _resourceManager.addTextFile(
        "raptor-spine", "assets/spine/texture-atlas/raptor.json");
    _resourceManager.addTextFile(
        "raptor-atlas", "assets/spine/texture-atlas/raptor.atlas");
    _resourceManager.addTextFile(
        "speedy-spine", "assets/spine/texture-atlas/speedy.json");
    _resourceManager.addTextFile(
        "speedy-atlas", "assets/spine/texture-atlas/speedy.atlas");
    _resourceManager.addTextFile("spineboy-hoverboard-spine",
        "assets/spine/texture-atlas/spineboy-hover.json");
    _resourceManager.addTextFile("spineboy-hoverboard-atlas",
        "assets/spine/texture-atlas/spineboy-hoverboard.atlas");

    await _resourceManager.load();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    //---------------------------------------------------------------------------
    // load Spine skeletons from combined texture and the individual definitions

    var names = [
      "goblins-mesh",
      "hero-mesh",
      "raptor",
      "speedy",
      "spineboy-hoverboard"
    ];
    _skeletonAnimations = new List<SkeletonAnimation>();

    for (var name in names) {
      // get spine texture atlases from combined texture atlas

      var bitmapData =
          _resourceManager.getTextureAtlas("combined").getBitmapData(name);
      var spine = _resourceManager.getTextFile("$name-spine");
      var atlas = _resourceManager.getTextFile("$name-atlas");
      TextureAtlas
          .fromBitmapData(bitmapData, atlas, TextureAtlasFormat.LIBGDX)
          .then((textureAtlas) {
        // create spine skeleton data

        var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
        var skeletonLoader = new SkeletonLoader(attachmentLoader);
        var skeletonData = skeletonLoader.readSkeletonData(spine);

        // create spine skeleton animation

        var animationStateData = new AnimationStateData(skeletonData);
        var skeletonAnimation =
            new SkeletonAnimation(skeletonData, animationStateData);

        _skeletonAnimations.add(skeletonAnimation);

        if (name == names.last) {
          //---------------------------------------------------------------------------
          // setup the skeleton animations

          _skeletonAnimations[0] // goblins-mesh
            ..state.setAnimationByName(0, "walk", true)
            ..skeleton.skinName = "goblin";

          _skeletonAnimations[1] // hero-mesh
            ..state.setAnimationByName(0, "Walk", true)
            ..scaleX = 0.7
            ..scaleY = 0.7
            ..x = 260
            ..y = 390;

          _skeletonAnimations[2] // raptor
            ..state.setAnimationByName(0, "walk", true);

          _skeletonAnimations[3] // speedy
            ..state.setAnimationByName(0, "run", true);

          _skeletonAnimations[4] // spineboy-hoverboard
            ..state.setAnimationByName(0, "fly", true);

          // add the skeleton animations to the Stage and the Juggler

          addChild(_skeletonAnimations[0]);
          addChild(_skeletonAnimations[2]);
          addChild(_skeletonAnimations[4]);
          addChild(_skeletonAnimations[1]);
          addChild(_skeletonAnimations[3]);

          Ac.JUGGLER.add(_skeletonAnimations[0]);
          Ac.JUGGLER.add(_skeletonAnimations[1]);
          Ac.JUGGLER.add(_skeletonAnimations[2]);
          Ac.JUGGLER.add(_skeletonAnimations[3]);
          Ac.JUGGLER.add(_skeletonAnimations[4]);

          onInitComplete();
        }
      });
    }
  }

  @override
  void refresh() {
    super.refresh();

    _skeletonAnimations[0] // goblins-mesh
      ..scaleX = 1.0
      ..scaleY = 1.0
      ..x = 150
      ..y = 320;

    _skeletonAnimations[1] // hero-mesh
      ..scaleX = 0.7
      ..scaleY = 0.7
      ..x = 260
      ..y = 390;

    _skeletonAnimations[2] // raptor
      ..scaleX = 0.28
      ..scaleY = 0.28
      ..x = 380
      ..y = 320;

    _skeletonAnimations[3] // speedy
      ..scaleX = 0.65
      ..scaleY = 0.65
      ..x = 550
      ..y = 390;

    _skeletonAnimations[4] // spineboy-hoverboard
      ..scaleX = 0.32
      ..scaleY = 0.32
      ..x = 660
      ..y = 320;
  }

  @override
  void dispose({bool removeSelf: true}) {
    Ac.JUGGLER.remove(_skeletonAnimations[0]);
    Ac.JUGGLER.remove(_skeletonAnimations[1]);
    Ac.JUGGLER.remove(_skeletonAnimations[2]);
    Ac.JUGGLER.remove(_skeletonAnimations[3]);
    Ac.JUGGLER.remove(_skeletonAnimations[4]);

    Ac.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
