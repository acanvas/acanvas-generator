part of acanvas_template;

class AbstractCommand extends AcCommand implements IModelAware {
  Model _appModel;
  void set appModel(Model appModel) {
    _appModel = appModel;
  }
}
