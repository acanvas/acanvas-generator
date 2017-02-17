part of rockdot_template;

/**
* Hide Status Message
*/
class MessageHideCommand extends AbstractCommand implements IStateModelAware, IScreenServiceAware {
  StateModel _stateModel;
  void set stateModel(StateModel stateModel) {
    _stateModel = stateModel;
  }

  IScreenService _uiService;
  void set uiService(IScreenService uiService) {
    _uiService = uiService;
  }

  @override
  dynamic execute([RdSignal event = null]) {
    super.execute(event);

    String id = event.data;

    MdToast toast = _uiService.stage.getChildByName(id);
    if (toast != null) {
      toast.hide();
    }

    if (_uiService.isBlurred && _stateModel.currentStateVO.substate != StateConstants.SUB_MODAL) {
      _uiService.unblur();
    }

    dispatchCompleteEvent();

    return null;
  }
}
