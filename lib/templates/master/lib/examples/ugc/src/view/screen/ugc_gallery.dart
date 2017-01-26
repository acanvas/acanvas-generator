part of ugc_example;

class UGCGallery extends AbstractScreen {
  UGCPhotoPager _pager;

  UGCGallery(String id) : super(id) {}

  @override
  void init({Map params: null}) {
    super.init(params: params);

    _pager = new UGCPhotoPager(applicationContext.getObject(UGCEvents.ITEMS_FILTER), getProperty("pager.prev"),
        getProperty("pager.next"), getProperty("pager.empty"));
    _pager.submitCallback = _onItemClicked;
    addChild(_pager);
    _pager.resetAndLoad();

    onInitComplete();
  }

  @override
  void refresh() {
    super.refresh();

    _pager.x = 0;
    _pager.y = 0;
    _pager.span(spanWidth, spanHeight);
  }

  @override
  void dispose({bool removeSelf: true}) {
    super.dispose();

    //additional cleanup logic
  }

  void _onItemClicked(UGCItemDTO dao) {
    logger.debug("Item clicked. id: {0}, url_big: {1}", [dao.id, (dao.type_dao as UGCImageItemDTO).url_big]);
    //model.currentUGCItem = dao;
    //new RdSignal(StateEvents.ADDRESS_SET, "/image/view").dispatch();
  }
}
