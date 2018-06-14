part of physics_example;

class Ragdolls extends AbstractBox2dElement implements IBox2dElement {
  Ragdolls(b2World world, double worldScale, num spanWidth, num spanHeight)
      : super(world, worldScale, spanWidth, spanHeight) {}

  void createBodies() {
    String renderMode = Box2DRenderMode.PAPER;

    double factor = 1.5;
    m_physScale /= factor;

    // Add 5 ragdolls along the top
    for (int i = 0; i < 2; i++) {
      double startX =
          (70 + new Random().nextDouble() * 20 + spanWidth * .7 * i) / 2;
      double startY = (spanHeight - 480 + new Random().nextDouble() * 50) / 2;

      b2Body head = createCircle("${i}_head", 12.5, startX, startY,
          density: 1.0,
          friction: 0.4,
          restitution: 0.3,
          renderMode: renderMode);
      head.ApplyImpulse(
          new b2Vec2(new Random().nextDouble() * 100 - 50,
              new Random().nextDouble() * 100 - 50),
          head.GetWorldCenter());

      b2Body torso1 = createBox("${i}_torso1", 15, 10, startX, startY + 28,
          density: 1.0, friction: 0.4, restitution: 0.1);
      b2Body torso2 = createBox("${i}_torso2", 15, 10, startX, startY + 43,
          density: 1.0, friction: 0.4, restitution: 0.1);
      b2Body torso3 = createBox("${i}_torso3", 15, 10, startX, startY + 58,
          density: 1.0, friction: 0.4, restitution: 0.1);

      b2Body upperArmL = createBox(
          "${i}_upperArmL", 18, 6.5, startX - 30, startY + 20,
          density: 1.0, friction: 0.4, restitution: 0.1);
      b2Body upperArmR = createBox(
          "${i}_upperArmR", 18, 6.5, startX + 30, startY + 20,
          density: 1.0, friction: 0.4, restitution: 0.1);

      b2Body lowerArmL = createBox(
          "${i}_lowerArmL", 17, 6, startX - 57, startY + 20,
          density: 1.0, friction: 0.4, restitution: 0.1);
      b2Body lowerArmR = createBox(
          "${i}_lowerArmR", 17, 6, startX + 57, startY + 20,
          density: 1.0, friction: 0.4, restitution: 0.1);

      b2Body upperLegL = createBox(
          "${i}_upperLegL", 7.5, 22, startX - 8, startY + 85,
          density: 1.0, friction: 0.4, restitution: 0.1);
      b2Body upperLegR = createBox(
          "${i}_upperLegR", 7.5, 22, startX + 8, startY + 85,
          density: 1.0, friction: 0.4, restitution: 0.1);

      b2Body lowerLegL = createBox(
          "${i}_lowerLegL", 6, 20, startX - 8, startY + 120,
          density: 1.0, friction: 0.4, restitution: 0.1);
      b2Body lowerLegR = createBox(
          "${i}_lowerLegR", 6, 20, startX + 8, startY + 120,
          density: 1.0, friction: 0.4, restitution: 0.1);

      // Head to shoulders
      createJoint(
          torso1, head, -40 / (180 / pi), 40 / (180 / pi), startX, startY + 15);

      // torso to upper arm
      createJoint(torso1, upperArmL, -85 / (180 / pi), 130 / (180 / pi),
          startX - 18, startY + 20);
      createJoint(torso1, upperArmR, -130 / (180 / pi), 85 / (180 / pi),
          startX + 18, startY + 20);

      // Lower arm to upper arm
      createJoint(upperArmL, lowerArmL, -130 / (180 / pi), 10 / (180 / pi),
          startX - 45, startY + 20);
      createJoint(upperArmR, lowerArmR, -10 / (180 / pi), 130 / (180 / pi),
          startX + 45, startY + 20);

      // Shoulders/stomach
      createJoint(torso1, torso2, -15 / (180 / pi), 15 / (180 / pi), startX,
          startY + 35);
      // Stomach/hips
      createJoint(torso2, torso3, -15 / (180 / pi), 15 / (180 / pi), startX,
          startY + 50);

      // Torso to upper legs
      createJoint(torso3, upperLegL, -25 / (180 / pi), 45 / (180 / pi),
          startX - 8, startY + 72);
      createJoint(torso3, upperLegR, -45 / (180 / pi), 25 / (180 / pi),
          startX + 8, startY + 72);

      // Upper leg to lower leg
      createJoint(upperLegL, lowerLegL, -25 / (180 / pi), 115 / (180 / pi),
          startX - 8, startY + 105);
      createJoint(upperLegR, lowerLegR, -115 / (180 / pi), 25 / (180 / pi),
          startX + 8, startY + 105);
    }

    // Add stairs on the left, these are static bodies so set the type accordingly
    for (int j = 1; j <= 10; j++) {
      createBox("${j}_stairL", (10 * j), 10, (10 * j) / factor,
          (spanHeight - 210 + 20 * j) / factor,
          type: b2Body.b2_staticBody,
          density: 0.0,
          friction: 0.4,
          restitution: 0.3);
    }

    // Add stairs on the right
    for (int k = 1; k <= 10; k++) {
      createBox("${k}_stairR", (10 * k), 10, (spanWidth - 10 * k) / factor,
          (spanHeight - 210 + 20 * k) / factor,
          type: b2Body.b2_staticBody,
          density: 0.0,
          friction: 0.4,
          restitution: 0.3);
    }

    createBox(
        "midbox", 30, 40, spanWidth / 2 / factor, (spanHeight - 40) / factor,
        type: b2Body.b2_staticBody,
        density: 0.0,
        friction: 0.4,
        restitution: 0.1);

    m_physScale *= factor;
  }
}
