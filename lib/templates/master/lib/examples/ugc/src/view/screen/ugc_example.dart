part of ugc_example;

class UGCExample extends AbstractReflowScreen {
  static const int WIDTH_BUTTON = 240;

  MdWrap _wrap01;

  UGCExample(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _wrap01 = new MdWrap(Theme.getHeadline(getProperty("col01").toUpperCase(), size: 18, color: Colors.WHITE),
        panelColor: Colors.RED);
    //_wrap01.addChild(new MdButton("DB Test", bgColor: Theme.COLOR_BASE, fontColor: Colors.WHITE, width: WIDTH_BUTTON)..submitEvent = new RdSignal(GoogleEvents.USER_LOGIN, new GoogleLoginVO(nextSignal: new RdSignal(StateEvents.ADDRESS_SET, getProperty(ScreenIDs.GOOGLE_FRIENDS + ".url", true)))));
    _wrap01.span(300, 420);

    reflow.addChild(_wrap01);

    /*
    _vbox.addChild(new MdButton("DB Test", bgColor: Theme.COLOR_BASE, fontColor: Colors.WHITE)..submitEvent = new RdSignal(UGCEvents.TEST));
    */

    addChild(reflow);
    onInitComplete();
  }
}
