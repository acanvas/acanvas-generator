part of dragonbones_example;

class DragonbonesHome extends AbstractScreen {
  Wrap reflow;
  List<HomeMoreBox> boxes = [];
  Shape bg;

  HomeBanner banner;
  DragonbonesHome(String id) : super(id) {
    requiresLoading = true;
  }

  @override
  Future load({Map params: null}) async {
    await DragonBonesAssets.load();
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    bg = new Shape();
    addChild(bg);

    reflow = new Wrap(
        spacing: 16,
        scrollOrientation: ScrollOrientation.VERTICAL,
        enableMask: false)
      ..padding = 30
      ..inheritSpan = false
      ..autoRefresh = false;

    banner = new HomeBanner();
    reflow.addChild(banner);

    MdText hl1 = Theme.getHeadline(getProperty("headline"),
        color: Color.Black, size: 20);
    reflow.addChild(hl1);

    reflow.addChild(new HomeSection1(1));
    reflow.addChild(new HomeSection1(2));

    for (int i = 1; i < 13; i++) {
      boxes.add(new HomeMoreBox(i)..span(320, 420));
      reflow.addChild(boxes.last);
    }

    addChild(reflow);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    bg.graphics.clear();
    bg.graphics.rect(0, 0, spanWidth, spanHeight);
    bg.graphics.fillColor(Color.White);

    banner.span(spanWidth, spanHeight);

    for (int i = 0; i < boxes.length; i++) {
      boxes[i].span(((spanWidth - 100) / 2).round(), 480);
    }

    reflow.span(spanWidth, spanHeight);
    banner.x = -30;
    banner.y = -30;
  }

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Ac.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
