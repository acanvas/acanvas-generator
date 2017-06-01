part of google_example;

class GoogleFriends extends AbstractScreen implements IGoogleModelAware {
  GooglePlusFriendPhotoPager _photoPager;

  GoogleModel _googleModel;
  @override
  void set googleModel(GoogleModel gModel) {
    _googleModel = gModel;
  }

  GoogleFriends(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _photoPager = new GooglePlusFriendPhotoPager(applicationContext.getObject(GoogleEvents.PLUS_PEOPLE_GET),
        getProperty("pager.prev"), getProperty("pager.next"), getProperty("pager.empty"));
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

  void _onItemClicked(Person dao) {
    Rd.log.info("Item clicked. id: {0}, url_big: {1}", [dao.id, dao.image.url]);
    //new RdSignal(StateEvents.ADDRESS_SET, "/image/view").dispatch();
  }

  @override
  void dispose({bool removeSelf: true}) {
    super.dispose();

    //additional cleanup logic
  }
}
