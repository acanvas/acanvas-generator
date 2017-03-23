part of dragonbones_example;

class HomeBanner extends RockdotBoxSprite {
  MdText headline;
  MdText copy;
  ImageSprite banner;

  HomeBanner() : super() {
    //prefix used for retrieval of properties
    name = "screen.dragonbones_home.animation";

    banner = new ImageSprite()
      ..inheritSpan = false;
    addChild(banner);
    banner.bitmapData = DragonBonesAssets.banner;

    headline = Theme.getHeadline(getProperty("headline"), color: Color.Black, size : 32)
     ..inheritWidth = true;
    addChild(headline);

    copy = Theme.getCopy(getProperty("copy"), color: Color.DarkGray, size: 18)
      ..inheritWidth = true
      ..autoSize = TextFieldAutoSize.CENTER
      ..format.align = TextFormatAlign.CENTER;
    addChild(copy);
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(spanWidth, spanHeight, refresh: refresh);
  }

  @override
  void refresh() {

    banner.scaleToWidth(spanWidth);

    //headline.w
    headline.x = (banner.width/2 - headline.width/2).round();
    headline.y = (banner.height / 3 + 20).round();

    copy.y = (headline.y + headline.height + Dimensions.SPACER).round();
    spanHeight = height;
    super.refresh();
  }

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Rd.JUGGLER.removeTweens(this);
    super.dispose(removeSelf: removeSelf);
  }
}
