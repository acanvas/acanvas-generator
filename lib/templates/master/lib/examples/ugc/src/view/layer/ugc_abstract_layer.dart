part of ugc_example;

/**
 * @author nilsdoehring
 */
class UGCAbstractLayer extends RockdotLifecycleSprite implements IModelAware, IUGCModelAware {
  static const int LAYER_WIDTH_MAX = 440;
  static const int LAYER_HEIGHT_MAX = 580;
  num LAYER_HEIGHT = 0;

  Model model;
  void set appModel(Model appModel) {
    model = appModel;
  }

  UGCModel _ugcModel;
  @override
  set ugcModel(UGCModel ugcModel) {
    _ugcModel = ugcModel;
  }

  Wrap _reflow;
  Sprite _bg;

  UGCAbstractLayer(String id) : super(id) {
    inheritSpan = true;
    autoSpan = false;
    padding = 20;
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // bg image
    _bg = new Sprite();
    addChild(_bg);

    _reflow = new Wrap(spacing: 16, scrollOrientation: ScrollOrientation.VERTICAL, enableMask: false)
      ..inheritSpan = false;
    addChild(_reflow);
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(math.min(LAYER_WIDTH_MAX, Dimensions.WIDTH_STAGE), math.min(LAYER_HEIGHT_MAX, Dimensions.HEIGHT_STAGE), refresh: refresh);
  }

  @override
  void refresh() {
    super.refresh();
    _bg.x = _bg.y = 0;
    _reflow.span(spanWidth - 2*padding, spanHeight - 2*padding);

    //_reflow.span(spanWidth - padding, spanHeight - padding);
    LAYER_HEIGHT = _reflow.height;

    //background
    _bg.graphics.clear();
    _bg.graphics.rect(0, 0, spanWidth, LAYER_HEIGHT);
    _bg.graphics.fillColor(Colors.WHITE);
    _bg.graphics.strokeColor(Theme.BACKGROUND_COLOR, 2.0);

    pivotX = _bg.width / 2;
    pivotY = _bg.height / 2;

    x = (Dimensions.WIDTH_STAGE_REAL / 2).round();
    y = (Dimensions.HEIGHT_STAGE_REAL / 2 + 50).round();
  }
}
