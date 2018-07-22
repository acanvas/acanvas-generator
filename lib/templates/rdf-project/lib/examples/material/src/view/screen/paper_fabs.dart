part of material_example;

class MdFabs extends AbstractReflowScreen {
  MdFabs(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    MdWrap wrap01 =
        Theme.getWrap(label: getProperty("col01"), align: AlignH.CENTER);
    wrap01.addChild(new MdFab(MdIcon.white(MdIconSet.arrow_forward),
        bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN));
    wrap01.addChild(
        new MdFab(MdIcon.white(MdIconSet.create), bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN));
    wrap01.addChild(
        new MdFab(MdIcon.white(MdIconSet.favorite), bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN));
    wrap01.addChild(new MdFab(MdIcon.white(MdIconSet.done),
        bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN, radius: 20));
    wrap01.addChild(new MdFab(MdIcon.white(MdIconSet.reply),
        bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN, radius: 20));
    wrap01.span(250, 480);

    MdWrap wrap02 =
        Theme.getWrap(label: getProperty("col02"), align: AlignH.CENTER);
    wrap02
        .addChild(new MdFab(MdIcon.black(MdIconSet.arrow_forward))..disable());
    wrap02.addChild(new MdFab(MdIcon.black(MdIconSet.create))..disable());
    wrap02.addChild(new MdFab(MdIcon.black(MdIconSet.favorite))..disable());
    wrap02.addChild(
        new MdFab(MdIcon.black(MdIconSet.done), shadow: false, radius: 20)
          ..disable());
    wrap02.addChild(
        new MdFab(MdIcon.black(MdIconSet.reply), shadow: false, radius: 20)
          ..disable());
    wrap02.span(250, 480);

    MdWrap wrap03 =
        Theme.getWrap(label: getProperty("col03"), align: AlignH.CENTER);
    wrap03.addChild(new MdFab(MdIcon.white(MdIconSet.arrow_forward),
        bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN));
    wrap03.addChild(
        new MdFab(MdIcon.white(MdIconSet.create), bgColor: Colors.RED));
    wrap03.addChild(
        new MdFab(MdIcon.black(MdIconSet.favorite), bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN));
    wrap03.addChild(new MdFab(MdIcon.white(MdIconSet.done),
        bgColor: Colors.GREEN, radius: 20));
    wrap03.addChild(new MdFab(MdIcon.color(MdIconSet.reply, Colors.PINK),
        bgColor: Theme.EXAMPLES_HIGHLIGHT_MAIN, radius: 20));
    wrap03.span(250, 480);

    reflow.addChild(wrap01);
    reflow.addChild(wrap02);
    reflow.addChild(wrap03);

    addChild(reflow);

    wrap02.children.where((c) => c is BehaveSprite).forEach((child) {
      (child as BehaveSprite).enabled = false;
    });

    onInitComplete();
  }
}
