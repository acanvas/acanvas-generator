part of rockdot_template;


/**
 * @author nilsdoehring
 */
class AbstractLayer extends RockdotLifecycleSprite implements IModelAware {

  static const int LAYER_WIDTH_MAX = 480;
  num LAYER_HEIGHT = 0;

  Model model;
  void set appModel(Model appModel) {
    model = appModel;
  }

  Sprite _bg;

  AbstractLayer(String id) : super(id) {
    inheritSpan = true;
    autoSpan = false;
  }

  @override void init({Map params: null}){

    super.init(params: params);

    // bg image
    _bg = new Sprite();
    addChild(_bg);
  }

  @override void span(num spanWidth, num spanHeight, {bool refresh: true}){
    super.span(min(LAYER_WIDTH_MAX, Dimensions.WIDTH_STAGE), Dimensions.HEIGHT_STAGE, refresh: refresh);

  }

  @override void refresh() {
    super.refresh();

    if (LAYER_HEIGHT == 0) {
      return;
    }

    //background
    _bg.graphics.clear();

    _bg.graphics.clear();
    _bg.graphics.rect(0, 0, spanWidth, LAYER_HEIGHT);
    _bg.graphics.fillColor(Colors.WHITE);

    pivotX = _bg.width / 2;
    pivotY = _bg.height / 2;

    x = (Dimensions.WIDTH_STAGE_REAL / 2).round();
    y = (Dimensions.HEIGHT_STAGE_REAL / 2 + 50).round();
  }

}
