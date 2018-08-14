part of acanvas_template;

/**
 * @author Nils Doehring (nilsdoehring(gmail as at).com)
 */
class NavigationSidebar extends AcanvasLifecycleSprite
    implements IStateModelAware {
  StateModel _stateModel;
  ImageSprite _logo;
  MdMenu _itemList;
  MdMenu _subList;
  bool _blockSelectionByAddressCallback = false;

  SelectableButton _selectedCell;

  NavigationSidebar(String id) : super(id) {
    inheritSpan = true;
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _logo = new ImageSprite()
      ..bitmapData = Assets.acanvas_logotype_white
      ..inheritSpan = false
      ..autoSpan = false
      ..useHandCursor = true
      ..addEventListener(Ac.TOUCH ? TouchEvent.TOUCH_END : MouseEvent.MOUSE_UP,
          (e) {
        new AcSignal(StateEvents.ADDRESS_SET,
                getProperty("${ScreenIDs.HOME}.url", true))
            .dispatch();
      });
    addChild(_logo);

    _itemList = _createList(
        _stateModel.getStateVOList(true, 0), _sideBarCellSelectAction);
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

    AcGraphics.rectangle(0, 0, spanWidth, spanHeight,
        sprite: this, color: Colors.GREY_DARK);

    _logo.y = 0;
    _logo.x = 0;
    _logo.scaleToHeight(MdDimensions.HEIGHT_APP_BAR);

    _itemList.y = MdDimensions.HEIGHT_APP_BAR + Dimensions.SPACER;
    _itemList.span(spanWidth, spanHeight - _itemList.y);

    _subList?.y = MdDimensions.HEIGHT_APP_BAR + Dimensions.SPACER;
    _subList?.span(spanWidth, spanHeight - _itemList.y);
  }

  _sideBarCellSelectAction(SelectableButton cell) {
    _selectedCell = cell;
    StateVO vo = cell.data;
    _blockSelectionByAddressCallback = true;

    new AcSignal(StateEvents.ADDRESS_SET, vo.url).dispatch();
  }

  void setVO(StateVO vo) {
    //  if (!_blockSelectionByAddressCallback) {
    // _itemList.selectCellByVO(vo);
    _subList?.selectCellByVO(vo);
    //}
    _blockSelectionByAddressCallback = false;

/*    if(_itemList.visible){
      //todo itemList animate left

      var children = _stateModel.getStateVOList(true, vo.tree_order);
      if(children.length > 0){
        //todo scroll _itemList cell to top, then flyout
        _subList.dispose();
        _subList = _createList(_stateModel.getStateVOList(true, 0), _sideBarCellSelectAction);
        addChild(_subList);
      }
    }*/
  }

  @override
  void set stateModel(StateModel stateModel) {
    _stateModel = stateModel;
  }

  MdMenu _createList(List<StateVO> stateVOList,
      Function(SelectableButton cell) cellSelectAction) {
    var itemList = new MdMenu(stateVOList,
        cell: new ListMenuCell(),
        shadow: false,
        backgroundColor: Colors.GREY_DARK);
    itemList.submitCallback = cellSelectAction;
    return itemList;
  }

  void openSubmenu(List<StateVO> subPageList) {
    //TODO create submenu, animate out rootmenu
    _itemList.visible = false;
    //todo scroll _itemList cell to top, then flyout
    _subList?.dispose();
    _subList = _createList(subPageList, _sideBarCellSelectAction);
    addChild(_subList);
    _subList.init();
    refresh();
  }

  void closeSubmenu() {
    //TODO destroy submenu, animate rootmenu
    _subList?.dispose();
    _itemList.visible = true;
  }
}
