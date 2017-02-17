part of physics_example;

class Box2DRenderMode {
  static const String GRAPHICS = "GRAPHICS";
  static const String PAPER = "PAPER";
  static const String BITMAP = "BITMAP";
}

abstract class MBox2dHelper {
  double m_physScale = 30.0;
  b2World m_world;

  b2Body createBox(String name, num halfWidth, num halfHeight, num xCenter, num yCenter,
      {int type: b2Body.b2_dynamicBody,
      double density: 1.0,
      double friction: 0.2,
      double restitution: 0.0,
      double angle: 0.0,
      String renderMode: Box2DRenderMode.GRAPHICS}) {
    b2BodyDef bodyDef = new b2BodyDef();
    bodyDef.type = type;
    bodyDef.position.Set(xCenter / m_physScale, yCenter / m_physScale);
    bodyDef.angle = angle;

    b2Body body = m_world.CreateBody(bodyDef);
    body.SetUserData(renderMode.toString());

    b2PolygonShape shape = new b2PolygonShape();
    shape.SetAsBox(halfWidth / m_physScale, halfHeight / m_physScale);

    b2FixtureDef fixtureDef = new b2FixtureDef();
    fixtureDef.density = density;
    fixtureDef.friction = friction;
    fixtureDef.restitution = restitution;
    fixtureDef.shape = shape;
    fixtureDef.userData = name;

    body.CreateFixture(fixtureDef);
    return body;
  }

  b2Body createShape(String name, List<b2Vec2> vertices, num xCenter, num yCenter,
      {int type: b2Body.b2_dynamicBody,
      double density: 1.0,
      double friction: 0.2,
      double restitution: 0.0,
      double angle: 0.0,
      String renderMode: Box2DRenderMode.GRAPHICS}) {
    b2BodyDef bodyDef = new b2BodyDef();
    bodyDef.type = type;
    bodyDef.position.Set(xCenter / m_physScale, yCenter / m_physScale);
    bodyDef.angle = angle;

    b2Body body = m_world.CreateBody(bodyDef);
    body.SetUserData(renderMode.toString());

    b2PolygonShape shape = new b2PolygonShape();
    shape.SetAsVector(vertices, vertices.length);

    b2FixtureDef fixtureDef = new b2FixtureDef();
    fixtureDef.density = density;
    fixtureDef.friction = friction;
    fixtureDef.restitution = restitution;
    fixtureDef.shape = shape;
    fixtureDef.userData = name;

    body.CreateFixture(fixtureDef);
    return body;
  }

  b2Body createCircle(String name, num r, num x, num y,
      {int type: b2Body.b2_dynamicBody,
      double density: 1.0,
      double friction: 0.2,
      double restitution: 0.0,
      double angle: 0.0,
      String renderMode: Box2DRenderMode.GRAPHICS}) {
    b2BodyDef bodyDef = new b2BodyDef();
    bodyDef.type = type;
    bodyDef.position.Set(x / m_physScale, y / m_physScale);
    bodyDef.angle = angle;

    b2Body body = m_world.CreateBody(bodyDef);
    body.SetUserData(renderMode.toString());

    b2CircleShape shape = new b2CircleShape(r / m_physScale);

    b2FixtureDef fixtureDef = new b2FixtureDef();
    fixtureDef.density = density;
    fixtureDef.friction = friction;
    fixtureDef.restitution = restitution;
    fixtureDef.shape = shape;
    fixtureDef.userData = name;

    body.CreateFixture(fixtureDef);
    return body;
  }

  void createJoint(b2Body body1, b2Body body2, double lowerAngle, double upperAngle, double x, double y) {
    b2RevoluteJointDef jd = new b2RevoluteJointDef();
    jd.enableLimit = true;

    jd.lowerAngle = lowerAngle;
    jd.upperAngle = upperAngle;
    jd.Initialize(body1, body2, new b2Vec2(x / m_physScale, y / m_physScale));
    m_world.CreateJoint(jd);
  }

  void createSprites() {
    double halfWidth = 0.0;
    double halfHeight = 0.0;
    b2Body b = m_world.GetBodyList();
    b2Fixture f;
    b2Shape s;
    b2Transform xf;
    Sprite sprite;

    for (int j = 0; j < m_world.m_bodyCount; j++) {
      xf = b.m_xf;
      f = b.GetFixtureList();

      for (int k = 0; k < b.m_fixtureCount; k++) {
        s = f.GetShape();
        switch (s.m_type) {
          case b2Shape.e_circleShape:
            sprite = _createCircleSprite(b.GetUserData(), s.m_radius * m_physScale, b);
            break;
          case b2Shape.e_polygonShape:
            List<b2Vec2> vertices = (s as b2PolygonShape).GetVertices();
            halfWidth = f.GetAABB().GetExtents().x * m_physScale;
            halfHeight = f.GetAABB().GetExtents().y * m_physScale;

            sprite = _createPolySprite(b.GetUserData(), vertices, halfWidth, halfHeight, b);
            break;
        }

        //position, rotation, id
        sprite.x = xf.position.x * m_physScale;
        sprite.y = xf.position.y * m_physScale;
        sprite.rotation = xf.GetAngle();
        sprite.name = f.GetUserData();
        (this as Sprite3D).addChild(sprite);

        f = f.m_next;
      }
      b = b.m_next;
    }
  }

