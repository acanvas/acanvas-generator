part of facebook_example;

class FacebookAlbums extends AbstractScreen {
  MdMenu _list;

  FacebookAlbums(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    new RdSignal(FBEvents.ALBUMS_GET, null, (List albums) {
      _list = new MdMenu(albums, cell: new ListFBAlbumCell(), shadow: true);
      _list.submitCallback = _onCellCommit;
      addChild(_list);
      onInitComplete();
    }).dispatch();
  }

  @override
  void refresh() {
    super.refresh();

    _list.x = 2 * Dimensions.SPACER;
    _list.span(spanWidth - 2 * _list.x, spanHeight - _list.y);
  }

  void _onCellCommit(SelectableButton cell) {
    FBAlbumVO vo = cell.data as FBAlbumVO;
    String url = getProperty("${FacebookExampleScreenIDs.FACEBOOK_PHOTOS}.url", true);
    new RdSignal(StateEvents.ADDRESS_SET, "${url}?id=${vo.id}").dispatch();
  }
}
