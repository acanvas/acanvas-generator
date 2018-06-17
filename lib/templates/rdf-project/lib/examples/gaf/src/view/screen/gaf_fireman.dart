part of gaf_example;

class GafFireman extends AbstractScreen {
  GAFMovieClip _fireman;

  GAFAsset _gafAsset;

  GafFireman(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _gafAsset = await GAFAsset.load('assets/gaf/fireman/fireman.gaf', 1, 1);

    onLoadComplete();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    var gafTimeline = _gafAsset.getGAFTimelineByLinkage('rootTimeline');

    _fireman = new GAFMovieClip(gafTimeline);
    addChild(_fireman);
    Ac.JUGGLER.add(_fireman);
    _fireman.play(true);

    // listen to custom events on the fireman MovieClip

    GAFTextField subtitles_txt = _fireman.getChildByName("subtitles_txt");
    var subtitles = [
      "Our game is on fire!",
      "GAF Team, there is a job for us!",
      "Go and do your best!"
    ];

    _fireman.on<ActionEvent>("showSubtitles").listen((ActionEvent e) {
      var subtitlesIndex = int.parse(e.data) - 1;
      subtitles_txt.text = subtitles[subtitlesIndex];
    });

    _fireman.on<ActionEvent>("hideSubtitles").listen((ActionEvent e) {
      subtitles_txt.text = "";
    });

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();
    _fireman.scaleX = _fireman.scaleY = spanWidth / 600;
    _fireman.x = -80 * _fireman.scaleX;
    ;
    _fireman.y = 15 * _fireman.scaleX;
  }

  @override
  void dispose({bool removeSelf: true}) {
    _fireman.stop(true);
    Ac.JUGGLER.remove(_fireman);

    Ac.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
