part of acanvas_template;

/// The top bar. Always there.

class Navigation extends AcanvasLifecycleSprite implements IStateModelAware {
  MdAppBar _appBar;
  MdText _headline;
  MdFab _menuButton;
  MdFab _fxButton;
  Sprite _modalBg;
  NavigationSidebar _sidebar;
  bool _sidebarShowingPermanently = false;
  StateModel _stateModel;

  List<StateVO> _subPageList;

  @override
  void set stateModel(StateModel stateModel) {
    _stateModel = stateModel;
  }

  Navigation(String id) : super(id) {
    inheritSpan = true;
    inheritInit = true;
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(Dimensions.WIDTH_STAGE, Dimensions.HEIGHT_STAGE);
  }

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _appBar = new MdAppBar(bgColor: Colors.GREY_DARK);

    _menuButton = new MdFab(MdIcon.white(MdIconSet.menu),
        bgColor: Theme.TOP_BAR_BG, radius: 20)
      ..submitCallback = _openMenu
      ..submitCallbackParams = [];
    _appBar.addToTL(_menuButton);

    _headline = Theme.getHeadline("", size: 28, color: Colors.WHITE);
    _headline.inheritWidth = false;
    _appBar.addHeadline(_headline);

    if (Ac.WEBGL) {
      _fxButton = new MdFab(MdIcon.white(MdIconSet.search),
          bgColor: Theme.TOP_BAR_BG, radius: 20)
        ..submitCallback = _mousePointerShader
        ..submitCallbackParams = [];
      _appBar.addToTR(_fxButton);
    }

    addChild(_appBar);

    _modalBg =
        AcGraphics.rectangle(0, 0, spanWidth, spanHeight, color: MdColor.BLACK);
    addChild(_modalBg);

    _sidebar = new NavigationSidebar("sidebar");
    addChild(_sidebar);

    _closeMenu(0.0);
    new AcSignal(StateEvents.STATE_VO_SET, null, _onAddressSet).listen();
    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    //----------------------------

    // Manage switch between permanently shown and modal Sidebar

    if (Dimensions.WIDTH_STAGE > Dimensions.WIDTH_TO_SHOW_SIDEBAR) {
      _sidebarShowingPermanently = true;
      _menuButton.visible = false;
      _modalBg.visible = false; //just in case
      _sidebar.visible = true; //just in case

      _sidebar.x = 0;
      _appBar.x = _sidebar.spanWidth;
      _appBar.span(Dimensions.WIDTH_STAGE - _sidebar.spanWidth, 10);
    } else {
      //reset sidebar directly after switch from permanently shown version

      if (_sidebarShowingPermanently == true) {
        _sidebarShowingPermanently = false;
        _closeMenu(0.0);
      }

      _menuButton.visible = true;
      _appBar.span(spanWidth, 10);
      _appBar.x = 0;
    }

    _modalBg.width = spanWidth;
    _modalBg.height = spanHeight;
  }

  void _openMenu() {
    _modalBg.addEventListener(TouchEvent.TOUCH_BEGIN, _modalMouseDownAction);
    _modalBg.addEventListener(MouseEvent.CLICK, _modalMouseDownAction);
    Ac.JUGGLER.addTween(_modalBg, .4)..animate.alpha.to(.5);

    _modalBg.visible = true;
    _sidebar.visible = true;
    Ac.JUGGLER.addTween(_sidebar, .2, Transition.easeOutQuintic)
      ..animate.x.to(0);
  }

  void _closeMenu([double duration = .1]) {
    _modalBg.alpha = 0;
    _modalBg.visible = false;

    if (duration > 0) {
      Ac.JUGGLER.addTween(_sidebar, duration, Transition.easeInQuintic)
        ..animate.x.to(-_sidebar.spanWidth)
        ..onComplete = () => _sidebar.visible = false;
    } else {
      _sidebar.x = -_sidebar.spanWidth;
    }
  }

  void _modalMouseDownAction(event) {
    _modalBg.removeEventListener(TouchEvent.TOUCH_BEGIN, _modalMouseDownAction);
    _modalBg.removeEventListener(MouseEvent.CLICK, _modalMouseDownAction);
    _closeMenu();
  }

  void _onAddressSet(AcSignal e) {
    if (_sidebarShowingPermanently == false) {
      _closeMenu();
    }

    StateVO vo = e.data;
    StateVO topVo = vo;
    String appBarTitle = vo.title;

    // if current page is the home page
    if (vo.tree_parent == -1) {
      // reset
      _subPageList = null;
    }

    // if current page is on first level below home
    else if (vo.tree_parent == 0) {
      // get list of child pages
      _subPageList = _stateModel.getStateVOList(true, vo.tree_order);
    }

    // if current page is second level (i.e. a subpage below a subpage below home)
    else if (vo.tree_parent > 0) {
      // if this subpage is the first ever loaded, get list of its siblings
      _subPageList = _stateModel.getStateVOList(true, vo.tree_parent);
      topVo = _stateModel
          .getStateVOList(true, 0)
          .firstWhere((v) => v.tree_order == vo.tree_parent);
      appBarTitle = "${topVo.title} >${vo.title}";
    }

    // if no subpages
    if (_subPageList == null || _subPageList.length == 0) {
      _sidebar.closeSubmenu();
    } else {
      _subPageList.forEach((vo) {
        if (!vo.title.contains("   ")) vo.title = "   ${vo.title}";
      });
      // add root and category home entries
      _subPageList.insert(0, topVo);

      _sidebar.openSubmenu(_subPageList);
    }

    // send vo to sidebar so we can highlight the current url's button (if applicable)
    _sidebar.setVO(vo);

    // if page is not a layer
    if (vo.url.indexOf("layer") == -1) {
      // title animation
      int leHeight =
          (MdDimensions.HEIGHT_APP_BAR / 2 - _headline.textHeight / 2).round();
      Ac.JUGGLER.addTween(_headline, .1, Transition.easeInQuintic)
        ..animate.y.to(leHeight - 15)
        ..animate.alpha.to(0)
        ..onComplete = () {
          _headline.text = appBarTitle;
          _headline.y = leHeight + 15;

          Tween tw =
              Ac.JUGGLER.addTween(_headline, .2, Transition.easeOutQuintic);
          tw.animate.y.to(leHeight);
          tw.animate.alpha.to(1);
        };
    }
  }

  _mousePointerShader() {
    if (Ac.STAGE.filters.length > 0) {
      Ac.STAGE.filters = [];
      Ac.MATERIALIZE_REQUIRED = false;
      return;
    }

    BitmapData bitmapData = Assets.displacement_bubble;

    var matrix = new Matrix.fromIdentity();
    matrix.scale(1.2, 1.2);

    DisplacementMapFilter filter =
        new DisplacementMapFilter(bitmapData, matrix, 100, 100);

    Ac.STAGE.filters = [filter];
    if (Ac.MOBILE) {
      Ac.STAGE.addEventListener<InputEvent>(TouchEvent.TOUCH_MOVE,
          (InputEvent e) {
        filter.matrix.tx = e.stageX - 285;
        filter.matrix.ty = e.stageY - 185;
        Ac.MATERIALIZE_REQUIRED = true;
      });
    } else {
      Ac.STAGE.addEventListener<InputEvent>(MouseEvent.MOUSE_MOVE,
          (InputEvent e) {
        filter.matrix.tx = e.stageX - 285;
        filter.matrix.ty = e.stageY - 185;
        Ac.MATERIALIZE_REQUIRED = true;
      });
    }
  }
}
