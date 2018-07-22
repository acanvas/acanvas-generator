part of material_example;

class ShaderExample extends AbstractReflowScreen {
  bool _animating = false;
  Flow _hbox6;
  num _time = 0;

  ShaderExample(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    reflow.flow.reflow = false;
    reflow.flow.flowOrientation = FlowOrientation.VERTICAL;

    /* 
     * 1st row: standard square buttons with preset colors 
     */
    Flow hbox1 = new Flow()
      ..inheritSpan = true
      ..spacing = 20;

    MdButton button1 =
        new MdButton(getProperty("button01"), preset: MdButton.PRESET_WHITE)
          ..submitCallback = (b) {
            _hbox6.filters = [new ColorMatrixFilter.invert()];
            _animate();
            // _mousePointerShader();
          };
    hbox1.addChild(button1);

    MdButton button2 =
        new MdButton(getProperty("button02"), preset: MdButton.PRESET_GREY)
          ..submitCallback = (b) {
            _hbox6.filters = [new ColorMatrixFilter.adjust(saturation: 1.0)];
            _animate();
          };
    hbox1.addChild(button2);

    MdButton button3 = new MdButton(getProperty("button03"),
        bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN, fontColor: Colors.WHITE)
      ..submitCallback = (b) {
        _hbox6.filters = [new ColorMatrixFilter.adjust(hue: 0.5)];
        _animate();
      };
    hbox1.addChild(button3);

    MdButton button4 =
        new MdButton(getProperty("button04"), preset: MdButton.PRESET_GREEN)
          ..submitCallback = (b) {
            var bitmapData = null;
            var transform = new Matrix.fromIdentity();

            bitmapData = Assets.displacement_bubble;
            transform.scale(1.2, 1.2);
            transform.translate(cos(0) * 180, 0.0);

            var matrix = new Matrix.fromIdentity();
            matrix.translate(-bitmapData.width / 2, -bitmapData.height / 2);
            matrix.concat(transform);
            matrix.translate(180, 120);

            _hbox6.filters = [
              new DisplacementMapFilter(bitmapData, matrix, 100, 100)
            ];

            _animate();
          };
    hbox1.addChild(button4);

    reflow.addChild(hbox1);

    /*
     * 6th row: Md Dialog with Md Text and Md Buttons; also, Custom Cards
     */

    _hbox6 = new Flow()
      ..inheritSpan = true
      ..spacing = 20;

    MdDialog dialog = new MdDialog("Permission");
    dialog.addContent(new MdText(
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."));
    dialog.addButton(new MdButton("DECLINE",
        preset: MdButton.PRESET_RED,
        fontColor: MdColor.GREY_DARK,
        width: 90,
        background: false));
    dialog.addButton(new MdButton("ACCEPT",
        bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        fontColor: Colors.WHITE,
        width: 90,
        background: false));
    dialog.span(300, 240);
    _hbox6.addChild(dialog);

    Button image = new Button();
    image.addChild(new MdShadow(
        type: MdShadow.RECTANGLE,
        bgColor: MdColor.WHITE,
        respondToClick: false));
    image.addChild(new ImageSprite()
      ..span(300, 240, refresh: false)
      ..href = "http://lorempixel.com/300/240/nature/");
    image.addChild(new MdRipple(color: MdColor.WHITE));
    _hbox6.addChild(image);

    _hbox6.x = 64;
    _hbox6.pivotY = _hbox6.height / 2;

    reflow.addChild(new Sprite()
      ..graphics.rect(0, 0, spanWidth - 50, _hbox6.pivotY - 20)
      ..graphics.fillColor(0x00ff0000));

    _animate();

    reflow.addChild(_hbox6);

    addChild(reflow);
    onInitComplete();
  }

  void _animate() {
    if (_animating == true) {
      return;
    }
    _animating = true;
    Ac.STAGE.juggler.addTween(_hbox6, 15)
      ..animate3D.rotationX.to(360 * pi / 180)
      ..onComplete = () {
        _animating = false;
        _hbox6.rotationX = 0;
      }
      ..onUpdate = () {
        if (_hbox6.filters.length > 0 &&
            _hbox6.filters[0] is DisplacementMapFilter) {
          _time += 0.05;
          (_hbox6.filters[0] as DisplacementMapFilter)
              .matrix
              .translate(cos(_time) * 12, 0.0);
        }
      };
  }

  @override
  void refresh() {
    super.refresh();
  }

  @override
  void dispose({bool removeSelf: true}) {
    super.dispose();
  }
}
