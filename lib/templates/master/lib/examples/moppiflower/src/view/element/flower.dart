part of moppiflower_example;

class Flower extends SpawnItem {
  Bitmap bitmap;
  BitmapData image;
  Point position;
  double startTime;
  double degree;
  double lifeTime = 10000.0;
  int type;

  Flower(this.position, this.image, this.startTime, this.degree, {this.type: 1, int color: null}) : super() {
    bitmap = new Bitmap(image);
    if (color != null) {
      bitmap.filters = [new TintFilter.fromColor(color)];
      //bitmap.blendMode = BlendMode.ERASE;
    }
  }

  void draw(Sprite s, MoppiFlowerModel model, {bool style: false}) {
    int elapsedTime = elapsedTimeInMilliseconds().round();

    if ((lifeTime + startTime) < elapsedTime) {
      dead = true;
      s.removeChild(bitmap);
    } else if (!s.contains(bitmap)) {
      s.addChild(bitmap);
    }

    if (type == 0) {
      bitmap.alignPivot();
    } else {
      bitmap.alignPivot(HorizontalAlign.Left, VerticalAlign.Bottom);
    }
    bitmap.x = position.x + model.translation.x;
    bitmap.y = position.y + model.translation.y;

    double scale = (interpolate(startTime, startTime + 400, elapsedTime.toDouble()) -
            0.5 * interpolate(startTime + 400, startTime + 700, elapsedTime.toDouble()) +
            0.2 * interpolate(startTime + 700, startTime + 1000, elapsedTime.toDouble())) *
        1.2;

    //bitmap.alignPivot();
    bitmap.rotation = radians(degree);
    bitmap.scaleX = scale;
    bitmap.scaleY = scale;
  }

  double interpolate(double y1, double y2, double mu) {
    if (mu < y1) return 0.0;
    if (mu > y2) return 1.0;

    return (mu - y1) / (y2 - y1);
  }
}
