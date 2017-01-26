part of facebook_example;

/**
	 * Written in 2014 by Nils Döhring, Block Forest
	 */
class PolaroidItemButton extends SelectableButton {
  int xPos;
  int yPos;
  num rot;

  Sprite _bg;
  ImageSprite _image;

  PolaroidItemButton(String href, int w, int h) : super() {
    _bg = new Sprite();
    addChild(_bg);

    _image = new ImageSprite(alignH: AlignH.LEFT, alignV: AlignV.TOP)
      ..span(w - 6, h - 20, refresh: false)
      ..href = href
      ..addEventListener(Event.COMPLETE, _onImageLoadComplete);
    addChild(_image);

    span(w, h, refresh: false);
  }

  void _onImageLoadComplete(Event event) {
    _image.removeEventListener(Event.COMPLETE, _onImageLoadComplete);
    refresh();
  }

  @override
  void refresh() {
    _image.mask = new Mask.rectangle(3, 3, spanWidth - 6, spanHeight - 20)..relativeToParent = true;
    _image.x = ((spanWidth / 2 - _image.width / 2));

    RdGraphics.rectangle(0, 0, spanWidth, spanHeight, color: Colors.WHITE, sprite: _bg);

    pivotX = spanWidth / 2;
    pivotY = spanHeight / 2;

    super.refresh();
  }
}
