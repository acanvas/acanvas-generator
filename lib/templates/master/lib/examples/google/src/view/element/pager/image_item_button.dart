part of google_example;

/**
	 * Written in 2014 by Nils Döhring, Block Forest
	 */

class ImageItemButton extends Button {
  Sprite _bg;
  Sprite _bgOver;
  ImageSprite _image;

  ImageItemButton(String href, int w, int h) : super() {
    alpha = 0;

    _bg = new Sprite();
    addChild(_bg);

    _bgOver = new Sprite();
    addChild(_bgOver);

    _image = new ImageSprite()
      ..span(w - 6, h - 6, refresh: false)
      ..addEventListener(Event.COMPLETE, _onImageLoadComplete)
      ..href = href;
    addChild(_image);

    span(w, h, refresh: false);
  }

  @override
  void refresh() {
    _image.x = 5;
    _image.y = 5;
    _image.span(spanWidth - 6, spanHeight - 6);

    RdGraphics.rectangle(0, 0, spanWidth, spanHeight, color: Theme.BACKGROUND_COLOR, sprite: _bg);

    RdGraphics.rectangle(0, 0, spanWidth, spanHeight, color: Theme.COLOR_BASE, sprite: _bgOver);
    _bgOver.alpha = 0;

    super.refresh();
  }

  @override
  void rollOverAction([MouseEvent event = null]) {
    if (stage != null) {
      Rd.JUGGLER.removeTweens(_bgOver);
      Rd.JUGGLER.addTween(_bgOver, 0.3)..animate.alpha.to(1);
    } else if (_bgOver != null) {
      _bgOver.alpha = 1;
    }
  }

  @override
  void rollOutAction([MouseEvent event = null]) {
    if (stage != null) {
      Rd.JUGGLER.addTween(_bgOver, 0.3)..animate.alpha.to(0);
    } else if (_bgOver != null) {
      _bgOver.alpha = 1;
    }
  }

  void _onImageLoadComplete(Event event) {
    _image.removeEventListener(Event.COMPLETE, _onImageLoadComplete);
    refresh();
    Tween tween = new Tween(this, 0.8, Transition.easeInCubic)
      ..delay = new Random().nextDouble()
      ..animate.alpha.to(1);
    Rd.JUGGLER.add(tween);
  }
}
