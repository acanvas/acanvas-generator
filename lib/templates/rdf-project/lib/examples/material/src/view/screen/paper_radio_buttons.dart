part of material_example;

class MdRadioButtons extends AbstractReflowScreen {
  MdRadioButtons(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    MdWrap wrap01 = Theme.getWrap(label: getProperty("col01"));
    RadioGroup radioGroupV = new RadioGroup(spacing: 10.0);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio01"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK)
      ..selected = true);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio02"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK));
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio03"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK));
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio04"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK));
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio05"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK));
    radioGroupV.inheritSpan = true;
    wrap01.addChild(radioGroupV);
    wrap01.span(250, 470);

    MdWrap wrap02 = Theme.getWrap(label: getProperty("col02"));
    radioGroupV = new RadioGroup(spacing: 10.0);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio01"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK)
      ..selected = false);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio02"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK)
      ..selected = false);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio03"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK)
      ..selected = true);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio04"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK)
      ..selected = true);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio05"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: MdColor.GREY_DARK)
      ..selected = true);
    wrap02.addChild(radioGroupV);
    wrap02.span(250, 470);

    MdWrap wrap03 = Theme.getWrap(label: getProperty("col03"));
    radioGroupV = new RadioGroup(spacing: 10.0);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio01"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: Theme.EXAMPLES_HIGHLIGHT_MAIN)
      ..selected = true);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio02"),
        activeColor: Colors.RED,
        rippleColor: Colors.RED)
      ..selected = true);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio03"),
        activeColor: Colors.ORANGE,
        rippleColor: Colors.ORANGE)
      ..selected = true);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio04"),
        activeColor: Colors.GREEN,
        rippleColor: Colors.GREEN)
      ..selected = true);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio05"),
        activeColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        rippleColor: Theme.EXAMPLES_HIGHLIGHT_MAIN)
      ..selected = true);
    wrap03.addChild(radioGroupV);
    wrap03.span(250, 470);

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
