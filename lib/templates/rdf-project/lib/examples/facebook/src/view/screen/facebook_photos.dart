part of facebook_example;

class FacebookPhotos extends AbstractScreen implements IStateModelAware {
  StateModel _stateModel;
  FacebookPhotoPolaroidPager _photoPager;

  FacebookPhotos(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    if (params == null || !(params is Map) || params["id"] == null) {
      if (_stateModel.currentStateVO.params == null ||
          _stateModel.currentStateVO.params["id"] == null) {
        new RdSignal(StateEvents.ADDRESS_SET,
                getProperty("${FacebookExampleScreenIDs.FACEBOOK_ALBUMS}.url"))
            .dispatch();
        return;
      }
      params = _stateModel.currentStateVO.params;
    }

    _photoPager = new FacebookPhotoPolaroidPager(
        applicationContext.getObject(FBEvents.PHOTOS_GET),
        params["id"],
        getProperty("pager.prev"),
        getProperty("pager.next"),
        getProperty("pager.empty"));
    _photoPager.submitCallback = _onItemClicked;
    addChild(_photoPager);
    _photoPager.resetAndLoad();

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _photoPager.x = 0;
    _photoPager.y = 0;
    _photoPager.span(spanWidth, spanHeight);
  }

  void _onItemClicked(FBPhotoVO dao) {
    Rd.log.info("Item clicked. id: {0}, url_big: {1}", [dao.id, dao.source]);
    // new RdSignal(StateEvents.ADDRESS_SET, "/layer").dispatch();
  }

  @override
  void set stateModel(StateModel stateModel) {
    _stateModel = stateModel;
  }
}
