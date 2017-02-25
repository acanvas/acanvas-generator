part of rockdot_template;

class Home extends AbstractReflowScreen implements IScreenServiceAware {
  IScreenService _uiService;
  /* ScreenService setter defined by interface. Injected as per setup in lib/src/project/project.dart */
  @override
  void set uiService(IScreenService uiService) {
    _uiService = uiService;
  }

  Flow _flow;
  ImageSprite _bmp;

  Home(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _flow = new Flow()..spacing = 30;
    _flow.flowOrientation = FlowOrientation.VERTICAL;
    _flow.inheritSpan = false;

    _bmp = new ImageSprite()
      //..span(spanWidth, spanHeight, refresh: false)
      ..bitmapData = Assets.rockdot
      ..inheritSpan = false
      ..autoSpan = false
      ..useHandCursor = true
      ..addEventListener(Rd.TOUCH ? TouchEvent.TOUCH_END : MouseEvent.MOUSE_UP, (e) {
        new RdSignal(StateEvents.ADDRESS_SET, "https://github.com/block-forest/rockdot-generator").dispatch();
      });
    _flow.addChild(_bmp);

    for (int i = 1; i < 4; i++) {
      _flow.addChild(Theme.getHeadline(getProperty("prelude.headline0${i}"), size: 24, color: Colors.ARCTIC_BLUE));
      _flow.addChild(Theme.getCopy(getProperty("prelude.copy0${i}"), size: 16, color: Colors.ARCTIC_BLUE));
    }
    for (int i = 1; i < 8; i++) {
      _flow.addChild(Theme.getHeadline(getProperty("headline0${i}"), size: 24, color: Colors.ARCTIC_BLUE));
      _flow.addChild(Theme.getCopy(getProperty("copy0${i}"), size: 16, color: Colors.ARCTIC_BLUE));
    }
    reflow.addChild(_flow);
    reflow.addChild(new Sprite()
      ..graphics.rect(0, 0, spanWidth - 10, Dimensions.SPACER)
      ..graphics.fillColor(0x00ff0000));

    addChild(reflow);
    onInitComplete();
  }

  @override
  void refresh() {
    _bmp.scaleToWidth(spanWidth - 2 * padding);
    _bmp.spanHeight = _bmp.height;
    _flow.span(spanWidth - 2 * padding, spanHeight);
    _flow.x = padding;
    super.refresh();
  }

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }

  @override
  void appear({double duration: MLifecycle.APPEAR_DURATION_DEFAULT}) {
    super.appear(duration: duration);
    return;
    Rectangle bounds = _bmp.getBounds(_uiService.foreground);

    _bmp.inheritDispose = false;
    _flow.removeChild(_bmp);

    _uiService.foreground.addChild(_bmp);
    _bmp.x = bounds.left;
    _bmp.y = bounds.top;

    reflow.pivotX = spanWidth;
    reflow.x = spanWidth;

    Rd.JUGGLER.addTween(reflow, 2.8, Transition.easeOutQuintic)
      ..animate3D.rotationY.to(20 * PI / 180)
      ..animate3D.offsetZ.to(50);

    Rd.JUGGLER.addTween(reflow, 2.8, Transition.easeOutQuintic)
      ..animate3D.offsetY.to(spanHeight)
      ..delay = 2.0;
  }
}
