part of dragonbones_example;

class HomeMoreBox extends AcanvasBoxSprite {
  int id;
  MdWrap wrap01;
  ImageSprite image;

  MdText copy;
  HomeMoreBox(this.id) : super() {
    //prefix used for retrieval of properties
    name = "screen.dragonbones_home.more$id";

    wrap01 = new MdWrap(
        Theme.getHeadline(getProperty("headline").toUpperCase(), size: 18),
        align: AlignH.LEFT,
        panelColor: Theme.MD_BUTTON_COLOR,
        spacing: 0,
        padding: 5,
        bgColor: Color.White)
      ..flow.snapToPixels = true;

    image = new ImageSprite()
      ..bitmapData = DragonBonesAssets.getBitmapData("more$id");
    wrap01.addChild(image);

    copy = Theme.getCopy(getProperty("copy"), color: Color.Black, size: 18);
    wrap01.addChild(copy);
    addChild(wrap01);
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(spanWidth, spanHeight, refresh: refresh);
  }

  @override
  void refresh() {
    super.refresh();

    image.scaleToWidth(spanWidth - 1);
    copy.x = (Dimensions.SPACER / 2).round();
    copy.width = spanWidth - Dimensions.SPACER;
    wrap01.span(spanWidth, spanHeight);
  }

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Ac.JUGGLER.removeTweens(this);
    super.dispose(removeSelf: removeSelf);
  }
}
