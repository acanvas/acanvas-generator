part of rockdot_template;

class Two extends AbstractScreen {
  ImageSprite _bmp;
  MdButton _button;

  Two(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _bmp = new ImageSprite()
      //..span(spanWidth, spanHeight, refresh: false)
      ..bitmapData = Assets.dog
      ..inheritSpan = false
      ..autoSpan = false;
    addChild(_bmp);

    _button = new MdButton(getProperty("button"), preset: MdButton.PRESET_BLUE);
    _button.submitEvent = new RdSignal(
        StateEvents.ADDRESS_SET, getProperty("layer.photo.url", true));
    addChild(_button);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _bmp.x = 0;
    _bmp.y = 0;
    _bmp.span(spanWidth, spanHeight, refresh: true);

    _button.span(spanWidth / 2, 0);
    _button.x = (spanWidth / 2 - _button.spanWidth / 2).round();
    _button.y =
        (_bmp.y + _bmp.height - _button.height - 6 * Dimensions.SPACER).round();
  }

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