  Sprite _createCircleSprite(renderMode, double r, b2Body body) {
    Sprite sprite;
    switch (renderMode) {
      case Box2DRenderMode.PAPER:
        sprite = new MdFab(MdIcon.white(_randomIcon()), bgColor: MdColor.RED, radius: r);
        sprite.pivotX = r;
        sprite.pivotY = r;
        break;
      case Box2DRenderMode.BITMAP:
        break;
      case Box2DRenderMode.GRAPHICS:
      default:
        sprite = RdGraphics.circle(0, 0, r, color: MdColor.RED);
        break;
    }
    return sprite;
  }

  Sprite _createPolySprite(renderMode, List<b2Vec2> vertices, double halfWidth, double halfHeight, b2Body body) {
    Sprite sprite;
    switch (renderMode) {
      case Box2DRenderMode.PAPER:
        sprite = new MdButton("BUTTON",
            width: vertices[1].x * m_physScale * 2,
            height: vertices[2].y * m_physScale * 2,
            fontColor: Colors.WHITE,
            shadow: false,
            bgColor: Theme.COLOR_BASE,
            icon: MdIcon.white(_randomIcon()))
          ..submitCallbackParams = [body]
          ..submitCallback = (b2Body bd) {
            bd.ApplyImpulse(new b2Vec2(new Random().nextDouble() * 100 - 50, new Random().nextDouble() * -150),
                bd.GetWorldCenter());
          };
        sprite.pivotX = halfWidth;
        sprite.pivotY = halfHeight;
        break;
      case Box2DRenderMode.BITMAP:
        break;
      case Box2DRenderMode.GRAPHICS:
      default:
        sprite = new Sprite();

        sprite.graphics.beginPath();
        sprite.graphics.moveTo(vertices[0].x * m_physScale, vertices[0].y * m_physScale);
        for (int i = 1; i < vertices.length; i++) {
          sprite.graphics.lineTo(vertices[i].x * m_physScale, vertices[i].y * m_physScale);
        }
        sprite.graphics.lineTo(vertices[0].x * m_physScale, vertices[0].y * m_physScale);
        //sprite.graphics.strokeColor(MdColor.RED, 3.0);
        sprite.graphics.fillColor(Theme.COLOR_BASE);
        sprite.graphics.closePath();

        if (Rd.WEBGL) {
          //sprite.applyCache(-(sprite.width/2).round(), -(sprite.height/2).round(), sprite.width.round(), sprite.height.round());
        }
        break;
    }
    return sprite;
  }

  int _randomColor() {
    int random = new Random().nextInt(4);
    List<int> col = [
      MdColor.BLACK,
      Theme.COLOR_BASE,
      MdColor.RED,
      MdColor.GREEN,
      MdColor.GREY_DARK,
    ];
    return col[random];
  }

  String _randomIcon() {
    int random = new Random().nextInt(6);
    List<String> icons = [
      MdIconSet.question_answer,
      MdIconSet.mail,
      MdIconSet.menu,
      MdIconSet.account_box,
      MdIconSet.attachment,
      MdIconSet.warning,
      MdIconSet.group_work,
    ];
    return icons[random];
  }

  void onTimer(Timer t) {
    double halfWidth = 0.0;
    double halfHeight = 0.0;
    b2Body b = m_world.GetBodyList();
    b2Fixture f;
    b2Shape s;
    b2Transform xf;

    Sprite sprite;

    for (int j = 0; j < m_world.m_bodyCount; j++) {
      f = b.GetFixtureList();
      xf = b.m_xf;

      for (int k = 0; k < b.m_fixtureCount; k++) {
        sprite = (this as Sprite3D).getChildByName(f.GetUserData());
        if (b.m_type == b2Body.b2_dynamicBody && sprite != null) {
          sprite.x = xf.position.x * m_physScale;
          sprite.y = xf.position.y * m_physScale;
          sprite.rotation = xf.GetAngle();
        }
        f = f.m_next;
      }

      b = b.m_next;
    }
  }
}
