part of material_example;

class MdToggles extends AbstractReflowScreen {
  MdToggles(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    /*
       * Radio Button Group
       */

    MdWrap wrap01 = Theme.getWrap(label: getProperty("col01"));
    wrap01.addChild(new MdToggleButton(
        label: getProperty("button01"), activeColor: Theme.COLOR_BASE, rippleColor: Theme.COLOR_BASE));
    wrap01.addChild(new MdToggleButton(label: getProperty("button02"), activeColor: Colors.RED, rippleColor: Colors.RED)
      ..selected = true);
    wrap01.addChild(new MdToggleButton(
        label: getProperty("button03"), activeColor: Theme.COLOR_BASE, rippleColor: Theme.COLOR_BASE));
    wrap01.addChild(
        new MdToggleButton(label: getProperty("button04"), activeColor: Colors.GREEN, rippleColor: Colors.GREEN));
    wrap01.addChild(
        new MdToggleButton(label: getProperty("button05"), activeColor: Colors.PINK, rippleColor: Colors.PINK));
    wrap01.span(310, 470);

    MdWrap wrap02 = Theme.getWrap(label: getProperty("col02"));
    wrap02.addChild(new MdToggleButton(label: getProperty("button01"))..disable());
    wrap02.addChild(new MdToggleButton(label: getProperty("button02"))..disable());
    wrap02.addChild(new MdToggleButton(label: getProperty("button03"))..disable());
    wrap02.addChild(new MdToggleButton(label: getProperty("button04"))..disable());
    wrap02.addChild(new MdToggleButton(label: getProperty("button05"))..disable());
    wrap02.span(310, 470);

    reflow.addChild(wrap01);
    reflow.addChild(wrap02);

    addChild(reflow);

    wrap02.flow.children.where((c) => c is BehaveSprite).forEach((child) {
      (child as BehaveSprite).enabled = false;
    });

    addChild(reflow);
    onInitComplete();
  }
}
