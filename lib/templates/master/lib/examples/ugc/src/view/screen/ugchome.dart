part of ugc_example;

class UGCHome extends AbstractScreen implements IUGCModelAware {
  UGCGallery _photoPager;

  UGCModel _ugcModel;
  set ugcModel(UGCModel ugcModel) {
    _ugcModel = ugcModel;
  }

  UGCHome(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _photoPager = new UGCGallery(applicationContext.getObject(UGCEvents.ITEMS_FILTER), 0, getProperty("pager.prev"),
        getProperty("pager.next"), getProperty("pager.empty"));
    _photoPager.submitCallback = _onItemClicked;
    _photoPager.uploadButton.submitEvent =
        new RdSignal(StateEvents.ADDRESS_SET, getProperty("${UGCExampleScreenIDs.UGC_LAYER_UPLOAD}.url", true));
    addChild(_photoPager);
    // _photoPager.resetAndLoad();

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();
    _photoPager.span(spanWidth, spanHeight);
  }

  void _onItemClicked(UGCItemDTO dao) {
    //this.log.debug("Item clicked. id: {0}, url_big: {1}", [dao.id, (dao.type_dao as UGCImageItemVO).url_big]);
    _ugcModel.currentItemDAO = dao;
    //new RdSignal(StateEvents.ADDRESS_SET, "/image/view").dispatch();
  }

  @override
  void dispose({bool removeSelf: true}) {
    // your cleanup operations here

    Rd.JUGGLER.removeTweens(this);
    super.dispose();
  }
}
