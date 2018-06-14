part of moppiflower_example;

class Branch extends Base {
  Branch(int stemLength, double stemCurve, Point startPosition,
      Point startDirection, int startTime, FlowerManager flowerManager,
      {int color: null})
      : super(stemLength, stemCurve, startPosition, startDirection, startTime,
            flowerManager,
            color: color) {
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
      double rand = (random.nextDouble());
      if (rand < 0.05 && (i < (points.length - 3))) {
        int type = random.nextInt(100) % 3;
        BitmapData img = flowerManager.model.spawnImageArray[type];

        Point spawnPoint = stemVertex.clone();
        Vector branchAngle = new Vector(displacement.x, displacement.y);

        double angle = 0.0;

        branchAngle = rotate(branchAngle, RandRangeSnap(-40.0, 40.0, 20.0));
        branchAngle.normalize();
        angle = math.atan2(branchAngle.y, branchAngle.x);

        double startTimeSpawn = startTime + (i * 40) + 200.0;

        flowerManager.spawnItems.add(new Flower(
            spawnPoint + new Point(-10, -10),
            img,
            startTimeSpawn,
            degrees(angle),
            type: type));
      }
      if ((i == (points.length - 2))) {
        int type = random.nextInt(100) % 3;
        BitmapData img = flowerManager.model.spawnImageArray[type];
        Point spawnPoint = stemVertex.clone();
        if (type == 1)
          spawnPoint = points[i];
        else
          spawnPoint = points[i - 2];

        double startTimeSpawn = startTime + (i * 40) + 200.0;

        double angle = 0.0;

        Vector branchAngle = new Vector(displacement.x, displacement.y);
        //branchAngle = rotate(branchAngle,  RandRangeSnap(-40.0, 40.0, 20.0));
        branchAngle = branchAngle.normalize();
        angle = math.atan2(branchAngle.y, branchAngle.x);
        flowerManager.spawnItems.add(new Flower(
            spawnPoint + new Point(-10, -10),
            img,
            startTimeSpawn,
            degrees(angle),
            type: type,
            color: color));
      }
    }

    endPosition = points[points.length - 1];
    endDirection = new Point(displacement.x, displacement.y);
  }

  void draw(Sprite s, MoppiFlowerModel model, {bool style: false}) {
    growSpeedUp = 0.0;
    runSettings();

    List<Point> points = new List.from(this.points);
    for (int i = 0; i < points.length; i++) {
      points[i] += model.translation;
    }

    Graphics g = s.graphics;

    if (elapsedTime < growDuration + lifeDuration + deathDuration) {
      g.beginPath();
      double size = 0.1;
      for (int i = 0; i < numberOfFullSegs + 1 - 1; i++) {
        size = 1 - (i.toDouble() / (numberOfFullSegs + 1));
        g.moveTo(points[i].x, points[i].y);
        g.lineTo(points[i + 1].x, points[i + 1].y);
      }
      _stroke(g, style, color,
          size * .6 + (color == null ? 3 * model.mid : 0.0)); //strength: 10

      //draws current segment
      if (numberOfFullSegs < stemLength) {
        g.moveTo(points[numberOfFullSegs].x, points[numberOfFullSegs].y);

        g.lineTo(
            interpolate(points[numberOfFullSegs].x,
                points[numberOfFullSegs + 1].x, currentSegRatio),
            interpolate(points[numberOfFullSegs].y,
                points[numberOfFullSegs + 1].y, currentSegRatio));
        _stroke(g, style, color, 0.6);
      }
      g.closePath();
    } else {
      dead = true;
    }
  }
}
