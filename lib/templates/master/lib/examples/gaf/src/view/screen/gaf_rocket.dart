part of gaf_example;

class GafRocket extends AbstractScreen {
  GAFMovieClip _miniGame;

  GAFAsset _gafAsset;
  num _originalWidth;

  GafRocket(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _gafAsset = await GAFAsset.load('assets/gaf/rocket/mini_game.gaf', 1, 1);
    onLoadComplete();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    var gafTimeline = _gafAsset.getGAFTimelineByLinkage('rootTimeline');

    _miniGame = new GAFMovieClip(gafTimeline);
    _miniGame.play(true);

    addChild(_miniGame);
    Rd.JUGGLER.add(_miniGame);

    // initialize the rockets

    for (int i = 1; i <= 4; i++) {
      GAFMovieClip animation = _miniGame.getChildByName("Rocket_with_guide$i");
      GAFMovieClip rocket = animation.getChildByName("Rocket$i");
      rocket.setSequence("idle");
      rocket.onMouseDown.listen((me) {
        rocket.setSequence("explode");
        //rocket.mouseEnabled = false;
        rocket.onSequenceEnd.first.then((se) {
          rocket.setSequence("idle");
          //rocket.mouseEnabled = true;
        });
      });
    }

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _originalWidth ??= _miniGame.width - 100;
    _miniGame.scaleX = _miniGame.scaleY = spanWidth / _originalWidth;

    _miniGame.x = 50 * _miniGame.scaleX;
  }

  @override
  void dispose({bool removeSelf: true}) {
    _miniGame.stop(true);

    Rd.JUGGLER.remove(_miniGame);

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
