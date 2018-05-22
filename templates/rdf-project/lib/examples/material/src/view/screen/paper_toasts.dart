part of material_example;

class MdToasts extends AbstractReflowScreen {
  MdToasts(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    MdWrap wrap01 = Theme.getWrap(label: getProperty("col01"));

    RadioGroup radioGroupV = new RadioGroup(spacing: 5.0);
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio01"), activeColor: Colors.RED));
    radioGroupV.addChild(new MdRadioButton(label: getProperty("radio02")));
    radioGroupV.addChild(new MdRadioButton(
        label: getProperty("radio03"), activeColor: Theme.COLOR_TRIAD_BLUE));
    radioGroupV.addEventListener(
        RadioGroupEvent.BUTTON_SELECTED, _onRadioButtonSelected);
    wrap01.addChild(radioGroupV);
    wrap01.span(220, 340);

    MdWrap wrap02 =
        Theme.getWrap(label: getProperty("col02"), align: AlignH.CENTER);
    String toast_id = "message_01";

    MdButton button01 = new MdButton(getProperty("button01"),
        fontColor: MdColor.WHITE,
        bgColor: Colors.PINK,
        icon: MdIcon.white(MdIconSet.done));
    button01.submitEvent = new RdSignal(
        StateEvents.MESSAGE_SHOW,
        new StateMessageVO(toast_id, getProperty("toast03"), 0,
            type: StateMessageVO.TYPE_INFO));
    wrap02.addChild(button01);

    MdButton button02 = new MdButton(getProperty("button02"),
        fontColor: Colors.PINK,
        bgColor: MdColor.TRANSPARENT,
        shadow: false,
        icon: MdIcon.color(MdIconSet.cancel, Colors.PINK));
    button02.submitEvent = new RdSignal(StateEvents.MESSAGE_HIDE, toast_id);
    wrap02.addChild(button02);

    wrap02.span(220, 340);

    reflow.addChild(wrap01);
    reflow.addChild(wrap02);

    addChild(reflow);

    onInitComplete();
  }

  void _onRadioButtonSelected(RadioGroupEvent event) {
    switch (event.index) {
      case 0:
        new MdToast(getProperty("toast01"), stage,
            fontColor: MdColor.WHITE, bgColor: Colors.RED);
        break;
      case 2:
        new MdToast(getProperty("toast02"), stage,
            fontColor: MdColor.WHITE,
            bgColor: Theme.COLOR_TRIAD_BLUE,
            position: MdToast.BR);
        break;
    }
  }
}
