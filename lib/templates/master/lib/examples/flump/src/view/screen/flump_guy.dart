part of flump_example;

class FlumpGuy extends AbstractReflowScreen {
  FlumpLibrary flumpLibrary;

  FlumpMovie _idle;

  FlumpMovie _walk;

  FlumpMovie _attack;

  FlumpMovie _defeat;

  FlumpGuy(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    flumpLibrary = await FlumpLibrary.load('assets/flump/guy/flumpLibrary.json');
    return true;
  }

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    addChild(reflow);

    // create FlumpMovies from the FlumpLibrary

    _idle = new FlumpMovie(flumpLibrary, 'idle');
    addChild(_idle);
    Rd.JUGGLER.add(_idle);

    _walk = new FlumpMovie(flumpLibrary, 'walk');
    addChild(_walk);
    Rd.JUGGLER.add(_walk);

    _attack = new FlumpMovie(flumpLibrary, 'attack');
    addChild(_attack);
    Rd.JUGGLER.add(_attack);

    _defeat = new FlumpMovie(flumpLibrary, 'defeat');
    addChild(_defeat);
    Rd.JUGGLER.add(_defeat);

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    super.refresh();
    _idle.x = 150;
    _idle.y = 350;

    _walk.x = 400;
    _walk.y = 250;

    _attack.x = 650;
    _attack.y = 350;

    _defeat.x = 400;
    _defeat.y = 500;
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_idle);
    Rd.JUGGLER.remove(_walk);
    Rd.JUGGLER.remove(_attack);
    Rd.JUGGLER.remove(_defeat);

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
