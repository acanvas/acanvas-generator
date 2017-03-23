part of material_example;

/**
 * @author nilsdoehring
 */
class Layer extends RockdotLifecycleSprite {
  static const int LAYER_WIDTH_MAX = 480;
  num LAYER_HEIGHT = 0;

  Sprite _bg;
  MdText _headline;
  ImageSprite _pic;
  MdButton _button;

  Layer(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    // bg image
    _bg = new Sprite();
    addChild(_bg);

    String closeButtonLabel = getProperty("button.close.meow");
    String headlineText = getProperty("headline");

    _headline = new MdText(headlineText, size: 24);
    addChild(_headline);

    _pic = new ImageSprite()
      ..span(LAYER_WIDTH_MAX, LAYER_WIDTH_MAX, refresh: false)
      ..href = "assets/material/kitten.jpg"
      ..addEventListener(Event.COMPLETE, _onImageLoadComplete);
    addChild(_pic);

    _button = new MdButton(closeButtonLabel, preset: MdButton.PRESET_GREEN, shadow: false)
      ..submitEvent = new RdSignal(StateEvents.STATE_VO_BACK)
      ..inheritSpan = false;
    addChild(_button);

    onInitComplete();
  }

  void _onImageLoadComplete(Event event) {
    _pic.removeEventListener(Event.COMPLETE, _onImageLoadComplete);
    refresh();
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(min(LAYER_WIDTH_MAX, Dimensions.WIDTH_STAGE), Dimensions.HEIGHT_STAGE, refresh: refresh);
  }

  @override
  void refresh() {
    super.refresh();

    _headline
      ..x = 20
      ..y = 20;

    _pic.y = _headline.y + _headline.textHeight;

    _button
      ..span(spanWidth, 60)
      ..y = _pic.y + _pic.height;

    LAYER_HEIGHT = _button.y + _button.height;

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
