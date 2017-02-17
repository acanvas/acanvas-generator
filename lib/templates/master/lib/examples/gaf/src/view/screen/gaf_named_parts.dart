part of gaf_example;

class GafNamedParts extends AbstractScreen {
  GAFAsset _gafAsset2;

  GAFMovieClip _gafMovieClip1;

  GAFMovieClip _gafMovieClip2;

  TextField _txtTitle;

  TextField _txtPlain;

  TextField _txtNesting;

  GAFAsset _gafAsset;
  num _originalWidth;

  GafNamedParts(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    _gafAsset = await GAFAsset.load('assets/gaf/robot_plain/robot.gaf', 1, 1);
    _gafAsset2 = await GAFAsset.load('assets/gaf/robot_nesting/robot.gaf', 1, 1);
    onLoadComplete();
    return true;
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    var gafTimeline1 = _gafAsset.getGAFTimelineByLinkage('rootTimeline');

    _gafMovieClip1 = new GAFMovieClip(gafTimeline1);
    _gafMovieClip1.alignPivot(HorizontalAlign.Center, VerticalAlign.Center);
    _gafMovieClip1.mouseChildren = false;
    _gafMovieClip1.mouseCursor = MouseCursor.POINTER;
    _gafMovieClip1.play(true);

    _gafMovieClip1.onMouseClick.listen((me) {
      // toggle plain body-gun bitmap
      GAFBitmap bodyGun = _gafMovieClip1.getChildByName("body_gun");
      bodyGun.visible = !bodyGun.visible;
    });

    addChild(_gafMovieClip1);
    Rd.JUGGLER.add(_gafMovieClip1);

    // load and show the nesting robot asset

    var gafTimeline2 = _gafAsset2.getGAFTimelineByLinkage('rootTimeline');

    _gafMovieClip2 = new GAFMovieClip(gafTimeline2);
    _gafMovieClip2.alignPivot(HorizontalAlign.Center, VerticalAlign.Center);
    _gafMovieClip2.mouseChildren = false;
    _gafMovieClip2.mouseCursor = MouseCursor.POINTER;
    _gafMovieClip2.play(true);

    _gafMovieClip2.onMouseClick.listen((me) {
      // toggle nested body-gun bitmap
      GAFMovieClip body = _gafMovieClip2.getChildByName("body");
      GAFBitmap gun = body.getChildByName("gun");
      gun.visible = !gun.visible;
    });

    addChild(_gafMovieClip2);
    Rd.JUGGLER.add(_gafMovieClip2);

    // show some info texts

    var textFormat = new TextFormat("Roboto, Helvetica, Arial", 24, Color.White);

    _txtTitle = new TextField("Click the robots to show/hide guns", textFormat);
    _txtTitle.autoSize = TextFieldAutoSize.LEFT;
    _txtTitle.addTo(this);

    _txtPlain = new TextField("Conversion: Plain", textFormat);
    _txtPlain.autoSize = TextFieldAutoSize.LEFT;
    _txtPlain.addTo(this);

    _txtNesting = new TextField("Conversion: Nesting", textFormat);
    _txtNesting.autoSize = TextFieldAutoSize.LEFT;
    _txtNesting.addTo(this);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _originalWidth ??= _gafMovieClip1.width;

    _gafMovieClip1.scaleX = _gafMovieClip1.scaleY = spanWidth / _originalWidth / 2;

    _gafMovieClip1.x = _gafMovieClip1.width / 2 + 10;
    _gafMovieClip1.y = spanHeight - _gafMovieClip1.height / 2;

    _gafMovieClip2.scaleX = _gafMovieClip2.scaleY = spanWidth / _originalWidth / 2;

    _gafMovieClip2.x = spanWidth - _gafMovieClip2.width / 2 - 10;
    _gafMovieClip2.y = spanHeight - _gafMovieClip2.height / 2;

    _txtTitle.x = spanWidth / 2 - _txtTitle.width / 2;
    _txtTitle.y = 20;

    _txtPlain.x = _gafMovieClip1.x - _txtPlain.textWidth / 2;
    _txtPlain.y = _gafMovieClip1.y - _gafMovieClip1.height / 2 - 20;

    _txtNesting.x = _gafMovieClip2.x - _txtNesting.textWidth / 2;
    _txtNesting.y = _gafMovieClip2.y - _gafMovieClip2.height / 2 - 20;
  }

  @override
  void dispose({bool removeSelf: true}) {
    _gafMovieClip1.stop(true);
    Rd.JUGGLER.remove(_gafMovieClip1);

    _gafMovieClip2.stop(true);
    Rd.JUGGLER.remove(_gafMovieClip2);

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
