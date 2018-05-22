part of stagexl_example;

class CurveData {
  num x1 = 0, y1 = 0, x2 = 0, y2 = 0;
  num controlX1 = 0, controlY1 = 0;
  num controlX2 = 0, controlY2 = 0;
  num colorA = 0, colorR = 0, colorG = 0, colorB = 0;
  num width = 0;

  CurveData.fromRandom(Random random) {
    x1 = random.nextInt(800);
    y1 = random.nextInt(600);
    x2 = random.nextInt(800);
    y2 = random.nextInt(600);
    controlX1 = random.nextInt(800);
    controlY1 = random.nextInt(600);
    controlX2 = random.nextInt(800);
    controlY2 = random.nextInt(600);
    width = 5 + random.nextInt(10);
    colorA = random.nextDouble();
    colorR = random.nextDouble();
    colorG = random.nextDouble();
    colorB = random.nextDouble();
  }

  CurveData.interpolate(CurveData a, CurveData b, double ratio) {
    x1 = a.x1 + (b.x1 - a.x1) * ratio;
    y1 = a.y1 + (b.y1 - a.y1) * ratio;
    x2 = a.x2 + (b.x2 - a.x2) * ratio;
    y2 = a.y2 + (b.y2 - a.y2) * ratio;
    controlX1 = a.controlX1 + (b.controlX1 - a.controlX1) * ratio;
    controlY1 = a.controlY1 + (b.controlY1 - a.controlY1) * ratio;
    controlX2 = a.controlX2 + (b.controlX2 - a.controlX2) * ratio;
    controlY2 = a.controlY2 + (b.controlY2 - a.controlY2) * ratio;
    width = a.width + (b.width - a.width) * ratio;
    colorA = a.colorA + (b.colorA - a.colorA) * ratio;
    colorR = a.colorR + (b.colorR - a.colorR) * ratio;
    colorG = a.colorG + (b.colorG - a.colorG) * ratio;
    colorB = a.colorB + (b.colorB - a.colorB) * ratio;
  }

  int get color {
    int a = (colorA * 255).round();
    int r = (colorR * 255).round();
    int g = (colorG * 255).round();
    int b = (colorB * 255).round();
    return (a << 24) + (r << 16) + (g << 8) + b;
  }
}
