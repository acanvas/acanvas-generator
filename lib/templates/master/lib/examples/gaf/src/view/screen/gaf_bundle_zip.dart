part of gaf_example;

class GafBundleZip extends AbstractScreen {
  ResourceManager _resourceManager;

  num _originalTextWidth;

  GAFBundle _gafBundle;

  GAFAsset _skeletonAsset;

  GAFAsset _monsterAsset;

  GAFMovieClip _skeleton;

  GAFMovieClip _monster;

  GafBundleZip(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _gafBundle = await GAFBundle.loadZipUrl("assets/gaf/bundle_zip/bundle.zip");

    _skeletonAsset = await _gafBundle.getAsset("skeleton", 1, 1);
    _monsterAsset = await _gafBundle.getAsset("ufo-monster", 1, 1);

    onLoadComplete();
    return true;
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map params: null}) {
    super.init(params: params);

    var skeletonTimeline = _skeletonAsset.getGAFTimelineByLinkage('rootTimeline');
    _skeleton = new GAFMovieClip(skeletonTimeline);

    _skeleton.alignPivot(HorizontalAlign.Center, VerticalAlign.Center);
    addChild(_skeleton);
    Rd.JUGGLER.add(_skeleton);
    _skeleton.play(true);

    // get ufo-monster from bundle and start animation

    var monsterTimeline = _monsterAsset.getGAFTimelineByLinkage('rootTimeline');
    _monster = new GAFMovieClip(monsterTimeline);

    _monster.alignPivot(HorizontalAlign.Center, VerticalAlign.Center);
    addChild(_monster);
    Rd.JUGGLER.add(_monster);
    _monster.play(true);

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    _skeleton.scaleX = _skeleton.scaleY = spanWidth / 320 / 1.5;
    _skeleton.x = _skeleton.width/2 + 30;
    _skeleton.y = spanHeight - _skeleton.height/2;

    _monster.x = spanWidth - _monster.width;
    _monster.y = _monster.height;

    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_skeleton);
    Rd.JUGGLER.remove(_monster);

    _skeleton.stop(true);
    _monster.stop(true);

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
