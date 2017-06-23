part of moppiflower_example;

class Stem extends Base {
  Stem(int stemLength, double stemCurve, Point startPosition, Point startDirection, int startTime,
      FlowerManager flowerManager,
      {int color: null})
      : super(stemLength, stemCurve, startPosition, startDirection, startTime, flowerManager, color: color) {
    double segmentLength = 10.5;
    Vector displacement = new Vector(startDirection.x, startDirection.y);
    displacement = displacement.normalize();
    displacement = displacement.scaleLength(segmentLength);

    Point stemVertex;

    for (int i = 1; i < points.length; i++) {
      stemVertex = points[i - 1].clone();
      displacement = rotate(displacement, stemCurve);
      stemVertex.offset(displacement.x, displacement.y);

      points[i] = stemVertex;
      // generate flowers and new branches here
      double rand = (random.nextDouble());
      if (rand < 0.10) {
        int type = random.nextInt(100) % 3;
        BitmapData img = flowerManager.model.spawnImageArray[type];

        Point spawnPoint = stemVertex.clone();
        Vector branchAngle = new Vector(displacement.x, displacement.y);

        double angle = 0.0;

        branchAngle = rotate(branchAngle, RandRangeSnap(-40.0, 40.0, 20.0));
        branchAngle.normalize();
        angle = math.atan2(branchAngle.y, branchAngle.x);

        double startTimeSpawn = startTime + (i * 70) + 400.0;

        if (rand >= 0.06)
          flowerManager.spawnItems
              .add(new Flower(spawnPoint, img, startTimeSpawn, degrees(angle), type: type, color: color));
        else
          flowerManager.branches.add(new Branch(random.nextInt(20) + 15, RandRangeSnap(-9.0, 9.0, 2.0), spawnPoint,
              new Point(branchAngle.x, branchAngle.y), startTimeSpawn.round(), flowerManager,
              color: color));
      }
    }

    endPosition = points[points.length - 1];
    endDirection = new Point(displacement.x, displacement.y);
  }

  void draw(Sprite s, MoppiFlowerModel model, {bool style: false}) {
    // timing and segment calculation for the
    // animation

    growSpeedUp = 0.0;
    runSettings();

    List<Point> points = new List.from(this.points, growable: false);
    for (int i = 0; i < points.length; i++) {
      points[i] += model.translation;
    }

    Graphics g = s.graphics;

    if (elapsedTime < growDuration + lifeDuration + deathDuration) {
      g.beginPath();
      for (int i = 0; i < numberOfFullSegs; i++) {
        if (i == 0) {
          g.moveTo(points[i].x, points[i].y);
        } else {
          g.lineTo(points[i + 1].x, points[i + 1].y);
        }
      }

      _stroke(g, style, color, .6 + (color == null ? 6 * model.mid : 0.0)); //strength: 10

      //draws current segment
      if (numberOfFullSegs < stemLength) {
       // g.moveTo(points[numberOfFullSegs].x, points[numberOfFullSegs].y);

        g.lineTo(
            interpolate(
                points[numberOfFullSegs].x.toDouble(), points[numberOfFullSegs + 1].x.toDouble(), currentSegRatio),
            interpolate(
                points[numberOfFullSegs].y.toDouble(), points[numberOfFullSegs + 1].y.toDouble(), currentSegRatio));
        _stroke(g, style, color, .6); //was: 0.2 strength: 7
      }
      g.closePath();
    } else {
      dead = true;
    }
  }
}
