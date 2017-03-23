part of bitmapfont_example;

class BitmapFontHome extends AbstractReflowScreen {
  BitmapFontHome(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);
    reflow.flow.flowOrientation = FlowOrientation.VERTICAL;
    reflow.flow.reflow = false;

    MdText copy = Theme.getCopy(getProperty("copy1"), size: 16);
    reflow.addChild(copy);

    for(int i=1; i<5; i++){
      MdText headline = Theme.getHeadline(getProperty("tool${i}.name"), size: 24);
      reflow.addChild(headline);

      copy = Theme.getCopy(getProperty("tool${i}.url"), size: 16);
      copy.addEventListener(Rd.MOBILE ? TouchEvent.TOUCH_BEGIN : MouseEvent.CLICK, (e){
        new RdSignal(StateEvents.ADDRESS_SET, copy.text).dispatch();
      });
      reflow.addChild(copy);
    }

    addChild(reflow);

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    reflow.span(spanWidth - 2*padding, spanHeight - padding);
  }

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }

  void _onLink(InputEvent event) {
    String url = (event.currentTarget as MdText).text;
    html.window.open(url, "_blank");
  }
}
