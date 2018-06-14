part of moppiflower_example;

class FlowerManager {
  MoppiFlowerModel model = new MoppiFlowerModel();

  ResourceManager _res;

  List<Stem> whiteStems = new List<Stem>();
  List<Stem> blackStems = new List<Stem>();
  List<Point> smoothPos = new List<Point>(30);
  int smoothCount = 0;

  List<SpawnItem> spawnItems = new List<SpawnItem>();
  List<Branch> branches = new List<Branch>();

  Bitmap flowerImage;
  Bitmap flowerImage2;
  Bitmap leafImage;
  Bitmap backImage;

  FlowerManager(this._res) : super() {
    for (int i = 0; i < smoothPos.length; i++) {
      smoothPos[i] = new Point(400, 400);
    }

    model.spawnImageArray[0] = _res.getBitmapData("flower_1");
    model.spawnImageArray[1] = _res.getBitmapData("flower_2");
    model.spawnImageArray[2] = _res.getBitmapData("leaf");
    /*
        spawnImageArray[3] =  white1;
        spawnImageArray[3].mask(  loadImage("tron_flower1.jpg"));
        spawnImageArray[4] =  white2;
        spawnImageArray[4].mask(     loadImage("tron_flower2.jpg"));
        spawnImageArray[5] =  white3;
        spawnImageArray[5].mask(  loadImage("tron_leaf.jpg"));
        backImage =  loadImage("test_bg.jpg");
     */
    Stem stem;
    stem = new Stem(20, 10.0, new Point(400, 400), new Point(5, -10),
        (Rd.JUGGLER.elapsedTime * 1000.0).round(), this);
    whiteStems.add(stem);

    stem = new Stem(20, 10.0, new Point(350, 450), new Point(5, -10),
        (Rd.JUGGLER.elapsedTime * 1000.0).round(), this,
        color: Color.Black);
    blackStems.add(stem);
  }

  void draw(BoxSprite s) {
    blackStems.removeWhere((s) => s.isDead());
    whiteStems.removeWhere((s) => s.isDead());
    branches.removeWhere((s) => s.isDead());
    spawnItems.removeWhere((s) => s.isDead());

    //do we need to spawn new stems?
    spawnStems();

    if (whiteStems.length > 0) {
      Stem stem = whiteStems.elementAt(whiteStems.length - 1);
      smoothCount = (++smoothCount) % 30;
      smoothPos[smoothCount] = stem.getCurrentPosition();

      Point smoothedPos = new Point(0, 0);

      for (int i = 0; i < smoothPos.length; i++) {
        smoothedPos = smoothedPos + smoothPos[i];
      }

      smoothedPos *= (1.0 / 30.0);

      model.translation = new Point(s.spanWidth / 2 * 1.1 - smoothedPos.x,
          s.spanHeight / 2 * 1.1 - smoothedPos.y);

      //brown flower

      for (int i = 0; i < whiteStems.length; i++) {
        whiteStems.elementAt(i).draw(s, model, style: true);
      }
      for (int i = 0; i < branches.length; i++) {
        branches.elementAt(i).draw(s, model, style: true);
      }

      //white flower

      for (int i = 0; i < whiteStems.length; i++) {
        whiteStems.elementAt(i).draw(s, model, style: false);
      }

      for (int i = 0; i < branches.length; i++) {
        branches.elementAt(i).draw(s, model, style: false);
      }

      for (int i = 0; i < spawnItems.length; i++) {
        spawnItems.elementAt(i).draw(s, model);
      }

      //black stem
      for (int i = 0; i < blackStems.length; i++) {
        blackStems.elementAt(i).draw(s, model, style: true);
      }
    }
  }

  void spawnStems() {
    if (whiteStems.length > 0) {
      Stem stem = whiteStems.last;
      int startTime = stem.getStartTime();
      int growDuration = stem.getGrowDuration().round();
      int time = (Rd.JUGGLER.elapsedTime * 1000.0).round();
      if (time >= (startTime + growDuration)) {
        //spawn new stem
        int stemLength = new math.Random().nextInt(10) + 14;
        double stemCurve = new math.Random().nextDouble() * 7 - 7 / 2.0;

        whiteStems.add(new Stem(stemLength, stemCurve, stem.getEndPosition(),
            stem.getEndDirection(), startTime + growDuration, this));

        Stem stem2 = blackStems.last;
        Point p = new Point(
            stem.interpolate(
                stem.getEndDirection().x, stem2.getEndDirection().x, .4),
            stem.interpolate(
                stem.getEndDirection().y, stem2.getEndDirection().y, .4));
        blackStems.add(new Stem(stemLength, stemCurve * 1.5,
            stem2.getEndPosition(), p, startTime + growDuration, this,
            color: Color.Black));
      }
    }
  }
}
