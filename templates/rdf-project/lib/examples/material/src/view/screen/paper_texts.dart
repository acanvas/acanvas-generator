part of material_example;

class MdTexts extends AbstractReflowScreen {
  MdTexts(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    reflow.flow.reflow = false;
    reflow.flow.flowOrientation = FlowOrientation.VERTICAL;

    if (Rd.MOBILE) {
      reflow.addChild(Theme.getHeadline(getProperty("mobile.note1"), size: 24));
      reflow.addChild(Theme.getCopy(getProperty("mobile.note2"), size: 16));
    }

    MdWrap wrap01 = Theme.getWrap(label: getProperty("wrap01"));
    wrap01.addChild(new MdInput(getProperty("input01"),
        keyboard: Rd.MOBILE, floating: true));
    wrap01.addChild(new MdInput(getProperty("input02"),
        keyboard: Rd.MOBILE, floating: true, password: true));
    wrap01.addChild(new MdInput(getProperty("input03"),
        keyboard: Rd.MOBILE, floating: false));
    wrap01.addChild(new MdInput(getProperty("input04"),
        keyboard: Rd.MOBILE, floating: true));
    wrap01.span(spanWidth - 4 * padding, 300);

    MdWrap wrap02 = Theme.getWrap(label: getProperty("wrap02"));
    wrap02.addChild(new MdInput(getProperty("input05"),
        keyboard: Rd.MOBILE, floating: true, multiline: true, rows: 5));
    wrap02.span(spanWidth - 4 * padding, 260);

    MdWrap wrap03 = Theme.getWrap(label: getProperty("wrap03"));
    wrap03.addChild(new MdInput(getProperty("input06"),
        required: getProperty("input06.required"),
        keyboard: Rd.MOBILE,
        floating: true));
    wrap03.addChild(new MdInput(getProperty("input06"),
        required: getProperty("input06.required"),
        keyboard: Rd.MOBILE,
        floating: true));
    wrap03.span(spanWidth - 4 * padding, 240);

    reflow.addChild(wrap01);
    reflow.addChild(wrap02);
    reflow.addChild(wrap03);

    addChild(reflow);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    //refresh logic - use spanWidth and spanHeight
  }

  @override
  void dispose({bool removeSelf: true}) {
    super.dispose();

    //additional cleanup logic
  }
}
