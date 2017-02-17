part of material_example;

class MdCheckboxes extends AbstractReflowScreen {
  MdCheckboxes(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    MdWrap wrap01 = Theme.getWrap(label: getProperty("col01"));
    wrap01.addChild(new MdCheckbox(
        label: getProperty("checkbox01"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)..selected = false);
    wrap01.addChild(new MdCheckbox(
        label: getProperty("checkbox02"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)..selected = false);
    wrap01.addChild(new MdCheckbox(
        label: getProperty("checkbox03"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)..selected = false);
    wrap01.addChild(new MdCheckbox(
        label: getProperty("checkbox04"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)..selected = false);
    wrap01.addChild(new MdCheckbox(
        label: getProperty("checkbox05"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)..selected = true);
    wrap01.span(230, 480);

    MdWrap wrap02 = Theme.getWrap(label: getProperty("col02"));
    wrap02.addChild(new MdCheckbox(
        label: getProperty("checkbox01"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)
      ..selected = false
      ..disable());
    wrap02.addChild(new MdCheckbox(
        label: getProperty("checkbox02"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)
      ..selected = false
      ..disable());
    wrap02.addChild(new MdCheckbox(
        label: getProperty("checkbox03"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)
      ..selected = true
      ..disable());
    wrap02.addChild(new MdCheckbox(
        label: getProperty("checkbox04"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)
      ..selected = false
      ..disable());
    wrap02.addChild(new MdCheckbox(
        label: getProperty("checkbox05"),
        boxColor: MdColor.BLACK,
        activeColor: Theme.COLOR_BASE,
        rippleColor: MdColor.GREY_DARK)
      ..selected = false
      ..disable());
    wrap02.span(230, 480);

    MdWrap wrap03 = Theme.getWrap(label: getProperty("col03"));
    wrap03.addChild(new MdCheckbox(
        label: getProperty("checkbox01"),
        boxColor: Theme.COLOR_BASE,
        activeColor: Theme.COLOR_BASE,
        rippleColor: Theme.COLOR_BASE)..selected = true);
    wrap03.addChild(new MdCheckbox(
        label: getProperty("checkbox02"),
        boxColor: Colors.RED,
        activeColor: Colors.RED,
        rippleColor: Colors.RED)..selected = false);
    wrap03.addChild(new MdCheckbox(
        label: getProperty("checkbox03"),
        boxColor: Colors.ORANGE,
        activeColor: Colors.ORANGE,
        rippleColor: Colors.ORANGE)..selected = false);
    wrap03.addChild(new MdCheckbox(
        label: getProperty("checkbox04"),
        boxColor: Colors.GREEN,
        activeColor: Colors.GREEN,
        rippleColor: Colors.GREEN)..selected = false);
    wrap03.addChild(new MdCheckbox(
        label: getProperty("checkbox05"),
        boxColor: Theme.COLOR_BASE,
        activeColor: Theme.COLOR_BASE,
        rippleColor: Theme.COLOR_BASE)..selected = false);
    wrap03.span(230, 480);

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
