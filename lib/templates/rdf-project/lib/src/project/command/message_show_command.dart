part of acanvas_template;

/**
* Show Status Message
*/
class MessageShowCommand extends AbstractCommand
    implements IStateModelAware, IScreenServiceAware {
  StateModel _stateModel;
  void set stateModel(StateModel stateModel) {
    _stateModel = stateModel;
  }

  IScreenService _uiService;
  void set uiService(IScreenService uiService) {
    _uiService = uiService;
  }

  @override
  dynamic execute([AcSignal event = null]) {
    super.execute(event);

    StateMessageVO vo = event.data;

    int fontColor = MdColor.WHITE;
    int bgColor = Theme.COLOR_BASE;
    switch (vo.type) {
      case StateMessageVO.TYPE_ERROR:
        bgColor = MdColor.RED;
        break;
      case StateMessageVO.TYPE_INFO:
        bgColor = MdColor.GREEN;
        break;
      case StateMessageVO.TYPE_WAITING:
        bgColor = MdColor.BLACK;
        break;
      case StateMessageVO.TYPE_LOADING:
      case StateMessageVO.TYPE_WARN:
        bgColor = MdColor.WHITE;
        fontColor = MdColor.BLACK;
        break;
    }

    MdToast toast = new MdToast(vo.message, _uiService.stage,
        fontColor: fontColor,
        bgColor: bgColor,
        hideAfterSeconds: vo.timeBox,
        position: MdToast.BR);
    toast.name = vo.id;

    if (vo.blurContent &&
        !_uiService.isBlurred &&
        _stateModel.currentStateVO.substate != StateConstants.SUB_MODAL) {
      _uiService.blur();
      if (vo.timeBox > 0) {
        Ac.JUGGLER.delayCall(_uiService.unblur, vo.timeBox);
      }
    }

    dispatchCompleteEvent();

    return null;
  }
}
