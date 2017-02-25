part of rockdot_template;

class RdRenderLoop extends RenderLoop {
  bool _invalidate = false;
  num _currentTime = 0.0;

  EnterFrameEvent _enterFrameEvent = new EnterFrameEvent(0);
  ExitFrameEvent _exitFrameEvent = new ExitFrameEvent();
  RenderEvent _renderEvent = new RenderEvent();

  //----------------------------------------------------------------------------

  void addStage(Stage stage) {
    if (stage.renderLoop != null) {
      stage.renderLoop.removeStage(stage);
    }

    // stage.onMouseMove.capture((e) => _setRenderMode(stage));
    // stage.onTouchMove.capture((e) => _setRenderMode(stage));
    // stage.onMouseWheel.capture((e) => _setRenderMode(stage));

    super.addStage(stage);
  }

  void removeStage(Stage stage) {
//    stage.onMouseMove.cancelSubscriptions();
    //  stage.onTouchMove.cancelSubscriptions();
    //stage.onMouseWheel.cancelSubscriptions();

    super.removeStage(stage);
  }

  void advanceTime(num deltaTime) {
    _currentTime += deltaTime;

    if (Rd.JUGGLER.hasAnimatables) {
      _setRenderMode(Rd.STAGE);
    }

    _enterFrameEvent.passedTime = deltaTime;
    _enterFrameEvent.dispatch();

    Rd.JUGGLER.advanceTime(deltaTime);

    if (_invalidate) {
      _invalidate = false;
      _renderEvent.dispatch();
    }

    Rd.STAGE.materialize(_currentTime, deltaTime);

    _exitFrameEvent.dispatch();
  }

  _setRenderMode(Stage stage) {
    stage.renderMode = StageRenderMode.ONCE;
  }
}
