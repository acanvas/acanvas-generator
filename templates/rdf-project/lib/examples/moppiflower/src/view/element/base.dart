part of moppiflower_example;

class Base extends SpawnItem {
  List<Point> points;
  int stemColor;

  int stemLength;

  // time
  double growDuration;
  double growSpeedUp;
  double lifeDuration;
  double deathDuration;
  int startTime;

  // for getters
  Point endPosition;
  Point endDirection;

  double elapsedTime;
  double currentSegRatio;
  int numberOfFullSegs;
  int color;

  double getGrowDuration() {
    return growDuration;
  }

  int getStartTime() {
    return startTime;
  }

  double RandRangeSnap(double vmin, double vmax, double snap) {
    return vmin + (random.nextDouble() * (vmax - vmin) / snap).floor() * snap;
  }

  Base(this.stemLength, double stemCurve, Point startPosition,
      Point startDirection, this.startTime, FlowerManager flowerManager,
      {this.color: null})
      : super() {
    points = new List<Point>(stemLength.floor() + 1); // plus startPoint

    growDuration = stemLength * 70.0;
    growSpeedUp = 0.0;
    lifeDuration = 10000.0;
    deathDuration = stemLength * 70.0;

    points[0] = startPosition;
  }

  Point getEndPosition() {
    return endPosition;
  }

  Point getEndDirection() {
    return endDirection;
  }

  Vector rotate(Vector vector, double degree) {
    double rad = radians(degree);
    return vector.rotate(rad);
  }

  Point getCurrentPosition() {
    runSettings();

    Point position;
    if (numberOfFullSegs < stemLength) {
      position = new Point(
          interpolate(points[numberOfFullSegs].x.toDouble(),
              points[numberOfFullSegs + 1].x.toDouble(), currentSegRatio),
          interpolate(points[numberOfFullSegs].y.toDouble(),
              points[numberOfFullSegs + 1].y.toDouble(), currentSegRatio));
    } else
      position =
          new Point(points[numberOfFullSegs].x, points[numberOfFullSegs].y);
    return position;
  }

  double interpolate(double y1, double y2, double mu) {
    if (mu < 0) return y1;
    if (mu > 1) return y2;
    return (y1 * (1 - mu) + y2 * mu);
  }

  void _stroke(Graphics g, bool style, int color, double size) {
    if (style) {
      g.strokeColor(
          color ??
              rgb2hex((203 * 0.6).round(), (172 * 0.6).round(),
                  (132 * 0.6).round()),
          4 * size + 3 + 3,
          JointStyle.ROUND);
    } else {
      g.strokeColor(color ?? Color.White, 4 * size + 2, JointStyle.ROUND);
    }
  }

  int rgb2hex(int r, int g, int b) {
    String a_hex_str = 255.toRadixString(16); // 255 is ff, or fully opaque
    String r_hex_str = r.toRadixString(16);
    String g_hex_str = g.toRadixString(16);
    String b_hex_str = b.toRadixString(16);
    String rgb_hex_str = '0x$a_hex_str$r_hex_str$g_hex_str$b_hex_str';

    int color_rgb_int = int.parse(rgb_hex_str);

    return color_rgb_int;
  }

  void runSettings() {
    elapsedTime = elapsedTimeInMilliseconds() - startTime;
    growDuration = stemLength * 70.0 * (1 - growSpeedUp);
    double ratio = elapsedTime / growDuration;
    double segmentsToDraw = interpolate(0.0, stemLength.toDouble(), ratio);
    numberOfFullSegs = (segmentsToDraw).floor();
    currentSegRatio = segmentsToDraw - numberOfFullSegs;
  }
}
