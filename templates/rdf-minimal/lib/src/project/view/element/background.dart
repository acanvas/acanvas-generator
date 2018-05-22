part of rockdot_template;

/**
	 * @author Nils Doehring (nilsdoehring(gmail as at).com)
	 */
class Background extends RockdotLifecycleSprite {
  Shape _bg;

  Background(String id) : super(id) {
    inheritSpan = true;
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // bg grey
    _bg = new Shape();
    addChild(_bg);

    onInitComplete();
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(Dimensions.WIDTH_STAGE, Dimensions.HEIGHT_STAGE);
  }

  @override
  void refresh() {
    super.refresh();

    if (_bg != null) {
      _bg.graphics.clear();
      _bg.graphics.rectRound(0, 0, spanWidth, spanHeight, 8, 8);
      _bg.graphics.fillColor(Colors.GREY_DARK);
      _bg.applyCache(0, 0, spanWidth.round(), spanHeight.round());
    }
  }
}
