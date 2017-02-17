part of babylon_example;

class BabylonHome extends AbstractScreen {
  BabylonBitmapData _babylonBitmapData;

  Bitmap _babylonBitmap;

  MdButton _button;

  BabylonHome(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future<bool> load({Map params: null}) async {
    var rootUrl = "http://cdn.babylonjs.com/wwwbabylonjs/Scenes/Retail/";
    var sceneFilename = "Retail.babylon";
    _babylonBitmapData = await BabylonBitmapData.load(rootUrl, sceneFilename, spanWidth, spanHeight);

    onLoadComplete();
    return true;
  }

  //----------------------------------------------------------------------------

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _babylonBitmap = new Bitmap(_babylonBitmapData);
    _babylonBitmap.addTo(this);
    _babylonBitmap.alignPivot();

    _button = new MdButton(getProperty("button01"), preset: MdButton.PRESET_BLUE);
    addChild(_button);

    // activate keyboard control

    var activeCamera = _babylonBitmapData.babylonScene.activeCamera;
    if (activeCamera is BABYLON.FreeCamera) {
      activeCamera.attachControl(html.querySelector('#stage'), false);
      activeCamera.keysUp.add(90); // Z
      activeCamera.keysUp.add(87); // W
      activeCamera.keysDown.add(83); // S
      activeCamera.keysLeft.add(65); // A
      activeCamera.keysLeft.add(81); // Q
      activeCamera.keysRight.add(69); // E
      activeCamera.keysRight.add(68); // D
    }

    onInitComplete();
  }

  //----------------------------------------------------------------------------

  @override
  void refresh() {
    super.refresh();

    Rd.MATERIALIZE_REQUIRED = true;

    // your redraw operations here

    _babylonBitmap.x = spanWidth / 2;
    _babylonBitmap.y = spanHeight / 2;

    _button.x = (_babylonBitmap.getBounds(this).right - _button.width - Dimensions.SPACER).round();
    _button.y = (_babylonBitmap.getBounds(this).bottom - _button.height - Dimensions.SPACER).round();
  }

  //----------------------------------------------------------------------------

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }

  //----------------------------------------------------------------------------
}
