part of gaf_example;

class GafSound extends AbstractScreen {
  GAFMovieClip _tank;

  GAFAsset _gafAsset;
  num _originalWidth;

  GafSound(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _gafAsset = await GAFAsset.load('assets/gaf/tank/tank.gaf', 1, 1);
    onLoadComplete();
    return true;
  }

  @override
  void init({Map params: null}) {
    super.init(params: params);

    var gafTimeline = _gafAsset.getGAFTimelineByLinkage('rootTimeline');

    _tank = new GAFMovieClip(gafTimeline);
    _tank.alignPivot(HorizontalAlign.Center, VerticalAlign.Center);
    _tank.play(true);

    addChild(_tank);
    Rd.JUGGLER.add(_tank);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _originalWidth ??= _tank.width;

    _tank.scaleX = _tank.scaleY = spanWidth / _originalWidth / 2;

    _tank.x = spanWidth/2;
    _tank.y = spanHeight/2;
    
  }

  @override
  void dispose({bool removeSelf: true}) {
    _tank.stop(true);
    Rd.JUGGLER.remove(_tank);

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
