part of rockdot_template;

/**
 * @author nilsdoehring
 */
class Layer extends AbstractLayer {
  MdText _headline;
  ImageSprite _pic;
  MdButton _button;

  Layer(String id) : super(id) {
  }

  @override void init({Map params: null}){
    super.init(params: params);

    String url = model.kitten;
    String closeButtonLabel = getProperty("button.close.meow");
    String headlineText = getProperty("headline");

    _headline = new MdText(headlineText, size: 24);
    addChild(_headline);

    _pic = new ImageSprite()
      ..span(AbstractLayer.LAYER_WIDTH_MAX, AbstractLayer.LAYER_WIDTH_MAX, refresh: false)
      ..href = url
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


  @override void refresh() {
    _headline
      ..x = 20
      ..y = 20;

    _pic.y = _headline.y + _headline.textHeight;

    _button
      ..span(spanWidth, 60)
      ..y = _pic.y + _pic.height;

    LAYER_HEIGHT = _button.y + _button.height;

    super.refresh();
  }

}
