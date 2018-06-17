part of acanvas_template;

/// The application's entrypoint manages StageXL initalization and Preloading of Acanvas.
/// In most cases, you'll leave this untouched.

class Entrypoint {
  // Class members

  html.CanvasElement _stageEl;
  Stage _stage;
  RenderLoop _renderLoop;
  LoadScreen _sprPreloader;

  Entrypoint() {
    // Enables/Disables Logging
    //TODO solve with vars
    AcConstants.DEBUG = "@project.debug@" == "false" ? false : true;
  }

  // Invoked by web/project.dart

  void init(String qS) {
    _stageEl = html.querySelector(qS);

    // Startup StageXL
    var opts = new StageOptions();

    var query =
        "(-webkit-min-device-pixel-ratio: 2), (min-device-pixel-ratio: 2), (min-resolution: 192dpi)";
    if (html.window.matchMedia(query).matches) {
      // support high-dpi
      opts.maxPixelRatio = 3.0;
      //StageXL.bitmapDataLoadOptions.pixelRatios = <double>[1.0, 2.0, 3.0];
    } else {
      opts.maxPixelRatio = 1.0;
      //StageXL.bitmapDataLoadOptions.pixelRatios = <double>[1.0];
    }

    opts.stageScaleMode = StageScaleMode.NO_SCALE;
    opts.stageRenderMode = StageRenderMode.ONCE;
    opts.stageAlign = StageAlign.TOP_LEFT;
    opts.backgroundColor = Theme.BACKGROUND_COLOR;

    // Due to performance reasons, we use Canvas2D on mobile by default
    // You can add ?gl=0|1 to force GL off or on
    if (Uri.base.queryParameters['gl'] == "1") {
      opts.renderEngine = RenderEngine.WebGL;
    } else if (Uri.base.queryParameters['gl'] == "0") {
      opts.renderEngine = RenderEngine.Canvas2D;
    } else if (Ac.MOBILE) {
      opts.renderEngine = RenderEngine.Canvas2D;
    } else {
      opts.renderEngine = RenderEngine.WebGL;
    }

    opts.antialias = Ac.MOBILE ? false : true;

    //----------------------------

    // Events and Event Default behaviour

    opts.inputEventMode =
        Ac.MOBILE ? InputEventMode.TouchOnly : InputEventMode.MouseOnly;
    opts.preventDefaultOnTouch = true;
    opts.preventDefaultOnWheel = true;
    opts.preventDefaultOnKeyboard = false;

    //----------------------------

    // RenderLoop

    _stage = new Stage(_stageEl, options: opts);
    _renderLoop = new AcRenderLoop();
    _renderLoop.addStage(_stage);
    Ac.STAGE = _stage;

    //----------------------------

    // Manage resizing of CanvasElement
    html.window.onResize.listen((e) {
      _resize();
    });

    // Initial resize of CanvasElement
    _resize();

    // 2D smoothing
    if (_stageEl.context2D != null) {
      _stageEl.context2D.imageSmoothingEnabled = true;
    }

    // init load animation and bootstrap setup procedure
    _initPreloader();
    _initAcBootstrap();
  }

  /// Show Load Screen and initialize the project's AcBootstrap

  void _initPreloader() {
    // For the moment, we're loading all classes first, then the loader appears, then Assets are loaded (see AcBootstrap)

    _sprPreloader = new LoadScreen();
    _stage.addChild(_sprPreloader);
  }

  /// Initiate load operations in AcBootstrap (properties, assets)

  Future _initAcBootstrap() async {
    AcBootstrap bootstrap = new AcBootstrap(_stage);
    bootstrap.init();

    await bootstrap.load().catchError((error) {
      print("AcBootstrap class could not be loaded.\n ${error}");
    });

    Ac.JUGGLER.addTween(_sprPreloader, .5, Transition.easeOutBack)
      ..animate.alpha.to(0.0)
      ..onComplete = () {
        _sprPreloader.cancel();
        _stage.removeChild(_sprPreloader);
        _sprPreloader = null;
      };
  }

  /// Resizing

  void _resize() {
    num windowWidth = 0;
    num windowHeight = 0;

    if (Ac.MOBILE) {
      /// Adjust DevicePixelRatio if screen too small
      if (html.window.innerWidth < Dimensions.WIDTH_MIN) {
        html.Element h = html.querySelector("#viewport");

        /// A ratio of 0.8 gives good results on a broad number of tablets and smartphones
        String ratio = "0.8";

        /* A calculcated ratio can lead to unintended results */
        //String ratio = (html.window.innerWidth/Dimensions.WIDTH_MIN).toStringAsFixed(2);

        h.setAttribute("content",
            "width=device-width, user-scalable=no, initial-scale=$ratio, minimum-scale=$ratio, maximum-scale=$ratio, template-ui");
      }

      windowWidth = html.window.innerWidth;
      windowHeight = html.window.innerHeight;

      html.window.scrollTo(0, 1);
    } else {
      windowWidth = min(Dimensions.WIDTH_MAX, html.window.innerWidth);
      windowHeight = min(Dimensions.HEIGHT_MAX, html.window.innerHeight);
    }

    /// Size the Canvas container  according to min/max dimensions (see Dimensions)
    _stageEl.style.width = "${windowWidth}px";
    _stageEl.style.height = "${windowHeight}px";

    html.Element holder = html.querySelector("#canvas-holder");
    holder.style.maxWidth = "${windowWidth}px";
    holder.style.maxHeight = "${windowHeight}px";

    Ac.MATERIALIZE_REQUIRED = true;
  }
}
