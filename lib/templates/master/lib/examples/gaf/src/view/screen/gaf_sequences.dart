part of gaf_example;

class GafSequences extends AbstractScreen {
  GAFMovieClip _robot;

  GAFAsset _gafAsset;
  num _originalWidth;

  GafSequences(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _gafAsset = await GAFAsset.load('assets/gaf/RedRobot/RedRobot.gaf', 1, 1);
    onLoadComplete();
    return true;
  }

  @override
  void init({Map params: null}) {
    super.init(params: params);

    var gafTimeline = _gafAsset.getGAFTimelineByLinkage('rootTimeline');

    _robot = new GAFMovieClip(gafTimeline);
    _robot.alignPivot(HorizontalAlign.Center, VerticalAlign.Center);
    _robot.mouseChildren = false;
    _robot.mouseCursor = MouseCursor.POINTER;
    _robot.play(true);

    addChild(_robot);
    Rd.JUGGLER.add(_robot);

    // change sequence on click

    var currentSequence = "none";

    void setSequence(String sequenceName) {
      _robot.setSequence(sequenceName, true);
      (_robot.getChildByName("sequence") as TextField).text = sequenceName;
      currentSequence = sequenceName;
    }

    setSequence("stand");

    _robot.onMouseClick.listen((me) {
      if (currentSequence == "stand") {
        setSequence("walk");
      } else {
        setSequence("stand");
      }
    });

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _originalWidth ??= _robot.width;

    _robot.scaleX = _robot.scaleY = spanWidth / _originalWidth / 1.5;

    _robot.x = spanWidth/2;
    _robot.y = spanHeight - _robot.height/2;
  }

  @override
  void dispose({bool removeSelf: true}) {
    _robot.stop(true);
    Rd.JUGGLER.remove(_robot);

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
