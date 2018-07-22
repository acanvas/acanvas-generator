part of material_example;

class MdButtons extends AbstractReflowScreen {
  MdButtons(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    MdWrap wrap01 =
        Theme.getWrap(label: getProperty("col01"), align: AlignH.CENTER);
    wrap01.addChild(new MdButton(getProperty("button01"),
        fontColor: Colors.BLACK, shadow: false, bgColor: MdColor.TRANSPARENT));
    wrap01.addChild(new MdButton(getProperty("button02"),
        fontColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        shadow: false,
        bgColor: MdColor.TRANSPARENT));
    wrap01.addChild(new MdButton(getProperty("button03"),
        fontColor: Colors.GREY_LIGHT,
        shadow: false,
        ripple: false,
        bgColor: Colors.GREY_MIDDLE));
    wrap01.addChild(new MdButton(getProperty("button04"),
        fontColor: Colors.BLACK,
        shadow: false,
        ripple: false,
        bgColor: MdColor.TRANSPARENT));
    wrap01.addChild(new MdButton(getProperty("button05"),
        fontColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        shadow: false,
        bgColor: MdColor.TRANSPARENT,
        icon: MdIcon.color(MdIconSet.done, Theme.EXAMPLES_HIGHLIGHT_MAIN)));
    wrap01.addChild(new MdButton(getProperty("button06"),
        fontColor: Colors.BLACK,
        shadow: false,
        bgColor: MdColor.TRANSPARENT,
        icon: MdIcon.black(MdIconSet.close)));
    wrap01.span(180, 450);

    MdWrap wrap02 =
        Theme.getWrap(label: getProperty("col02"), align: AlignH.CENTER);
    wrap02.addChild(new MdButton(getProperty("button01"),
        fontColor: Colors.BLACK, shadow: true, bgColor: MdColor.WHITE));
    wrap02.addChild(new MdButton(getProperty("button02"),
        fontColor: Colors.WHITE, shadow: true, bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN));
    wrap02.addChild(new MdButton(getProperty("button03"),
        fontColor: Colors.GREY_LIGHT,
        shadow: false,
        ripple: false,
        bgColor: Colors.GREY_MIDDLE));
    wrap02.addChild(new MdButton(getProperty("button04"),
        fontColor: Colors.BLACK,
        shadow: true,
        ripple: false,
        bgColor: MdColor.WHITE));
    wrap02.addChild(new MdButton(getProperty("button05"),
        fontColor: Colors.WHITE,
        shadow: true,
        bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        icon: MdIcon.color(MdIconSet.done, Colors.WHITE)));
    wrap02.addChild(new MdButton(getProperty("button06"),
        fontColor: Colors.BLACK,
        shadow: true,
        bgColor: MdColor.WHITE,
        icon: MdIcon.black(MdIconSet.close)));
    wrap02.span(180, 450);

    MdWrap wrap03 =
        Theme.getWrap(label: getProperty("col03"), align: AlignH.CENTER);
    wrap03.addChild(new MdButton(getProperty("button01"),
        fontColor: Colors.BLACK, shadow: false, bgColor: MdColor.TRANSPARENT)
      ..selfSelect = true);
    wrap03.addChild(new MdButton(getProperty("button04"),
        fontColor: Colors.BLACK, shadow: true, bgColor: MdColor.WHITE)
      ..selfSelect = true);
    wrap03.addChild(new MdButton(getProperty("button02"),
        fontColor: Theme.EXAMPLES_HEADLINE_COLOR,
        shadow: false,
        ripple: false,
        bgColor: Colors.AC_PINK)
      ..selfSelect = true);
    wrap03.addChild(new MdButton(getProperty("button02"),
        fontColor: Colors.WHITE, shadow: true, bgColor: Colors.AC_CYAN)
      ..selfSelect = true);
    wrap03.addChild(new MdButton(getProperty("button05"),
        fontColor: Theme.EXAMPLES_HIGHLIGHT_MAIN,
        shadow: false,
        bgColor: MdColor.TRANSPARENT,
        icon: MdIcon.color(MdIconSet.done, Theme.EXAMPLES_HIGHLIGHT_MAIN))
      ..selfSelect = true);
    wrap03.addChild(new MdButton(getProperty("button06"),
        fontColor: Colors.BLACK,
        shadow: false,
        bgColor: MdColor.TRANSPARENT,
        icon: MdIcon.black(MdIconSet.close))
      ..selfSelect = true);
    wrap03.span(180, 450);

    MdWrap wrap04 =
        Theme.getWrap(label: getProperty("col04"), align: AlignH.CENTER);
    wrap04.addChild(new MdButton(getProperty("button01"))..disable());
    wrap04.addChild(new MdButton(getProperty("button02"))..disable());
    wrap04.addChild(new MdButton(getProperty("button03"))..disable());
    wrap04.addChild(new MdButton(getProperty("button04"))..disable());
    wrap04.addChild(new MdButton(getProperty("button05"))..disable());
    wrap04.addChild(new MdButton(getProperty("button06"))..disable());
    wrap04.span(180, 450);

    reflow.addChild(wrap01);
    reflow.addChild(wrap02);
    reflow.addChild(wrap03);
    reflow.addChild(wrap04);

    addChild(reflow);

    onInitComplete();
  }
}
