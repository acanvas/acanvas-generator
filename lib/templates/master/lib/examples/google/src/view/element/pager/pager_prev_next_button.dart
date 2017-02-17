part of google_example;

/**
	 * Written in 2014 by Nils Döhring, Block Forest
	 */
class PagerPrevNextButton extends Button {
  Shape _bg;
  UITextField _label;
  int _color;
  PagerPrevNextButton(String text,
      [int w = 0, int h = Dimensions.HEIGHT_RASTER, int size = 24, int color = Theme.COLOR_BASE])
      : super() {
    _color = color;

    _label = Theme.getHeadline(text, size: size, color: Colors.BLACK);
    addChild(_label);

    _bg = new Shape();
    addChildAt(_bg, 0);

    span(w, h);
  }

  @override
  void refresh() {
    _label.width = spanWidth - 2 * Dimensions.SPACER;
    _label.x = (spanWidth / 2 - _label.textWidth / 2).round() - 3;
    _label.y = (spanHeight / 2 - _label.textHeight / 2).round() - 3;

    _bg.graphics.clear();
    _bg.graphics.rect(0, 0, spanWidth, spanHeight);
    _bg.graphics.fillColor(_color);
    //_bg.applyCache(0, 0, spanWidth, spanHeight);

    super.refresh();
  }

  @override
  void rollOverAction([InputEvent event = null]) {
    //TweenLite.to(_bg, 0.1, {colorMatrixFilter:{brightness:0.8}});
    if (stage != null) {
      Tween tween = new Tween(_bg, 0.2, Transition.easeInCubic);
      tween.animate.alpha.to(.7);
      Rd.JUGGLER.add(tween);
    } else if (_bg != null) {
      _bg.alpha = 0.7;
    }
    super.rollOverAction(event);
  }

  @override
  void rollOutAction([InputEvent event = null]) {
//			TweenLite.to(_bg, 0.3, {colorMatrixFilter:{brightness:1.0}});
    if (stage != null) {
      Tween tween = new Tween(_bg, 0.3, Transition.easeInCubic);
      tween.animate.alpha.to(1);
      Rd.JUGGLER.add(tween);
    } else if (_bg != null) {
      _bg.alpha = 1;
    }
    super.rollOutAction(event);
  }
}
