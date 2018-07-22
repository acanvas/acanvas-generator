part of facebook_example;

/**
 * @author Nils Doehring (nilsdoehring@gmail.com)
 */
class ListFBAlbumCell extends SelectableButton {
  static const int CELL_HEIGHT = 80;

  MdText _title;
  ImageSprite _icon;

  ListFBAlbumCell() : super() {
    _title = Theme.getHeadline(".", size: 36);
    addChild(_title);
  }

  @override
  SelectableButton clone() => new ListFBAlbumCell();

  @override
  void set data(dynamic newdata) {
    if (newdata != data) {
      super.data = newdata;
      if (data is FBAlbumVO) {
        _title.text = (data as FBAlbumVO).name;
        /*
         url would be: https://graph.facebook.com/3576556947670?access_token=...
        result would be at json["picture"] (thumbnail with height of 130)
         */
        //_icon = new ImageSprite((data as FBAlbumVO).cover_photo, CELL_HEIGHT, CELL_HEIGHT);
        //addChild(_icon);
        refresh();
      }
    }
  }

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(spanWidth, CELL_HEIGHT, refresh: refresh);
  }

  @override
  void refresh() {
    _title.text = _title.text.toUpperCase();
    _title.x = 10;
    _title.width = spanWidth - _title.x - CELL_HEIGHT - Dimensions.SPACER;
    _title.y = spanHeight / 2 - _title.textHeight / 2;

    if (_icon != null) _icon.x = spanWidth - _icon.spanWidth;

    graphics.clear();
    graphics.rect(0, 0, spanWidth, CELL_HEIGHT);
    graphics.fillColor(selected
        ? Theme.EXAMPLES_HIGHLIGHT_MAIN
        : (id % 2 == 0 ? Colors.GREY_DARK : Colors.GREY_MIDDLE));
  }
}
