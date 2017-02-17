part of bitmapfont_example;

class BitmapFontHome extends AbstractReflowScreen {
  BitmapFontHome(String id) : super(id) {}

  //----------------------------------------------------------------------------

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    addChild(reflow);

    onInitComplete();
  }

  //----------------------------------------------------------------------------

  @override
  void refresh() {
    super.refresh();

    // your redraw operations here
  }

  //----------------------------------------------------------------------------

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }

  //----------------------------------------------------------------------------
}
