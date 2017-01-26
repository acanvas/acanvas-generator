part of rockdot_template;

class RdRenderLoop extends RenderLoop {

  List<Stage> _stages = new List<Stage>();
  bool _invalidate = false;
  num _currentTime = 0.0;
  int _tick = 0;

  EnterFrameEvent _enterFrameEvent = new EnterFrameEvent(0);
  ExitFrameEvent _exitFrameEvent = new ExitFrameEvent();
  RenderEvent _renderEvent = new RenderEvent();

  //----------------------------------------------------------------------------

  void invalidate() {
    _invalidate = true;
    super.invalidate();
  }

  //----------------------------------------------------------------------------

  void addStage(Stage stage) {
    super.addStage(stage);
    _stages.add(stage);
  }

  //----------------------------------------------------------------------------

  void removeStage(Stage stage) {
    super.removeStage(stage);
    _stages.remove(stage);
  }

  //----------------------------------------------------------------------------

  void advanceTime(num deltaTime) {

    //----------------------------

    /*
    // Reduce framerate to 30 fps

    if(_tick % 2 == 0)
    {
      _tick++;
      return;
    }
     */
    if(_tick > 9) _tick = 0;

    //----------------------------

    // Reduce framerate to 6 fps if nothing is going on

    if(Rd.JUGGLER.hasAnimatables || Rd.MATERIALIZE_REQUIRED || _tick % 10 == 0){
      _currentTime += deltaTime;

      _enterFrameEvent.passedTime = deltaTime;
      _enterFrameEvent.dispatch();

      juggler.advanceTime(deltaTime);

      for (int i = 0; i < _stages.length; i++) {
        _stages[i].juggler.advanceTime(deltaTime);
      }

      if (_invalidate) {
        _invalidate = false;
        _renderEvent.dispatch();
      }

      for (int i = 0; i < _stages.length; i++) {
        _stages[i].materialize(_currentTime, deltaTime);
      }

      _exitFrameEvent.dispatch();
    }

    _tick++;
  }

}
