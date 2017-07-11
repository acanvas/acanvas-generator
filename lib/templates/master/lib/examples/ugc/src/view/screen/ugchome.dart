part of ugc_example;

class UGCHome extends AbstractReflowScreen {
  MdWrap _wrap01;
  UGCHome(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _wrap01 = new MdWrap(Theme.getHeadline(getProperty("col01").toUpperCase(), size: 18, color: Colors.WHITE),
        panelColor: Colors.RED);
    //_wrap01.addChild(new MdButton("DB Test", bgColor: Theme.COLOR_BASE, fontColor: Colors.WHITE, width: WIDTH_BUTTON)..submitEvent = new RdSignal(GoogleEvents.USER_LOGIN, new GoogleLoginVO(nextSignal: new RdSignal(StateEvents.ADDRESS_SET, getProperty(ScreenIDs.GOOGLE_FRIENDS + ".url", true)))));
    _wrap01.addChild(new MdButton("DB Test", bgColor: Theme.COLOR_BASE, fontColor: Colors.WHITE)..submitEvent = new RdSignal(UGCEvents.TEST));
    _wrap01.span(300, 420);

    reflow.addChild(_wrap01);

    addChild(reflow);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    // your redraw operations here
  }

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
