part of rockdot_template;

/**
 * @author Nils Doehring (nilsdoehring(gmail as at).com)
 */
class NavigationSidebar extends RockdotLifecycleSprite implements IStateModelAware {
  StateModel _stateModel;
  ImageSprite _logo;
  MdMenu _itemList;
  bool _blockSelectionByAddressCallback = false;

  NavigationSidebar(String id) : super(id) {
    inheritSpan = true;
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _logo = new ImageSprite()
      ..bitmapData = Assets.logo_rockdot_small
      ..inheritSpan = false
      ..autoSpan = false
      ..useHandCursor = true
      ..addEventListener(Rd.TOUCH ? TouchEvent.TOUCH_END : MouseEvent.MOUSE_UP, (e) {
        new RdSignal(StateEvents.ADDRESS_SET, getProperty("${ScreenIDs.HOME}.url", true)).dispatch();
      });
    addChild(_logo);

    _itemList = new MdMenu(_stateModel.getStateVOList(),
        cell: new ListMenuCell(), shadow: false, backgroundColor: Colors.GREY_DARK);
    _itemList.submitCallback = _sideBarCellSelectAction;
    addChild(_itemList);

    onInitComplete();
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(Dimensions.WIDTH_SIDEBAR, spanHeight);
  }

  @override
  void refresh() {
    super.refresh();

    RdGraphics.rectangle(0, 0, spanWidth, spanHeight, sprite: this, color: Colors.GREY_DARK);

    _logo.y = 0;
    _logo.x = 0;
    _logo.scaleToHeight(MdDimensions.HEIGHT_APP_BAR);

    _itemList.y = MdDimensions.HEIGHT_APP_BAR + Dimensions.SPACER;
    _itemList.span(spanWidth, spanHeight - _itemList.y);
  }

  _sideBarCellSelectAction(SelectableButton cell) {
    StateVO vo = cell.data;
    _blockSelectionByAddressCallback = true;
    new RdSignal(StateEvents.ADDRESS_SET, vo.url).dispatch();
  }

  void setVO(StateVO vo) {
    if (!_blockSelectionByAddressCallback) {
      _itemList.selectCellByVO(vo);
    }
    _blockSelectionByAddressCallback = false;
  }

  @override
  void set stateModel(StateModel stateModel) {
    _stateModel = stateModel;
  }
}
