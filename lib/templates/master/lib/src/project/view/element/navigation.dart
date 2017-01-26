part of rockdot_template;

/// The top bar. Always there.

class Navigation extends RockdotLifecycleSprite implements IStateModelAware{

  MdAppBar _appBar;
  MdText _headline;
  MdFab _menuButton;
  MdFab _fxButton;
  Sprite _modalBg;
  NavigationSidebar _sidebar;
  bool _sidebarShowingPermanently = false;
  StateModel _stateModel;

  List<StateVO> _subPageList;

  MdFab _fwdButton;

  int _listIndex = 0;


  @override
  void set stateModel(StateModel stateModel) {
    _stateModel = stateModel;
  }

  //----------------------------------------------------------------------------

  Navigation(String id) : super(id) {
    inheritSpan = true;
    inheritInit = true;
  }

  //----------------------------------------------------------------------------

  @override void span(num spanWidth, num spanHeight, {bool refresh: true}){
    super.span(Dimensions.WIDTH_STAGE, Dimensions.HEIGHT_STAGE);
  }

  //----------------------------------------------------------------------------

  @override void init({Map params: null}){
    super.init(params: params);

    _menuButton = new MdFab(MdIcon.white(MdIconSet.menu), bgColor: Theme.COLOR_BASE, radius: 20)
      ..submitCallback = _openMenu
      ..submitCallbackParams = [];


    _headline = Theme.getHeadline("", size: 28, color: Colors.WHITE);
    _headline.inheritWidth = false;

    if(Rd.WEBGL){

    _fxButton = new MdFab(MdIcon.white(MdIconSet.search), bgColor: Colors.BF_BASE_GREEN, radius: 20)
      ..submitCallback = _mousePointerShader
      ..submitCallbackParams = [];
    }

    _fwdButton = new MdFab(MdIcon.white(MdIconSet.forward), bgColor: Colors.BF_BASE_GREEN, radius: 20)
      ..submitCallback = _subNavForward
      ..submitCallbackParams = [];

    _appBar = new MdAppBar(bgColor : Colors.GREY_DARK);
    _appBar.addToTL(_menuButton);
    _appBar.addToTR(_fwdButton);
    _appBar.addToTR(_fxButton);
    _appBar.addHeadline(_headline);
    addChild(_appBar);

    _modalBg = RdGraphics.rectangle(0, 0, spanWidth, spanHeight, color: MdColor.BLACK);
    addChild(_modalBg);

    _sidebar = new NavigationSidebar("sidebar");
    addChild(_sidebar);

    _closeMenu(0.0);
    new RdSignal(StateEvents.STATE_VO_SET, null, _onAddressSet).listen();
    onInitComplete();
  }

  //----------------------------------------------------------------------------

  @override void refresh() {
    super.refresh();

    //----------------------------

    // Manage switch between permanently shown and modal Sidebar

    if(Dimensions.WIDTH_STAGE > Dimensions.WIDTH_TO_SHOW_SIDEBAR){
      _sidebarShowingPermanently = true;
      _menuButton.visible = false;
      _modalBg.visible = false; //just in case
      _sidebar.visible = true; //just in case

      _sidebar.x = 0;
      _appBar.x = _sidebar.spanWidth;
      _appBar.span(Dimensions.WIDTH_STAGE - _sidebar.spanWidth, 10);
    }
    else{

      //reset sidebar directly after switch from permanently shown version

      if(_sidebarShowingPermanently == true) {
        _sidebarShowingPermanently = false;
        _closeMenu(0.0);
      }

      _menuButton.visible = true;
      _appBar.span(spanWidth, 10);
      _appBar.x = 0;
    }

    _modalBg.width = spanWidth;
    _modalBg.height= spanHeight;


  }

  //----------------------------------------------------------------------------

  void _openMenu() {
    _modalBg.addEventListener(TouchEvent.TOUCH_BEGIN, _modalMouseDownAction);
    _modalBg.addEventListener(MouseEvent.CLICK, _modalMouseDownAction);
    Rd.JUGGLER.addTween(_modalBg, .4)
      ..animate.alpha.to(.5);

    _modalBg.visible = true;
    _sidebar.visible = true;
    Rd.JUGGLER.addTween(_sidebar, .2, Transition.easeOutQuintic)
      ..animate.x.to(0);
  }

