part of stagexl_example;

class BezierExample extends AbstractScreen {
  List<StreamSubscription<int>> _listeners;

  BezierExample(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    var random = new Random();
    _listeners = new List<StreamSubscription<int>>();

    for (int i = 0; i < 5; i++) {
      var curveData1 = new CurveData.fromRandom(random);
      var curveData2 = new CurveData.fromRandom(random);
      var curve = new Curve(curveData1, curveData2);

      addChild(curve);
      Ac.JUGGLER.add(curve);

      var x = Ac.JUGGLER.interval(1.5).listen((_) {
        var cp = new CurveData.fromRandom(random);
        curve.animateTo(cp);
      });
      _listeners.add(x);
    }

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    _listeners?.forEach((sub) {
      sub.cancel();
      sub = null;
    });
    _listeners = null;
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
  void disappear(
      {double duration: MLifecycle.DISAPPEAR_DURATION_DEFAULT,
      bool autoDispose: false}) {
    super.disappear(duration: duration, autoDispose: autoDispose);
  }
}
