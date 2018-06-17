part of moppiflower_example;

class SpawnItem {
  bool dead = false;
  Vector vector;

  math.Random random = new math.Random();

  SpawnItem() {
    vector = new Vector(0, 0);
  }

  void draw(Sprite s, MoppiFlowerModel model, {bool style: false}) {}

  bool isDead() {
    return dead;
  }

  double elapsedTimeInMilliseconds() => Ac.JUGGLER.elapsedTime * 1000.0;

  double radians(double atanVal) {
    return atanVal * (math.pi / 180);
  }

  double degrees(double atanVal) {
    return atanVal * (180 / math.pi);
  }
}
