part of physics_example;

class MdPhysics extends AbstractBox2dScreen {
  static const int TOTAL_EXAMPLES = 4;

  BoxSprite activeExample;
  int _activeExampleIndex = 0;
  MdButton _cycleButton;

  MdPhysics(String id) : super(id) {
    debugDrawActive = false;
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _cycleButton = new MdButton(getProperty("button01"),
        fontColor: MdColor.WHITE,
        shadow: true,
        bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN);
    _cycleButton.submitCallback = _onCycleButtonPress;
    addChild(_cycleButton);

    onInitComplete();
  }

  void _onCycleButtonPress(MdButton btn) {
    _setActiveExample(++_activeExampleIndex);
  }

  void _setActiveExample(int idx) {
    if (activeExample != null) {
      stop();

      b2Body b = m_world.GetBodyList();
      for (int j = 0; j < m_world.m_bodyCount; j++) {
        m_world.DestroyBody(b);
        b = b.m_next;
      }
      m_world = null;
      _cycleButton.dispose();
      activeExample.dispose();
      init();
    }

    if (_activeExampleIndex == TOTAL_EXAMPLES) {
      _activeExampleIndex = 0;
    }

    switch (_activeExampleIndex) {
      case 0:
        activeExample =
            new Buoyancy(m_world, m_physScale, spanWidth, spanHeight);
        break;
      case 1:
        activeExample =
            new Ragdolls(m_world, m_physScale, spanWidth, spanHeight);
        break;
      case 2:
        activeExample = new Bridge(m_world, m_physScale, spanWidth, spanHeight);
        break;
      case 3:
        activeExample = new Stacks(m_world, m_physScale, spanWidth, spanHeight);
        break;
    }

    addChildAt(activeExample, 0);
    (activeExample as IBox2dElement).createBodies();
    (activeExample as IBox2dElement).createSprites();

    start();
  }

  @override
  void appear({double duration: MLifecycle.APPEAR_DURATION_DEFAULT}) {
    super.appear(duration: duration);
    _setActiveExample(0);
  }

  @override
  void refresh() {
    _cycleButton.x =
        (spanWidth - _cycleButton.spanWidth - Dimensions.SPACER).round();
    _cycleButton.y = Dimensions.SPACER;
    super.refresh();
  }

  @override
  void onTimer(Timer t) {
    super.onTimer(t);
    if (activeExample != null) {
      (activeExample as IBox2dElement).onTimer(t);
    }
  }
}
