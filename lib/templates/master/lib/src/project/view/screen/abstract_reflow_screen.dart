part of rockdot_template;

/// The AbstractScreen class contains settings applicable to all screens of an application.

class AbstractReflowScreen extends AbstractScreen implements IModelAware {
  //----------------------------------------------------------------------------

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

    reflow = new Wrap(spacing: 16, scrollOrientation: ScrollOrientation.VERTICAL, enableMask: false)
      ..x = padding
      ..y = padding
      ..inheritSpan = false
      ..autoRefresh = false;

    _headline = Theme.getHeadline(getProperty("headline"), size: 24);
    _headline.inheritWidth = false;
    reflow.addChild(_headline);

    String copyText = getProperty("copy");
    _copy = Theme.getCopy(copyText, size: 16);
    _copy.inheritWidth = false;
    reflow.addChild(_copy);

    reflow.addChild(new Sprite()
      ..graphics.rect(0, 0, spanWidth - 10, Dimensions.SPACER)
      ..graphics.fillColor(0x00ff0000));

    //In the implementing class, do:
    /*
    addChild(reflow);
    onInitComplete();
     */
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    _headline.width = spanWidth - 2 * padding;
    _copy.width = spanWidth - 2 * padding;
    reflow.span(spanWidth - padding, spanHeight - padding);
    super.refresh();
  }
}
