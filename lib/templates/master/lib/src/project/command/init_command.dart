part of rockdot_template;

/**
	 * Called by the initialization Command Sequence inside of @see Application
	 */
class InitCommand extends AbstractCommand implements IStateModelAware, IScreenServiceAware {
  StateModel _stateModel;
  void set stateModel(StateModel stateModel) {
    _stateModel = stateModel;
  }

  IScreenService _uiService;
  void set uiService(IScreenService uiService) {
    _uiService = uiService;
  }

  @override
  void execute([RdSignal event = null]) {
    super.execute(event);

    //App Background
    Background background = new Background("element.background");
    _uiService.background.addChild(background);
    //background.init();

    //App Navigation
    Navigation navigation = new Navigation("element.navigation");
    RdContextUtil.wire(navigation);
    _uiService.navi.addChild(navigation);
    // navigation.init();

    //Setup Modal Filter Effect
    _uiService.modalBackgroundFilter = new BlurFilter(6, 6);

    _stateModel.addressService.init();
    dispatchCompleteEvent();

    return null;
  }
}
