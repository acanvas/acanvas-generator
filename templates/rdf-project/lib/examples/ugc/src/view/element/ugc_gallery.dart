part of ugc_example;

class UGCGallery extends AbstractPolaroidPager {
  static const int WIDTH_BUTTON = Dimensions.HEIGHT_RASTER;

  IAsyncCommand dataCommand;
  int containerID;

  PolaroidItemButton uploadButton;

  UGCGallery(this.dataCommand, this.containerID, String labelPrev,
      String labelNext, String labelEmpty)
      : super(labelPrev, labelNext, labelEmpty,
            buttonWidth: Dimensions.HEIGHT_RASTER, DATA_PAGESIZE: 100) {
    name = "ugc.gallery";
    chunkSize = 50;

    uploadButton = new PolaroidItemButton("", 10, 10);
    addChild(uploadButton);
  }

  @override
  setupProxy() {
    DataProxy pagerProxy = new DataProxy();
    pagerProxy.dataRetrieveCommand = dataCommand;
    pagerProxy.dataRetrieveCommandVO = new UGCFilterVO(
        UGCFilterVO.CONDITION_ALL, UGCFilterVO.ORDER_DATE_DESC, chunkSize);
    listProxy = pagerProxy;
  }

  @override
  void refresh() {
    listItemWidth = ((spanWidth - 80) / 4).round();
    listItemHeight = (listItemWidth * 1.3).round();
    listItemSpacer = listItemWidth;

    uploadButton.span(listItemWidth, listItemHeight);
    uploadButton.x = spanWidth - uploadButton.spanWidth - Dimensions.SPACER;
    uploadButton.y = spanHeight - uploadButton.spanHeight - Dimensions.SPACER;
    uploadButton.rotation = -4.0 * math.PI / 180;
    super.refresh();
  }

  @override
  BoxSprite getPagerItem(dynamic vo) {
    String source = (vo as UGCImageItemDTO).url_big;

    PolaroidItemButton item =
        new PolaroidItemButton(source, listItemWidth, listItemHeight);
    item.addEventListener(InteractEvent.SELECT_ACTION, onItemSelect);
    item.addEventListener(InteractEvent.DESELECT_ACTION, onItemDeselect);
    //item.submitCallback = onItemClicked;
    //item.submitCallbackParams = [vo];

    return item;
  }
}
