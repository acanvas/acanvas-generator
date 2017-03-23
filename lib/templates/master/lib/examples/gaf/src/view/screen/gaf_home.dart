part of gaf_example;

class GafHome extends AbstractScreen {
  Shape bg;

  Wrap reflow;

  ImageSprite spr1;
  ImageSprite spr2;

  GafHome(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    await GAFAssets.load();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    bg = new Shape();
    addChild(bg);

    reflow = new Wrap(spacing: 30, reflow: false, scrollOrientation: ScrollOrientation.VERTICAL, enableMask: false)
      ..padding = 30
      ..inheritSpan = false
      ..autoRefresh = false;

    reflow.addChild(Theme.getHeadline(getProperty("headline"), color: Color.Black, size: 24));

    spr1 = new ImageSprite();
    reflow.addChild(spr1);
    spr1.bitmapData = GAFAssets.gaf_media_2;

    reflow.addChild(Theme.getHeadline(getProperty("companies"), color: Color.Black, size: 20));

    spr2 = new ImageSprite()
        ..bitmapData = GAFAssets.gaf_companies;
    reflow.addChild(spr2);

    reflow.addChild(Theme.getHeadline(getProperty("headline1"), color: Color.Black, size: 24));
    reflow.addChild(Theme.getCopy(getProperty("copy1"), color: Color.Black, size: 18));
    reflow.addChild(new ImageSprite() ..bitmapData = GAFAssets.other_solutions);

    reflow.addChild(Theme.getHeadline(getProperty("headline2"), color: Color.Black, size: 24));
    reflow.addChild(Theme.getCopy(getProperty("copy2"), color: Color.Black, size: 18));
    reflow.addChild(Theme.getCopy(getProperty("copy21"), color: Color.Black, size: 18));
    reflow.addChild(new ImageSprite() ..bitmapData = GAFAssets.perfromance_newest);

    reflow.addChild(Theme.getHeadline(getProperty("headline3"), color: Color.Black, size: 24));
    reflow.addChild(Theme.getCopy(getProperty("copy3"), color: Color.Black, size: 18));
    reflow.addChild(Theme.getCopy(getProperty("copy31"), color: Color.Black, size: 18));
    reflow.addChild(new ImageSprite() ..bitmapData = GAFAssets.full_animation);

    reflow.addChild(Theme.getHeadline(getProperty("headline4"), color: Color.Black, size: 24));
    reflow.addChild(Theme.getCopy(getProperty("copy4"), color: Color.Black, size: 18));
    reflow.addChild(Theme.getCopy(getProperty("copy41"), color: Color.Black, size: 18));
    reflow.addChild(new ImageSprite() ..bitmapData = GAFAssets.gaf_best);

    addChild(reflow);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    bg.graphics.clear();
    bg.graphics.rect(0, 0, spanWidth, spanHeight);
    bg.graphics.fillColor(Color.White);

    spr1.scaleToWidth(spanWidth);

    reflow.flow.children.forEach((c){
      if(c is ImageSprite && c != spr1) c.scaleToWidth(spanWidth - 60);
      if(c is MdText) c.inheritWidth = true;
    });
    reflow.span(spanWidth, spanHeight);

    spr1.x = -30;
    //spr1.y = spr2.y = -30;
  }

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
