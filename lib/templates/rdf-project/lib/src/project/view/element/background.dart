part of acanvas_template;

/// The Background panel. Always visible. Reacts to changes of Hash_URLs

class Background extends AcanvasLifecycleSprite {
  Shape _bg;

  Background(String id) : super(id) {
    inheritSpan = true;
    inheritInit = true;
  }

  /// Always span to maximum dimensions.

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(Dimensions.WIDTH_STAGE, Dimensions.HEIGHT_STAGE);
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _bg = new Shape();
    addChild(_bg);

    onInitComplete();
  }

  /// Positioning logic

  @override
  void refresh() {
    super.refresh();

    if (_bg != null) {
      _bg.graphics.clear();
      _bg.graphics.rectRound(0, 0, spanWidth, spanHeight, 8, 8);
      _bg.graphics.fillColor(Theme.BG);
      // _bg.applyCache(0, 0, spanWidth.round(), spanHeight.round());
    }
  }
}
