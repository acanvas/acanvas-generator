part of moppiflower_example;

class MoppiFlowerExample extends AbstractScreen {
  ResourceManager _resourceManager;

  SoundAnalyzer _soundAnalyzer;
  FlowerManager _flowerManager;
  StreamSubscription subs;

  Bitmap _background;

  MdButton _button;

  MoppiFlowerExample(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    _resourceManager = new ResourceManager();
    _resourceManager.addBitmapData("flower_1", "assets/moppiflower/test_flower1.png");
    _resourceManager.addBitmapData("flower_2", "assets/moppiflower/test_flower2.png");
    _resourceManager.addBitmapData("leaf", "assets/moppiflower/test_leaf.png");
    _resourceManager.addBitmapData("overlay", "assets/moppiflower/test_overlay.jpg");
    //_resourceManager.addSound("soundtrack", "assets/moppiflower/Santogold-Starstruck-Southbound-Hangers-Remix.mp3");
    await _resourceManager.load();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _background = new Bitmap(_resourceManager.getBitmapData('overlay'));
    _background.blendMode = BlendMode.MULTIPLY;
    addChild(_background);

    if (SoundMixer.engine == SoundEngine.WebAudioApi) {
      _soundAnalyzer = new SoundAnalyzer();
    }
    _flowerManager = new FlowerManager(_resourceManager);

    //Rd.STAGE.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
    subs = Rd.JUGGLER.interval(1 / 22.0).listen((e) => _onEnterFrame(null));

    if(Rd.IOS){
      _button = new MdButton(getProperty("button01"), preset: MdButton.PRESET_BLUE)
        ..submitCallback = _click
        ..submitCallbackParams = [];
      addChild(_button);
    }

    onInitComplete();
  }

  _click() {
    _button.dispose();
    SoundMixer.unlockMobileAudio();
    _soundAnalyzer._startIos();
  }

  void _onEnterFrame(Event e) {
    graphics.clear();

    graphics.rect(0, 0, spanWidth, spanHeight);
    graphics.fillColor(Color.LightGray);

    _soundAnalyzer?.update(_flowerManager.model, s: null);

    _flowerManager.draw(this);

    pivotX = 0;
    pivotY = 0;

    //_background.alpha = math.min(.5 + _flowerManager.model.mid/2, 1.0);

    Rd.MATERIALIZE_REQUIRED = true;
  }

  @override
  void refresh() {
    super.refresh();

    _background.width = spanWidth;
    _background.height = spanHeight;

    _button?.x = spanWidth - _button.width - 10;
    _button?.y = spanHeight - _button.height - 10;
  }

  @override
  void dispose({bool removeSelf: true}) {
    subs.cancel();
    Rd.STAGE.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
    _soundAnalyzer?.dispose();
    _resourceManager.dispose();
    super.dispose();
  }


}
