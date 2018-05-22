part of dragonbones_example;

class HomeSection1 extends RockdotBoxSprite {
  ImageSprite spr1;
  MdText hl1;
  MdText cpy1;
  int section;

  HomeSection1(this.section) : super() {
    //prefix used for retrieval of properties
    name = "screen.dragonbones_home.animation.sub$section";
    inheritSpan = true;

    spr1 = new ImageSprite()
      ..bitmapData = DragonBonesAssets.getBitmapData("ani$section")
      ..inheritSpan = false;

    hl1 = Theme.getHeadline(getProperty("headline"),
        color: Color.Black, size: 20)
      ..inheritWidth = false;
    cpy1 = Theme.getCopy(getProperty("copy"), color: Color.Black, size: 14)
      ..inheritWidth = false;

    addChild(spr1);
    addChild(hl1);
    addChild(cpy1);
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(spanWidth, spanHeight / 3, refresh: refresh);
  }

  @override
  void refresh() {
    super.refresh();

    spr1.scaleToHeight(spanHeight);
    spr1.y = 0;
    hl1.y = (spanHeight * .3).round();

    switch (section) {
      case 1: // text left, image right
        spr1.x = spanWidth - spr1.width;
        hl1.x = 0;
        hl1.width = cpy1.width = spanWidth - spr1.width - Dimensions.SPACER;
        break;
      case 2: // text right, image left
        spr1.x = Dimensions.SPACER;
        hl1.x = (spr1.x + spr1.width + Dimensions.SPACER).round();
        hl1.width = cpy1.width = spanWidth - hl1.x;
        break;
    }

    cpy1.x = hl1.x;
    cpy1.y = (hl1.y + hl1.textHeight + Dimensions.SPACER).round();

    spanHeight = height + Dimensions.SPACER;
  }

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Rd.JUGGLER.removeTweens(this);
    super.dispose(removeSelf: removeSelf);
  }
}
