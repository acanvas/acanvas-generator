part of google_example;

/**
	 * @author nilsdoehring
	 */
class GooglePlusFriendPhotoPager extends AbstractPhotoPager {
  IAsyncCommand dataCommand;

  GooglePlusFriendPhotoPager(this.dataCommand, String labelPrev, String labelNext, String labelEmpty)
      : super(labelPrev, labelNext, labelEmpty, DATA_PAGESIZE: 100) {
    name = "element.pager.google";
  }

  @override
  setupProxy() {
    DataProxy pagerProxy = new DataProxy();
    pagerProxy.dataRetrieveCommand = dataCommand; //applicationContext.getObject(UGCEvents.ITEMS_FILTER);
    pagerProxy.dataRetrieveCommandVO = new DataRetrieveVO(DATA_PAGESIZE, nextToken: "");

    listItemWidth = 120;
    listItemHeight = 120;
    listItemSpacer = 0;
    listProxy = pagerProxy;
  }

  @override
  BehaveSprite getPagerItem(dynamic vo) {
    String url = (vo as Person).image.url.replaceAll(r"sz=50", "sz=$listItemWidth");
    BehaveSprite item = new ImageItemButton(url, listItemWidth, listItemHeight);
    item.submitCallback = onItemClicked;
    item.submitCallbackParams = [vo as Person];

    return item;
  }
}
