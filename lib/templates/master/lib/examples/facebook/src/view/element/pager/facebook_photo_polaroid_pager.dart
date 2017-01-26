part of facebook_example;

/**
   * @author nilsdoehring
   */
class FacebookPhotoPolaroidPager extends AbstractPolaroidPager {
  static const int WIDTH_BUTTON = Dimensions.HEIGHT_RASTER;

  IAsyncCommand dataCommand;
  String albumID;

  FacebookPhotoPolaroidPager(this.dataCommand, this.albumID, String labelPrev, String labelNext, String labelEmpty)
      : super(labelPrev, labelNext, labelEmpty, buttonWidth: Dimensions.HEIGHT_RASTER, DATA_PAGESIZE: 100) {
    name = "element.pager.facebook";
  }

  @override
  setupProxy() {
    DataProxy pagerProxy = new DataProxy();
    pagerProxy.dataRetrieveCommand = dataCommand;
    pagerProxy.dataRetrieveCommandVO = new DataRetrieveVO(DATA_PAGESIZE, nextToken: "", id: albumID);
    listProxy = pagerProxy;
  }

  @override
  void refresh() {
    listItemWidth = ((spanWidth - 80) / 4).round();
    listItemHeight = (listItemWidth * 1.3).round();
    listItemSpacer = listItemWidth;
    super.refresh();
  }

  @override
  BoxSprite getPagerItem(dynamic vo) {
    String source;
    List images = (vo as FBPhotoVO).images;
    if (images.length > 2) {
      source = images[2]["source"];
    } else {
      source = images[0]["source"];
    }

    PolaroidItemButton item = new PolaroidItemButton(source, listItemWidth, listItemHeight);
    item.addEventListener(InteractEvent.SELECT_ACTION, _onItemSelect);
    item.addEventListener(InteractEvent.DESELECT_ACTION, _onItemDeselect);
    //item.submitCallback = onItemClicked;
    //item.submitCallbackParams = [vo];

    return item;
  }
}
