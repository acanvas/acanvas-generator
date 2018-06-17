part of acanvas_template;

class Home extends AbstractReflowScreen implements IScreenServiceAware {
  IScreenService _uiService;

  /* ScreenService setter defined by interface. Injected as per setup in lib/src/project/project.dart */
  @override
  void set uiService(IScreenService uiService) {
    _uiService = uiService;
  }

  Flow _flow;
  ImageSprite _bmp;
  ImageSprite _bmp2;

  Home(String id) : super(id) {
    print("fff");
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _flow = new Flow()..spacing = 30;
    _flow.flowOrientation = FlowOrientation.VERTICAL;
    _flow.inheritSpan = false;

    _bmp = new ImageSprite()
      //..span(spanWidth, spanHeight, refresh: false)
      ..bitmapData = Assets.acanvas
      ..inheritSpan = false
      ..autoSpan = true
      ..useHandCursor = true
      ..addEventListener(Ac.TOUCH ? TouchEvent.TOUCH_END : MouseEvent.MOUSE_UP,
          (e) {
        new AcSignal(StateEvents.ADDRESS_SET,
                "https://github.com/block-forest/acanvas-generator")
            .dispatch();
      });
    _flow.addChild(_bmp);

    for (int i = 1; i < 4; i++) {
      _flow.addChild(Theme.getHeadline(getProperty("prelude.headline0${i}"),
          size: 24, color: Colors.ARCTIC_BLUE));
      _flow.addChild(Theme.getCopy(getProperty("prelude.copy0${i}"),
          size: 16, color: Colors.ARCTIC_BLUE));
    }
    for (int i = 1; i < 8; i++) {
      _flow.addChild(Theme.getHeadline(getProperty("headline0${i}"),
          size: 24, color: Colors.ARCTIC_BLUE));
      _flow.addChild(Theme.getCopy(getProperty("copy0${i}"),
          size: 16, color: Colors.ARCTIC_BLUE));
    }
    _flow.addChild(Theme.getHeadline(getProperty("headline08"),
        size: 24, color: Colors.ARCTIC_BLUE));
    _bmp2 = new ImageSprite()
      //..span(spanWidth, spanHeight, refresh: false)
      ..href = "assets/home/acanvas_spring_architecture.png"
      ..inheritSpan = false
      ..autoSpan = false
      ..useHandCursor = true
      ..addEventListener(Ac.TOUCH ? TouchEvent.TOUCH_END : MouseEvent.MOUSE_UP,
          (e) {
        new AcSignal(StateEvents.ADDRESS_SET,
                "http://acanvas.sounddesignz.com/template/assets/home/acanvas_spring_architecture.png")
            .dispatch();
      })
      ..addEventListener(Event.COMPLETE, (e) {
        onBigImageLoaded();
      });
    _flow.addChild(_bmp2);

    reflow.addChild(_flow);
    reflow.addChild(new Sprite()
      ..graphics.rect(0, 0, spanWidth - 10, Dimensions.SPACER)
      ..graphics.fillColor(0x00ff0000));

    addChild(reflow);

    onInitComplete();
  }

  void onBigImageLoaded() {
    _flow.refresh();
    refresh();
  }

  @override
  void refresh() {
    _bmp.refresh();

    if (_bmp2.loaded) {
      _bmp2.scaleToWidth(spanWidth - 2 * padding);
    }

    _flow.span(spanWidth - 2 * padding, spanHeight);
    _flow.x = padding;
    _bmp.x = (spanWidth / 2 - _bmp.spanWidth / 2).round();

    super.refresh();
  }

  @override
  void dispose({bool removeSelf: true}) {
    Ac.JUGGLER.removeTweens(this);
    super.dispose();
  }

  @override
  void appear({double duration: MLifecycle.APPEAR_DURATION_DEFAULT}) {
    super.appear(duration: duration);

    /*
    Rectangle bounds = _bmp.getBounds(_uiService.foreground);

    _bmp.inheritDispose = false;
    _flow.removeChild(_bmp);

    _uiService.foreground.addChild(_bmp);
    _bmp.x = bounds.left;
    _bmp.y = bounds.top;

    reflow.pivotX = spanWidth;
    reflow.x = spanWidth;

    Ac.JUGGLER.addTween(reflow, 2.8, Transition.easeOutQuintic)
      ..animate3D.rotationY.to(20 * pi / 180)
      ..animate3D.offsetZ.to(50);

    Ac.JUGGLER.addTween(reflow, 2.8, Transition.easeOutQuintic)
      ..animate3D.offsetY.to(spanHeight)
      ..delay = 2.0;
    */
  }
}
