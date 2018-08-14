part of acanvas_template;

/// The AbstractScreen class contains settings applicable to all screens of an application.

class AbstractReflowScreen extends AbstractScreen implements IModelAware {
  static const int PADDING = 32;

  /// AppModel as defined by interface. Will be injected by ApplicationContext/factory
  Model model;

  @override
  void set appModel(Model model) {
    model = model;
  }

  Wrap reflow;
  MdText _headline;
  MdText _copy;

  AbstractReflowScreen(String id) : super(id) {}

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    reflow = new Wrap(
        spacing: 32,
        scrollOrientation: ScrollOrientation.VERTICAL,
        enableMask: false)
      ..padding = PADDING
      ..inheritSpan = false
      ..autoRefresh = false;

    reflow.addChild(new Sprite()
      ..graphics.rect(0, 0, spanWidth - 10, Dimensions.SPACER)
      ..graphics.fillColor(0x00ff0000));

    _headline = Theme.getHeadline(getProperty("headline"), size: 24);
    reflow.addChild(_headline);

    String copyText = getProperty("copy");
    _copy = Theme.getCopy(copyText, size: 16);
    // _copy.inheritWidth = false;
    reflow.addChild(_copy);

    //In the sub class, do this after the super call when overriding init:
    /*
    super.init()
    ...add more children to reflow
    addChild(reflow);
    onInitComplete();
     */
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    // _headline.width = spanWidth - 2 * padding;
    // _copy.width = spanWidth - 2 * padding;
    reflow
      ..span(spanWidth - 2 * padding, spanHeight)
      ..x = padding
      ..y = padding;
    super.refresh();
  }
}
