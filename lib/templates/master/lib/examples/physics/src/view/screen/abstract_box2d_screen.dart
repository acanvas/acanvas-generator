part of physics_example;

class AbstractBox2dScreen extends AbstractScreen with MBox2dHelper {
  static const double FPS = 60.0;

  bool debugDrawActive = true;

  Timer _timer;
  int m_velocityIterations = 10;
  int m_positionIterations = 10;
  double m_timeStep = 1.0 / FPS;

  AbstractBox2dScreen(String id) : super(id) {}

  @override
  void init({Map params: null}) {
    super.init(params: params);

    _initWorld();
    if (debugDrawActive) {
      _initDebugDraw();
    }
    _initFrame();
  }

  void _initWorld() {
    b2AABB worldAABB = new b2AABB();
    worldAABB.lowerBound.Set(-1000.0, -1000.0);
    worldAABB.upperBound.Set(1000.0, 1000.0);

    // Define the gravity vector
    b2Vec2 gravity = new b2Vec2(0.0, 10.0);

    // Allow bodies to sleep
    bool doSleep = true;

    // Construct a world object
    m_world = new b2World(gravity, doSleep);
    //m_world.SetBroadPhase(new b2BroadPhase(worldAABB));
    m_world.SetWarmStarting(true);
  }

  void _initFrame() {
    createBox("wallL", 50, spanHeight / 2, -50, spanHeight / 2, type: b2Body.b2_staticBody, density: 3.0);
    createBox("wallR", 50, spanHeight / 2, spanWidth + 50, spanHeight / 2, type: b2Body.b2_staticBody, density: 3.0);
    createBox("wallT", spanWidth / 2, 50, spanWidth / 2, -50, type: b2Body.b2_staticBody, density: 3.0);
    createBox("wallB", spanWidth / 2, 50, spanWidth / 2, spanHeight + 50, type: b2Body.b2_staticBody, density: 3.0);
  }

  void _initDebugDraw() {
    // set debug draw
    b2DebugDraw dbgDraw = new b2DebugDraw();
    //Sprite dbgSprite = new Sprite();
    //m_sprite.addChild(dbgSprite);
    dbgDraw.SetSprite(this);
    dbgDraw.SetDrawScale(30.0);
    dbgDraw.SetFillAlpha(0.3);
    dbgDraw.SetLineThickness(1.0);
    dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
    m_world.SetDebugDraw(dbgDraw);
  }

  void start() {
    Rd.MATERIALIZE_REQUIRED = true;
    _timer = new Timer.periodic(new Duration(milliseconds: (m_timeStep * 1000).round()), onTimer);
  }

  void stop() {
    Rd.MATERIALIZE_REQUIRED = false;
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void onTimer(Timer t) {
    Rd.MATERIALIZE_REQUIRED = true;
    m_world.Step(m_timeStep, m_velocityIterations, m_positionIterations);
    m_world.ClearForces();
    if (debugDrawActive) {
      m_world.DrawDebugData();
    }
    //FRateLimiter.limitFrame(FPS.toInt());
  }

  @override
  void refresh() {
    super.refresh();

    //refresh logic - use spanWidth and spanHeight
  }

  @override
  void dispose({bool removeSelf: true}) {
    stop();
    m_world = null;
    super.dispose();

    //additional cleanup logic
  }
}
