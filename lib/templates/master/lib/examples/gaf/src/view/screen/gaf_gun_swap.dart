part of gaf_example;

class GafGunSwap extends AbstractScreen {
  GAFMovieClip _robot;

  GAFAsset _gafAsset;
  num _originalWidth;

  GafGunSwap(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _gafAsset = await GAFAsset.load('assets/gaf/gun_swap/gun_swap.gaf', 1, 1);

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
    addChild(_robot);
    Rd.JUGGLER.add(_robot);
    _robot.play(true);

    // prepare gun swap

    GAFBitmapData gun1 = _gafAsset.getBitmapDataByLinkage("gun1");
    GAFBitmapData gun2 = _gafAsset.getBitmapDataByLinkage("gun2");
    GAFBitmap gunSlot = _robot.getChildByName("GUN");
    gunSlot.bitmapData = gun1;

    _robot.onMouseClick.listen((MouseEvent e) {
      if (gunSlot.bitmapData == gun1) {
        gunSlot.bitmapData = gun2;
        gunSlot.pivotMatrix.translate(-24.2, -41.55);
      } else {
        gunSlot.bitmapData = gun1;
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
