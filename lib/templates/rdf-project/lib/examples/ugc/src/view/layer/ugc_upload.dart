part of ugc_example;

/**
 * @author nilsdoehring
 */
class UGCUpload extends UGCAbstractLayer {
  ImageSprite _pic;
  Shape _imageBg;
  DivElement _inputDiv;

  MdButton _button;

  UGCUpload(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _reflow.addChild(
        Theme.getHeadline(getProperty("headline"), color: Colors.BLACK));

    _imageBg = new Shape();
    _reflow.addChild(_imageBg);

    _button = Theme.getButton(label: getProperty("button.upload"));
    _button.visible = false;
    _reflow.addChild(_button);

    onInitComplete();
    new AcSignal(IOEvents.FILE_SELECT_CREATE, null, _onSelectCreated)
        .dispatch();
  }

  _onSelectCreated(DivElement div) {
    _inputDiv = div;
    refresh();
    new AcSignal(IOEvents.FILE_SELECT_OBSERVE, new IOImageFileObserveVO(),
            _onFilesSelected)
        .dispatch();
  }

  _onFilesSelected(BitmapData bmd) {
    model.imageToUpload = bmd;

    _button.visible = true;
    _button.submitEvent = new AcSignal(StateEvents.ADDRESS_SET,
        getProperty("${UGCExampleScreenIDs.UGC_LAYER_REGISTER}.url", true));

    _pic = new ImageSprite();
    //_reflow.flow.addChildAt(_pic, _reflow.flow.getChildIndex(_imageBg));
    _reflow.addChild(_pic);
    _reflow.flow.swapChildren(_imageBg, _pic);

    _reflow.flow.removeChild(_imageBg);
    _imageBg.graphics.clear();
    _imageBg = null;

    _pic
      ..inheritSpan = false
      ..addEventListener(Event.COMPLETE, _onImageLoadComplete)
      ..setBitmapData(bmd);
  }

  void _onImageLoadComplete(Event event) {
    _pic.removeEventListener(Event.COMPLETE, _onImageLoadComplete);
    Ac.MATERIALIZE_REQUIRED = true;
    refresh();
  }

  @override
  void refresh() {
    int imageWH = _reflow.spanWidth;

    if (_imageBg != null) {
      _imageBg.graphics
        ..clear()
        ..rect(0, 0, imageWH, imageWH)
        ..fillColor(Theme.EXAMPLES_HIGHLIGHT_MAIN);
    }

    if (_inputDiv != null) {
      //Point p = localToGlobal(new Point(x, y));
      // ignore: conflicting_dart_import
      Point p = new Point(x, y);

      _inputDiv.style
        ..left = "${p.x - 120}px"
        ..top = "${p.y + 30}px";
    }

    if (_pic != null) {
      _pic.span(imageWH, imageWH, refresh: true);
      _inputDiv.style.display = "none";
      _pic.y = 35;
    }

    super.refresh();
  }

  @override
  void dispose({bool removeSelf: true}) {
    super.dispose(removeSelf: removeSelf);
    _inputDiv.style.display = "none";
  }
}
