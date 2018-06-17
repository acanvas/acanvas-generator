part of acanvas_template;

class LoadScreen extends Sprite {
  /* Constructor Params */
  int color;

  /* Class Members */
  int _rotation = 0;
  Sprite _sprPreloader;
  Timer _timer;

  /* Getters/Setters */
  num _numProgress = 0;
  num get progress {
    return _numProgress;
  }

  LoadScreen({this.color: Colors.BF_BASE_GREEN}) : super() {
    alpha = 0;
    addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
  }

  void _onAddedToStage(Event event) {
    x = stage.stageWidth / 2;
    y = stage.stageHeight / 2;

    _sprPreloader = new Sprite();
    addChild(_sprPreloader);
    _render(0, true);

    addEventListener(Event.ENTER_FRAME, _onEnterFrame);

    Ac.JUGGLER.addTween(this, 0.4, Transition.easeInQuintic)
      ..delay = .3
      ..animate.alpha.to(1.0);
  }

  void _onEnterFrame(Event event) {
    Ac.MATERIALIZE_REQUIRED = true;

    x = stage.stageWidth / 2;
    y = stage.stageHeight / 2;

    _rotation = _rotation + 6;
    if (_rotation == 0) _rotation = 0;
    _render(_rotation, false);

    // TODO revisit this when implementing deferred loading
    /*
    _numProgress += .1;

    if (_numProgress > 1) _numProgress = 1.0;

    if (_numProgress == 1) {
      dispatchEvent(new LifecycleEvent(LifecycleEvent.LOAD_COMPLETE));
      removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
    }
    */
  }

  void cancel() {
    removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
    Ac.MATERIALIZE_REQUIRED = false;

    if (_timer != null) {
      _timer.cancel();
    }
    _clear();
  }

  void _render([num startAng = 0, bool create = true]) {
    if (create) {
      _clear();
    }
    for (int i = 0; i < 12; i++) {
      var theShape = create ? _createShape() : _sprPreloader.getChildAt(i);
      theShape.rotation = ((i * 30) + startAng) * pi / 180;
      theShape.alpha = 0 + (1 / 12 * i);
      if (create) {
        _sprPreloader.addChild(theShape);
      }
    }
    if (Ac.WEBGL) {
      //_sprPreloader.applyCache(-25, -25, 50, 50);
    }
  }

  void _clear() {
    for (int i = 0; i < _sprPreloader.numChildren; i++) {
      _sprPreloader.removeChildAt(i);
    }
  }

  Sprite _createShape() {
    Sprite shape = new Sprite();
    shape.graphics.beginPath();
    shape.graphics.moveTo(-1, -12);
    shape.graphics.lineTo(2, -12);
    shape.graphics.lineTo(1, -5);
    shape.graphics.lineTo(0, -5);
    shape.graphics.lineTo(-1, -12);
    shape.graphics.closePath();
    shape.graphics.fillColor(color);
    return shape;
  }
}
