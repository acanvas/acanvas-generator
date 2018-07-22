part of acanvas_template;

class Home extends AbstractScreen implements IScreenServiceAware {
  static const int PADDING = 32;
  IScreenService _uiService;

  /* ScreenService setter defined by interface. Injected as per setup in lib/src/project/project.dart */
  @override
  void set uiService(IScreenService uiService) {
    _uiService = uiService;
  }

  Wrap reflow;
  ImageSprite _acanvasWideLogo;
  ImageSprite _acanvasComponentDiagram;

  Home(String id) : super(id) {
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _acanvasWideLogo = new ImageSprite()
      //..span(spanWidth, spanHeight, refresh: false)
      ..bitmapData = Assets.acanvas_logo_wide_bnw
      ..inheritSpan = true
      ..autoSpan = true
      ..useHandCursor = true
      ..addEventListener(Ac.TOUCH ? TouchEvent.TOUCH_END : MouseEvent.MOUSE_UP,
          (e) {
        new AcSignal(StateEvents.ADDRESS_SET,
                "https://github.com/acanvas/acanvas-generator")
            .dispatch();
      });
    addChild(_acanvasWideLogo);

    reflow = new Wrap(
        spacing: 32,
        reflow: false,
        scrollOrientation: ScrollOrientation.VERTICAL,
        enableMask: true)
      ..padding = PADDING
      ..inheritSpan = false
      ..autoRefresh = false;

    reflow.addChild(Theme.getHeadline(getProperty("headline"), size: 28));
    reflow.addChild(Theme.getCopy(getProperty("copy"), size: 18));

    reflow.addChild(Theme.getHeadline(getProperty("prelude.headline01"), size: 28));
    reflow.addChild(Theme.getCopy(getProperty("prelude.copy01"), size: 18));

    reflow.addChild(Theme.getButton(label: getProperty("prelude.generator.button.label"))..submitEvent = new AcSignal(StateEvents.ADDRESS_SET, getProperty("prelude.generator.button.url")));

    for (int i = 2; i < 4; i++) {
      reflow.addChild(Theme.getHeadline(getProperty("prelude.headline0${i}")));
      reflow.addChild(Theme.getCopy(getProperty("prelude.copy0${i}")));
    }
    for (int i = 1; i < 8; i++) {
      reflow.addChild(Theme.getHeadline(getProperty("headline0${i}")));
      reflow.addChild(Theme.getCopy(getProperty("copy0${i}")));
    }
    reflow.addChild(Theme.getHeadline(getProperty("headline08")));
    _acanvasComponentDiagram = new ImageSprite()
      //..span(spanWidth, spanHeight, refresh: false)
      ..href = "assets/home/acanvas_spring_architecture.png"
      ..inheritSpan = false
      ..autoSpan = false
      ..useHandCursor = true
      ..addEventListener(Ac.TOUCH ? TouchEvent.TOUCH_END : MouseEvent.MOUSE_UP,
          (e) {
        new AcSignal(StateEvents.ADDRESS_SET,
                "https://acanvas.sounddesignz.com/downloads/acanvas-spring-architecture.png")
            .dispatch();
      })
      ..addEventListener(Event.COMPLETE, (e) {
        onBigImageLoaded();
      });
    reflow.addChild(_acanvasComponentDiagram);

    addChild(reflow);


    onInitComplete();
  }

  void onBigImageLoaded() {
    reflow.refresh();
    refresh();
  }

  @override
  void refresh() {
    _acanvasWideLogo.scaleToWidth(spanWidth);


    if (_acanvasComponentDiagram.loaded) {
      _acanvasComponentDiagram.scaleToWidth(spanWidth - 2 * PADDING);
    }

    reflow.y = _acanvasWideLogo.height;
    reflow.span(spanWidth, spanHeight - reflow.y);

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
