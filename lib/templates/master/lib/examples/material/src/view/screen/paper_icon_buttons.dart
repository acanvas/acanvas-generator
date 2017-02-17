part of material_example;

@retain
class MdIconButtons extends AbstractReflowScreen {
  MdIconButtons(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    MdWrap wrap01 = Theme.getWrap(label: getProperty("col01"), align: AlignH.CENTER);
    wrap01.addChild(new MdIconButton(MdIcon.black(MdIconSet.menu), rippleColor: MdColor.GREY_DARK));
    wrap01.addChild(new MdIconButton(MdIcon.black(MdIconSet.favorite), rippleColor: MdColor.GREY_DARK));
    wrap01.addChild(new MdIconButton(MdIcon.black(MdIconSet.arrow_back), rippleColor: MdColor.GREY_DARK));
    wrap01.addChild(new MdIconButton(MdIcon.black(MdIconSet.arrow_forward), rippleColor: MdColor.GREY_DARK));
    wrap01.addChild(new MdIconButton(MdIcon.black(MdIconSet.close), rippleColor: MdColor.GREY_DARK));
    wrap01.addChild(new MdIconButton(MdIcon.black(MdIconSet.polymer), rippleColor: MdColor.GREY_DARK));
    wrap01.span(250, 470);

    MdWrap wrap02 = Theme.getWrap(label: getProperty("col02"), align: AlignH.CENTER);
    wrap02.addChild(new MdIconButton(MdIcon.black(MdIconSet.menu), rippleColor: MdColor.GREY_DARK)..disable());
    wrap02.addChild(new MdIconButton(MdIcon.black(MdIconSet.favorite), rippleColor: MdColor.GREY_DARK)..disable());
    wrap02.addChild(new MdIconButton(MdIcon.black(MdIconSet.arrow_back), rippleColor: MdColor.GREY_DARK)..disable());
    wrap02.addChild(new MdIconButton(MdIcon.black(MdIconSet.arrow_forward), rippleColor: MdColor.GREY_DARK)..disable());
    wrap02.addChild(new MdIconButton(MdIcon.black(MdIconSet.close), rippleColor: MdColor.GREY_DARK)..disable());
    wrap02.addChild(new MdIconButton(MdIcon.black(MdIconSet.polymer), rippleColor: MdColor.GREY_DARK)..disable());
    wrap02.span(250, 470);

    MdWrap wrap03 = Theme.getWrap(label: getProperty("col03"), align: AlignH.CENTER);
    wrap03.addChild(new MdIconButton(MdIcon.color(MdIconSet.menu, Theme.COLOR_BASE), rippleColor: MdColor.GREY_DARK));
    wrap03.addChild(new MdIconButton(MdIcon.color(MdIconSet.favorite, Colors.RED), rippleColor: MdColor.GREY_DARK));
    wrap03
        .addChild(new MdIconButton(MdIcon.color(MdIconSet.arrow_back, Colors.ORANGE), rippleColor: MdColor.GREY_DARK));
    wrap03.addChild(
        new MdIconButton(MdIcon.color(MdIconSet.arrow_forward, Colors.GREEN), rippleColor: MdColor.GREY_DARK));
    wrap03.addChild(new MdIconButton(MdIcon.color(MdIconSet.close, Theme.COLOR_BASE), rippleColor: MdColor.GREY_DARK));
    wrap03.addChild(new MdIconButton(MdIcon.color(MdIconSet.polymer, Colors.RED), rippleColor: MdColor.GREY_DARK));
    wrap03.span(250, 470);

    reflow.addChild(wrap01);
    reflow.addChild(wrap02);
    reflow.addChild(wrap03);

    addChild(reflow);

    wrap02.children.where((c) => c is BehaveSprite).forEach((child) {
      (child as BehaveSprite).enabled = false;
    });

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
