part of material_example;

class MdAppBarExample extends AbstractReflowScreen {
  MdAppBarExample(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    reflow.flow.reflow = false;
    reflow.flow.flowOrientation = FlowOrientation.VERTICAL;

    MdAppBar appBar01 = new MdAppBar(bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN);
    appBar01.addToTL(new MdIconButton(MdIcon.inverted(MdIconSet.menu)));
    appBar01
        .addToTR(new MdIconButton(MdIcon.inverted(MdIconSet.arrow_drop_down)));
    reflow.addChild(appBar01);

    MdAppBar appBar02 = new MdAppBar(bgColor: Colors.BLACK);
    appBar02.addToTL(new MdIconButton(
        MdIcon.color(MdIconSet.menu, Theme.EXAMPLES_MD_BUTTON_ICON_COLOR),
        rippleColor: Theme.EXAMPLES_MD_BUTTON_COLOR)
      ..opacity = .75);
    appBar02.addHeadline(Theme.getHeadline("Headline", color: Colors.WHITE));
    appBar02.addToTR(new MdIconButton(
        MdIcon.color(MdIconSet.account_box, Theme.EXAMPLES_MD_BUTTON_ICON_COLOR),
        rippleColor: Theme.EXAMPLES_MD_BUTTON_COLOR)
      ..opacity = .75);
    appBar02.addToTR(new MdIconButton(
        MdIcon.color(MdIconSet.accessibility, Theme.EXAMPLES_MD_BUTTON_ICON_COLOR),
        rippleColor: Theme.EXAMPLES_MD_BUTTON_COLOR)
      ..opacity = .75);
    appBar02.addToTR(new MdIconButton(
        MdIcon.color(MdIconSet.arrow_drop_down, Theme.EXAMPLES_MD_BUTTON_ICON_COLOR),
        rippleColor: Theme.EXAMPLES_MD_BUTTON_COLOR)
      ..opacity = .75);
    reflow.addChild(appBar02);

    MdAppBar appBar03 = new MdAppBar(bgColor: MdColor.WHITE);
    appBar03.extended = true;
    appBar03.addToTL(new MdIconButton(MdIcon.black(MdIconSet.menu),
        rippleColor: Theme.EXAMPLES_HIGHLIGHT_MAIN_ALT));
    appBar03.addHeadline(Theme.getHeadline("Headline", color: MdColor.BLACK));
    appBar03.addToTR(new MdIconButton(MdIcon.black(MdIconSet.account_box),
        rippleColor: Theme.EXAMPLES_HIGHLIGHT_MAIN_ALT));
    appBar03.addToTR(new MdIconButton(MdIcon.black(MdIconSet.accessibility),
        rippleColor: Theme.EXAMPLES_HIGHLIGHT_MAIN_ALT));
    appBar03.addToTR(new MdIconButton(MdIcon.black(MdIconSet.arrow_drop_down),
        rippleColor: Theme.EXAMPLES_HIGHLIGHT_MAIN_ALT));
    reflow.addChild(appBar03);

    MdAppBar appBar04 = new MdAppBar(bgColor: MdColor.WHITE);
    appBar04.addToTL(new MdIconButton(
        MdIcon.color(MdIconSet.menu, MdColor.GREY_DARK),
        rippleColor: Theme.EXAMPLES_MD_BUTTON_COLOR)
      ..opacity = .25);
    appBar04
        .addHeadline(Theme.getHeadline("Headline", color: MdColor.GREY_DARK));
    appBar04.addToTR(new MdIconButton(
        MdIcon.color(MdIconSet.account_box, MdColor.GREY_DARK),
        rippleColor: Theme.EXAMPLES_MD_BUTTON_COLOR)
      ..opacity = .25);
    appBar04.addToTR(new MdIconButton(
        MdIcon.color(MdIconSet.accessibility, MdColor.GREY_DARK),
        rippleColor: Theme.EXAMPLES_MD_BUTTON_COLOR)
      ..opacity = .25);
    appBar04.addToTR(new MdIconButton(
        MdIcon.color(MdIconSet.arrow_drop_down, MdColor.GREY_DARK),
        rippleColor: Theme.EXAMPLES_MD_BUTTON_COLOR)
      ..opacity = .25);

    MdTabs tabs = new MdTabs();
    tabs.distributeTabs = true;
    tabs.addTab(new MdButton(getProperty("tab01").toUpperCase(),
        bgColor: Theme.EXAMPLES_MD_BUTTON_COLOR,
        fontColor: Theme.EXAMPLES_MD_BUTTON_FONT_COLOR,
        shadow: false));
    // ..submitEvent = new AcSignal(StateEvents.ADDRESS_SET, getProperty("$value.url", true))
    //);
    tabs.addTab(new MdButton(getProperty("tab02").toUpperCase(),
        bgColor: Theme.EXAMPLES_MD_BUTTON_COLOR,
        fontColor: Theme.EXAMPLES_MD_BUTTON_FONT_COLOR,
        shadow: false));
    // ..submitEvent = new AcSignal(StateEvents.ADDRESS_SET, getProperty("$value.url", true))
    //);
    tabs.addTab(new MdButton(getProperty("tab03").toUpperCase(),
        bgColor: Theme.EXAMPLES_MD_BUTTON_COLOR,
        fontColor: Theme.EXAMPLES_MD_BUTTON_FONT_COLOR,
        shadow: false));
    // ..submitEvent = new AcSignal(StateEvents.ADDRESS_SET, getProperty("$value.url", true))
    //);
    appBar04.addMdTabs(tabs);
    reflow.addChild(appBar04);

    addChild(reflow);

    onInitComplete();
  }
}
