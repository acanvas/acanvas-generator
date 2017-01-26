part of physics_example;

class Stacks extends AbstractBox2dElement implements IBox2dElement {
  Stacks(b2World world, double worldScale, num spanWidth, num spanHeight)
      : super(world, worldScale, spanWidth, spanHeight) {}

  void createBodies() {
    // Create 3 stacks
    int i = 0;
    String renderMode = Box2DRenderMode.PAPER;

    for (i = 0; i < 10; i++) {
      createBox("box_${i}", 60.0, MdDimensions.HEIGHT_BUTTON / 2,
          spanWidth / 2 + 0 + new Random().nextDouble() * 0.02 - 0.01, spanHeight - 60 - i * 60,
          density: 1.0, friction: 0.5, restitution: 0.1, renderMode: renderMode);
    }
    for (i = 0; i < 10; i++) {
      createBox("box2_${i}", 60.0, MdDimensions.HEIGHT_BUTTON / 2,
          spanWidth / 2 + 140 + new Random().nextDouble() * 0.02 - 0.01, spanHeight - 60 - i * 60,
          density: 1.0, friction: 0.5, restitution: 0.1, renderMode: renderMode);
    }
    for (i = 0; i < 10; i++) {
      createBox("box3_${i}", 60.0, MdDimensions.HEIGHT_BUTTON / 2,
          spanWidth / 2 + 280 + new Random().nextDouble() * 0.02 - 0.01, spanHeight - 60 - i * 60,
          density: 1.0, friction: 0.5, restitution: 0.1, renderMode: renderMode);
    }

    for (i = 0; i < 3; i++) {
      createCircle("ball_${i}", 40, 50, 40 + i * 80,
          density: 3.0, friction: 1.0, restitution: 0.2 + i * .2, renderMode: renderMode);
    }

    // Create ramp
    List<b2Vec2> vxs = [
      new b2Vec2(0.0, 150.0 / m_physScale),
      new b2Vec2(0.0, 0.0),
      new b2Vec2(260 / m_physScale, 150.0 / m_physScale)
    ];

    createShape("ramp", vxs, 0.0, (spanWidth / 2).round(), type: b2Body.b2_staticBody, density: 0.0);
  }
}
