part of physics_example;

class Buoyancy extends AbstractBox2dElement implements IBox2dElement {
  List m_bodies = new List();
  b2Controller m_controller;

  Buoyancy(b2World world, double worldScale, num spanWidth, num spanHeight)
      : super(world, worldScale, spanWidth, spanHeight) {
    Sprite waterLine = AcGraphics.line(spanWidth, 0, color: Colors.WHITE);
    waterLine.y = spanHeight / 2;
    addChild(waterLine);

    Sprite water = AcGraphics.rectangle(0, 0, spanWidth, spanHeight / 2,
        color: 0x440000ff);
    water.y = spanHeight / 2;
    addChild(water);
  }

  void createBodies() {
    num halfWidth = spanWidth / 2;
    num halfHeight = spanHeight / 2;

    b2BuoyancyController bc = new b2BuoyancyController();
    m_controller = bc;

    bc.normal.Set(0.0, -1.0);
    bc.offset = -halfHeight / m_physScale;
    bc.density = 2.0;
    bc.linearDrag = 5.0;
    bc.angularDrag = 2.0;

    int i = 0;
    b2Body body;

    // Spawn in a bunch of crap

    for (i = 0; i < 5; i++) {
      body = createBox(
          "box_${i}",
          60.0,
          MdDimensions.HEIGHT_BUTTON / 2,
          new Random().nextDouble() * halfWidth + 0,
          new Random().nextDouble() * (halfHeight - 200) + 100,
          density: 1.0,
          friction: 0.3,
          restitution: 0.1,
          angle: (new Random().nextDouble() * 180) / (180 / pi),
          renderMode: Box2DRenderMode.PAPER);
      m_bodies.add(body);
    }

    for (i = 0; i < 5; i++) {
      body = createCircle(
          "ball_${i}",
          30.0,
          new Random().nextDouble() * halfWidth + 0,
          new Random().nextDouble() * (halfHeight - 150) + 75,
          density: 1.0,
          friction: 0.3,
          restitution: 0.1,
          angle: 0.0,
          renderMode: Box2DRenderMode.PAPER);
      m_bodies.add(body);
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
          new b2Vec2((5 + new Random().nextDouble() * 10) / m_physScale,
              (-10 - new Random().nextDouble() * 10) / m_physScale),
          new b2Vec2((10 + new Random().nextDouble() * 10) / m_physScale,
              (10 + new Random().nextDouble() * 10) / m_physScale)
        ];
      } else if (random > 0.5) {
        List array = [];
        b2Vec2 a0 = new b2Vec2(
            0.0, (10 + new Random().nextDouble() * 10) / m_physScale);
        array.add(a0);
        b2Vec2 a2 = new b2Vec2(
            (-5 - new Random().nextDouble() * 10) / m_physScale,
            (-10 - new Random().nextDouble() * 10) / m_physScale);
        b2Vec2 a3 = new b2Vec2(
            (5 + new Random().nextDouble() * 10) / m_physScale,
            (-10 - new Random().nextDouble() * 10) / m_physScale);

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
          new b2Vec2((5 + new Random().nextDouble() * 10) / m_physScale,
              (-10 - new Random().nextDouble() * 10) / m_physScale)
        ];
      }

      body = createShape(
          "crap_${i}",
          vxs,
          new Random().nextDouble() * halfWidth + 0,
          new Random().nextDouble() * 150 + 50,
          type: b2Body.b2_dynamicBody,
          density: 1.0,
          friction: 0.3,
          restitution: 0.1,
          angle: new Random().nextDouble() * pi);
      m_bodies.add(body);
    }

    m_physScale *= 2;

    //Add some exciting bath toys
    body = createBox("toy_1", 40, 10, 100, halfHeight + 100,
        density: 3.0, friction: 0.2, restitution: 0.0, angle: 0.0);
    m_bodies.add(body);

    b2BodyDef bodyDef = new b2BodyDef();
    bodyDef.type = b2Body.b2_dynamicBody;
    bodyDef.position
        .Set((halfWidth + 100) / m_physScale, (halfHeight + 100) / m_physScale);

    body = m_world.CreateBody(bodyDef);
    body.SetUserData("toy_2");

    b2CircleShape circDef = new b2CircleShape(7 / m_physScale);
    b2FixtureDef fd = new b2FixtureDef();
    fd.shape = circDef;
    fd.density = 2.0;

    fd.userData = "toy_2a";
    circDef.m_p.Set(30 / m_physScale, 0 / m_physScale);
    body.CreateFixture(fd);

    fd.userData = "toy_2b";
    circDef.m_p.Set(-30 / m_physScale, 0 / m_physScale);
    body.CreateFixture(fd);

    fd.userData = "toy_2c";
    circDef.m_p.Set(0 / m_physScale, 30 / m_physScale);
    body.CreateFixture(fd);

    fd.userData = "toy_2d";
    circDef.m_p.Set(0 / m_physScale, -30 / m_physScale);
    body.CreateFixture(fd);

    b2PolygonShape boxDef = new b2PolygonShape();
    fd = new b2FixtureDef();
    fd.shape = boxDef;

    fd.density = 2.0;
    fd.userData = "toy_2e";
    boxDef.SetAsBox(30 / m_physScale, 2 / m_physScale);
    body.CreateFixture(fd);

    fd.density = 2.0;
    fd.userData = "toy_2f";
    boxDef.SetAsBox(2 / m_physScale, 30 / m_physScale);
    body.CreateFixture(fd);

    m_bodies.add(body);

    for (body in m_bodies) {
      m_controller.AddBody(body);
    }

    m_world.AddController(m_controller);
  }
}
