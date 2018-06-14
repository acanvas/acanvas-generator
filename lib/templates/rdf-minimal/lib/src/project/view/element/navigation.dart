part of rockdot_template;

/**
 * @author Nils Doehring (nilsdoehring(gmail as at).com)
 */
class Navigation extends RockdotLifecycleSprite {
  MdTabs _tabs;
  MdText _headline;
  MdFab _menuButton;
  List _tabButtons;

  Navigation(String id) : super(id) {
    inheritSpan = true;
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _menuButton = new MdFab(MdIcon.white(MdIconSet.home),
        bgColor: MdColor.BLUE, radius: 20)
      ..submitEvent = new RdSignal(StateEvents.ADDRESS_SET, "/");
    _headline = Theme.getHeadline("", size: 32, color: Colors.WHITE);
    _headline.inheritWidth = false;

    _tabButtons = [ScreenIDs.HOME, ScreenIDs.TWO];

    MdAppBar appBar = new MdAppBar(bgColor: MdColor.BLUE);
    appBar.autoRefresh = true;

    appBar.addToTL(_menuButton);
    appBar.addHeadline(_headline);

    _tabs = new MdTabs(bgColor: MdColor.BLUE);
    _tabButtons.forEach((value) {
      _tabs.addTab(new MdButton(getProperty("$value.title", true).toUpperCase(),
          preset: MdButton.PRESET_BLUE, shadow: false)
        ..submitEvent = new RdSignal(
            StateEvents.ADDRESS_SET, getProperty("$value.url", true)));
    });
    appBar.addMdTabs(_tabs);
    addChild(appBar);

    new RdSignal(StateEvents.STATE_VO_SET, null, _onAddressSet).listen();

    onInitComplete();
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(Dimensions.WIDTH_STAGE, Dimensions.HEIGHT_STAGE,
        refresh: refresh);
  }

  @override
  void refresh() {
    super.refresh();

    // _tabs.span(spanWidth, Dimensions.HEIGHT_RASTER);
  }

  void _onAddressSet(RdSignal e) {
    StateVO vo = e.data;

    if (vo.url.indexOf("layer") == -1) {
      //title animation
      Rd.JUGGLER.addTween(_headline, .1)
        ..animate.y.to(-15)
        ..animate.alpha.to(0)
        ..onComplete = () {
          _headline.text = vo.title;
          _headline.y = 15;

          Tween tw = Rd.JUGGLER.addTween(_headline, .1);
          tw.animate.y.to(5);
          tw.animate.alpha.to(1);
        };
    }

    _tabs.activateTabByUrl(vo.url);

    switch (vo.url) {
      case "/":
        Rd.JUGGLER.addTween(_menuButton, .5)..animate.alpha.to(0);
        break;
      default:
        Rd.JUGGLER.addTween(_menuButton, .5)..animate.alpha.to(1);
        break;
    }
  }
}