  //----------------------------------------------------------------------------

  void _subNavForward() {

    if(_subPageList == null){
      return;
    }

    StateVO vo = _subPageList.elementAt(_listIndex);
    _listIndex++;

    if(_listIndex == _subPageList.length){
      _listIndex = 0;
    }

    new RdSignal(StateEvents.ADDRESS_SET, vo.url).dispatch();

  }

  //----------------------------------------------------------------------------

  void _closeMenu([double duration = .1]) {

    _modalBg.alpha = 0;
    _modalBg.visible = false;

    if(duration > 0){
      Rd.JUGGLER.addTween(_sidebar, duration, Transition.easeInQuintic)
        ..animate.x.to(- _sidebar.spanWidth)
        ..onComplete = () => _sidebar.visible = false;
    }
    else{
      _sidebar.x = - _sidebar.spanWidth;
    }
  }

  //----------------------------------------------------------------------------

  void _modalMouseDownAction(event) {
    _modalBg.removeEventListener(TouchEvent.TOUCH_BEGIN, _modalMouseDownAction);
    _modalBg.removeEventListener(MouseEvent.CLICK, _modalMouseDownAction);
    _closeMenu();
  }

  //----------------------------------------------------------------------------

  void _onAddressSet(RdSignal e) {
    if(_sidebarShowingPermanently == false) {
      _closeMenu();
    }

    StateVO vo = e.data;
    
    //if current page is on first level below home
    if(vo.tree_parent == 0){
      //get list of child pages
      _subPageList = _stateModel.getStateVOList(true, vo.tree_order);

    }
    //if current page is second level (i.e. a subpage below a subpage below home)
    else if(vo.tree_parent > 0){
      //if this subpage is the first ever loaded, get list of its siblings
      if(_subPageList == null){
        _subPageList = _stateModel.getStateVOList(true, vo.tree_parent);
        //set index of list accordingly
        _listIndex = _subPageList.indexOf(_subPageList.firstWhere((v) => v.tree_order == vo.tree_order));
      }
    }
    //if current page is the home page
    else if(vo.tree_parent == -1){
      //reset
      _subPageList = null;
    }

    // if no subpages
    if(_subPageList == null || _subPageList.length == 0){
      _fwdButton.visible = false;
      _listIndex = 0;
    }
    else{
      _fwdButton.visible = true;
    }

    //send vo to sidebar so we can highlight the current url's button (if applicable)
    _sidebar.setVO(vo);

    //if page is a layer
    if (vo.url.indexOf("layer") == -1) {
      //title animation
      int leHeight = (MdDimensions.HEIGHT_APP_BAR / 2 - _headline.textHeight / 2).round();
      Rd.JUGGLER.addTween(_headline, .1, Transition.easeInQuintic)
      ..animate.y.to(leHeight - 15)
      ..animate.alpha.to(0)
      ..onComplete = () {

          _headline.text = vo.title;
          _headline.y = leHeight + 15;

          Tween tw = Rd.JUGGLER.addTween(_headline, .2, Transition.easeOutQuintic);
          tw.animate.y.to(leHeight);
          tw.animate.alpha.to(1);
      };
    }
  }

  //----------------------------------------------------------------------------

  _mousePointerShader(){

    if(Rd.STAGE.filters.length > 0){
      Rd.STAGE.filters = [];
      Rd.MATERIALIZE_REQUIRED = false;
      return;
    }

    BitmapData bitmapData = Assets.displacement_bubble;

    var matrix = new Matrix.fromIdentity();
    matrix.scale(1.2, 1.2);

    DisplacementMapFilter filter = new DisplacementMapFilter(bitmapData, matrix, 100, 100);

    Rd.STAGE.filters = [ filter ];
    if(Rd.MOBILE){
      Rd.STAGE.addEventListener(TouchEvent.TOUCH_MOVE, (TouchEvent e){
        filter.matrix.tx = e.stageX - 285;
        filter.matrix.ty = e.stageY - 185;
      });
    }
    else{
      Rd.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, (MouseEvent e){
        filter.matrix.tx = e.stageX - 285;
        filter.matrix.ty = e.stageY - 185;
      });

    }

    Rd.MATERIALIZE_REQUIRED = true;
  }


}

