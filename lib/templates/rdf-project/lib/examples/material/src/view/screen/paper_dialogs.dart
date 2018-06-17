part of material_example;

class MdDialogs extends AbstractReflowScreen {
  ImageSprite _bmp;
  MdButton _button;
  Sprite _bg;

  ResourceManager _resourceManager;

  MdDialogs(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addBitmapData("dog", "assets/material/dog.jpg");
    await _resourceManager.load();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _bg = new Sprite();
    addChild(_bg);

    _bmp = new ImageSprite()
      //..span(spanWidth, spanHeight, refresh: false)
      ..bitmapData = _resourceManager.getBitmapData("dog")
      ..inheritSpan = false
      ..autoSpan = false;
    addChild(_bmp);

    MdWrap wrap01 = Theme.getWrap(label: getProperty("col01"));
    wrap01.addChild(new MdButton(getProperty("button01"),
        bgColor: Colors.ORANGE, fontColor: Colors.WHITE, width: 240)
      ..submitEvent = new AcSignal(StateEvents.ADDRESS_SET, "/paper-layer"));
    wrap01.addChild(new MdButton(getProperty("button02"),
        bgColor: Colors.GREEN, fontColor: Colors.WHITE, width: 240)
      ..submitCallback = _openDialog01);
    wrap01.addChild(new MdButton(getProperty("button03"),
        bgColor: Colors.PINK, fontColor: Colors.WHITE, width: 240)
      ..submitCallback = _openDialog02);
    addChild(wrap01);
    wrap01.span(300, 280);
    wrap01.x = 20;
    wrap01.y = 20;

    onInitComplete();
  }

  void _openDialog01(MdButton button) {
    MdDialog dialog = new MdDialog("Permission");
    dialog.addContent(new MdText(
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."));
    dialog.addButton(new MdButton("DECLINE",
        preset: MdButton.PRESET_RED,
        fontColor: MdColor.GREY_DARK,
        width: 90,
        background: false)
      ..submitCallback = (_) => dialog.dispose());
    dialog.addButton(new MdButton("ACCEPT",
        bgColor: Theme.COLOR_BASE,
        fontColor: Colors.WHITE,
        width: 90,
        background: false)
      ..submitCallback = (_) => dialog.dispose());
    dialog.span(300, 240);
    dialog.x = (spanWidth / 2 - dialog.width / 2).round();
    dialog.y = (spanHeight / 2 - dialog.height / 2).round();
    addChild(dialog);
  }

  void _openDialog02(MdButton button) {
    Button image = new Button();
    image.addChild(new MdShadow(
        type: MdShadow.RECTANGLE,
        bgColor: MdColor.WHITE,
        respondToClick: false));
    image.addChild(new ImageSprite()
      ..span(300, 240, refresh: false)
      ..href = "http://lorempixel.com/300/240/nature/");
    image.addChild(new MdRipple(color: MdColor.WHITE));
    image.span(300, 240);
    image.x = spanWidth / 2 - image.width / 2;
    image.y = spanHeight / 2 - image.height / 2;
    image.addChild(new MdFab(MdIcon.black(MdIconSet.close),
        bgColor: MdColor.WHITE, rippleColor: MdColor.BLACK)
      ..x = image.spanWidth - 32
      ..y = -32
      ..submitCallback = (_) => image.dispose());
    addChild(image);
    image.mouseChildren = true;
  }

  @override
  void refresh() {
    _bmp.span(spanWidth + 2 * padding, spanHeight + 2 * padding, refresh: true);
    super.refresh();
  }

  @override
  void dispose({bool removeSelf: true}) {
    Ac.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
