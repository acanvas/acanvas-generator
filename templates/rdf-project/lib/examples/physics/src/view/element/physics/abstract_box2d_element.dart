part of physics_example;

class AbstractBox2dElement extends BoxSprite with MBox2dHelper {
  // world mouse position
  double mouseXWorldPhys = 0.0;
  double mouseYWorldPhys = 0.0;
  double mouseXWorld = 0.0;
  double mouseYWorld = 0.0;

  b2MouseJoint m_mouseJoint;

  AbstractBox2dElement(
      b2World world, double worldScale, num spanWidth, num spanHeight)
      : super() {
    m_world = world;
    m_physScale = worldScale;
    this.spanWidth = spanWidth;
    this.spanHeight = spanHeight;

    Sprite bg =
        RdGraphics.rectangle(0, 0, spanWidth, spanHeight, color: 0x00000000);
    addChild(bg);

    addEventListener(
        Rd.TOUCH ? TouchEvent.TOUCH_BEGIN : MouseEvent.MOUSE_DOWN, _onPress);
    addEventListener(
        Rd.TOUCH ? TouchEvent.TOUCH_MOVE : MouseEvent.MOUSE_MOVE, _onMove);
    addEventListener(
        Rd.TOUCH ? TouchEvent.TOUCH_END : MouseEvent.MOUSE_UP, _onRelease);
  }

  void _onPress(InputEvent e) {
    _setMouseCoords(e);

    if (m_mouseJoint == null) {
      b2Body body = GetBodyByName((e.target as Sprite).name);

      if (body != null) {
        b2MouseJointDef md = new b2MouseJointDef();
        md.bodyA = m_world.GetGroundBody();
        md.bodyB = body;
        md.target.Set(mouseXWorldPhys, mouseYWorldPhys);
        md.collideConnected = true;
        md.maxForce = 300.0 * body.GetMass();
        m_mouseJoint = m_world.CreateJoint(md) as b2MouseJoint;
        body.SetAwake(true);
      }
    }
  }

  void _onMove(InputEvent e) {
    if (m_mouseJoint != null) {
      _setMouseCoords(e);

      b2Vec2 p2 = new b2Vec2(mouseXWorldPhys, mouseYWorldPhys);
      m_mouseJoint.SetTarget(p2);
    }
  }

  void _setMouseCoords(InputEvent e) {
    Point<num> coords = localToGlobal(new Point<num>(x, y));

    mouseXWorldPhys = (e.stageX - coords.x) / m_physScale;
    mouseYWorldPhys = (e.stageY - coords.y) / m_physScale;

    mouseXWorld = (e.stageX - coords.x);
    mouseYWorld = (e.stageY - coords.y);
  }

  void _onRelease(InputEvent e) {
    if (m_mouseJoint != null) {
      m_world.DestroyJoint(m_mouseJoint);
      m_mouseJoint = null;
    }
  }

  b2Body GetBodyByName(String name) {
    b2Body b = m_world.GetBodyList();
    b2Fixture f;

    for (int j = 0; j < m_world.m_bodyCount; j++) {
      f = b.GetFixtureList();

      for (int k = 0; k < b.m_fixtureCount; k++) {
        if (f.GetUserData() == name) {
          return b;
          //return f.GetBody();
        }
        f = f.m_next;
      }

      if (b.GetUserData() == name) {
        return b;
      }

      b = b.m_next;
    }

    return null;
  }

  @override
  void dispose({bool removeSelf: true}) {
    removeEventListener(
        Rd.TOUCH ? TouchEvent.TOUCH_BEGIN : MouseEvent.MOUSE_DOWN, _onPress);
    removeEventListener(
        Rd.TOUCH ? TouchEvent.TOUCH_MOVE : MouseEvent.MOUSE_MOVE, _onMove);
    removeEventListener(
        Rd.TOUCH ? TouchEvent.TOUCH_END : MouseEvent.MOUSE_UP, _onRelease);
    super.dispose();
  }
}
