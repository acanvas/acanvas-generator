part of physics_example;

class Bridge extends AbstractBox2dElement implements IBox2dElement {
  Bridge(b2World world, double worldScale, num spanWidth, num spanHeight)
      : super(world, worldScale, spanWidth, spanHeight) {}

  void createBodies() {
    b2Body ground = m_world.GetGroundBody();
    int i = 0;
    b2Vec2 anchor = new b2Vec2();
    b2Body body;

    b2FixtureDef fixtureDef;
    // Bridge
    int plankWidth = ((spanWidth - 200) / 10).round();
    int plankWidthHalf = (plankWidth / 2).round();
    int plankY = ((spanHeight) / 2).round();

    b2PolygonShape sd = new b2PolygonShape();
    fixtureDef = new b2FixtureDef();
    sd.SetAsBox((plankWidthHalf + 2) / m_physScale, 15 / m_physScale);
    fixtureDef.shape = sd;
    fixtureDef.density = 20.0;
    fixtureDef.friction = 0.2;

    b2BodyDef bd = new b2BodyDef();
    bd.type = b2Body.b2_dynamicBody;

    b2RevoluteJointDef jd = new b2RevoluteJointDef();
    const int doublePlanks = 10;
    jd.lowerAngle = -15 / (180 / PI);
    jd.upperAngle = 15 / (180 / PI);
    jd.enableLimit = true;

    b2Body prevBody = ground;

    for (i = 0; i < doublePlanks; ++i) {
      bd.position.Set((100 + plankWidthHalf + plankWidth * i) / m_physScale, plankY / m_physScale);
      body = m_world.CreateBody(bd);
      body.SetUserData("brigde_${i}");
      fixtureDef.userData = "brigde_${i}";
      body.CreateFixture(fixtureDef);

      anchor.Set((100 + plankWidth * i) / m_physScale, plankY / m_physScale);
      jd.Initialize(prevBody, body, anchor);
      m_world.CreateJoint(jd);

      prevBody = body;
    }

    anchor.Set((100 + plankWidth * doublePlanks) / m_physScale, plankY / m_physScale);
    jd.Initialize(prevBody, ground, anchor);
    m_world.CreateJoint(jd);

    // Spawn in a bunch of crap
    for (i = 0; i < 5; i++) {
      body = createBox("box_${i}", 60.0, MdDimensions.HEIGHT_BUTTON / 2, _randomX(),
          new Random().nextDouble() * (spanHeight / 2 - 100) + 50,
          density: 1.0, friction: 0.3, restitution: 0.1, angle: 0.0, renderMode: Box2DRenderMode.PAPER);
    }

    for (i = 0; i < 5; i++) {
      body = createCircle("ball_${i}", 30.0, _randomX(), new Random().nextDouble() * (spanHeight / 2 - 100) + 50,
          density: 1.0, friction: 0.3, restitution: 0.1, angle: 0.0, renderMode: Box2DRenderMode.PAPER);
    }

    m_physScale /= 2;

    for (i = 0; i < 15; i++) {
      double random = new Random().nextDouble();
      List<b2Vec2> vxs;

      if (random > 0.66) {
        vxs = [
          new b2Vec2((-10 - new Random().nextDouble() * 10) / m_physScale,
              (10 + new Random().nextDouble() * 10) / m_physScale),
          new b2Vec2((-5 - new Random().nextDouble() * 10) / m_physScale,
              (-10 - new Random().nextDouble() * 10) / m_physScale),
          new b2Vec2(
              (5 + new Random().nextDouble() * 10) / m_physScale, (-10 - new Random().nextDouble() * 10) / m_physScale),
          new b2Vec2(
              (10 + new Random().nextDouble() * 10) / m_physScale, (10 + new Random().nextDouble() * 10) / m_physScale)
        ];
      } else if (random > 0.5) {
        List array = [];
        b2Vec2 a0 = new b2Vec2(0.0, (10 + new Random().nextDouble() * 10) / m_physScale);
        array.add(a0);
        b2Vec2 a2 = new b2Vec2(
            (-5 - new Random().nextDouble() * 10) / m_physScale, (-10 - new Random().nextDouble() * 10) / m_physScale);
        b2Vec2 a3 = new b2Vec2(
            (5 + new Random().nextDouble() * 10) / m_physScale, (-10 - new Random().nextDouble() * 10) / m_physScale);

        b2Vec2 a1 = new b2Vec2((a0.x + a2.x), (a0.y + a2.y));
        a1.Multiply(new Random().nextDouble() / 2 + 0.8);

        b2Vec2 a4 = new b2Vec2((a3.x + a0.x), (a3.y + a0.y));
        a4.Multiply(new Random().nextDouble() / 2 + 0.8);
        vxs = [a0, a1, a2, a3, a4];
      } else {
        vxs = [
          new b2Vec2(0.0, (10 + new Random().nextDouble() * 10) / m_physScale),
          new b2Vec2((-5 - new Random().nextDouble() * 10) / m_physScale,
              (-10 - new Random().nextDouble() * 10) / m_physScale),
          new b2Vec2(
              (5 + new Random().nextDouble() * 10) / m_physScale, (-10 - new Random().nextDouble() * 10) / m_physScale)
        ];
      }

      body = createShape("crap_2_${i}", vxs, _randomX(), new Random().nextDouble() * 150 + 50,
          type: b2Body.b2_dynamicBody,
          density: 1.0,
          friction: 0.3,
          restitution: 0.1,
          angle: new Random().nextDouble() * PI);
    }

    m_physScale *= 2;
  }

  num _randomX() {
    return new Random().nextDouble() * (spanWidth / 2 - 100) + 50;
  }
}
