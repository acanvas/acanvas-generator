part of ugc_example;

/**
 * @author nilsdoehring
 */
class UGCView extends UGCAbstractLayer {
  ImageSprite _pic;

  UGCView(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _reflow.addChild(Theme.getHeadline(getProperty("headline")));

    _pic = new ImageSprite()
      ..href = getProperty("project.host.download", true) +
          "/" +
          (_ugcModel.currentItemDAO.type_dao as UGCImageItemDTO).url_big
      ..addEventListener(Event.COMPLETE, _onImageLoadComplete);
    _reflow.addChild(_pic);

    _reflow.addChild(new MdButton(getProperty("button.close"),
        preset: MdButton.PRESET_GREEN, shadow: false)
      ..submitEvent = new AcSignal(StateEvents.STATE_VO_BACK)
      ..inheritSpan = false);

    onInitComplete();
  }

  void _onImageLoadComplete(Event event) {
    _pic.removeEventListener(Event.COMPLETE, _onImageLoadComplete);
    refresh();
  }

  @override
  void refresh() {
    int imageWH = _reflow.spanWidth;
    _pic.span(imageWH, imageWH, refresh: false);

    super.refresh();
  }
}
