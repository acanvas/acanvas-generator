part of gaf_example;

class GafSkeleton extends AbstractScreen {
  GAFMovieClip _skeleton;

  GAFAsset _gafAsset;
  num _originalWidth;

  GafSkeleton(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _gafAsset = await GAFAsset.load('assets/gaf/skeleton/skeleton.gaf', 1, 1);
    onLoadComplete();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    var gafTimeline = _gafAsset.getGAFTimelineByLinkage('rootTimeline');

    _skeleton = new GAFMovieClip(gafTimeline);
    _skeleton.alignPivot(HorizontalAlign.Center, VerticalAlign.Center);

    addChild(_skeleton);
    Rd.JUGGLER.add(_skeleton);
    _skeleton.play(true);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _originalWidth ??= _skeleton.width;

    _skeleton.scaleX = _skeleton.scaleY = spanWidth / _originalWidth / 2;

    _skeleton.x = spanWidth / 2;
    _skeleton.y = spanHeight - _skeleton.height / 2;
  }

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_skeleton);
    _skeleton.stop(true);

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
