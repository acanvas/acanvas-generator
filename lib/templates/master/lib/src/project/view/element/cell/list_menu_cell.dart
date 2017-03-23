part of rockdot_template;

/**
 * @author Nils Doehring (nilsdoehring@gmail.com)
 */
class ListMenuCell extends SelectableButton {
  UITextField title;
  int fontColor;

  ListMenuCell([this.fontColor = Colors.ARCTIC_BLUE]) : super() {
    selfSelect = false;
    MdRipple ripple = new MdRipple(color: Colors.BF_BASE_GREEN)..opacity = 1;
    addChild(ripple);

    title = Theme.getHeadline("empty", size: 14, color: fontColor);
    addChild(title);
  }

  @override
  SelectableButton clone() => new ListMenuCell(fontColor);

  @override
  void set data(Object newdata) {
    if (newdata != data) {
      super.data = newdata;
      if (data != null && data is StateVO) {
        title.text = (data as StateVO).title;
        refresh();
      }
    }
  }

  @override
  void span(num w, num h, {bool refresh: true}) {
    super.span(w, MdDimensions.HEIGHT_MENU_CELL, refresh: refresh);
  }

  @override
  void refresh() {
    title.text = title.text.toUpperCase();
    title.width = spanWidth - 10;
    title.x = 2 * Dimensions.SPACER;
    title.y = (spanHeight / 2 - title.textHeight / 2).round();

    graphics.clear();
    graphics.rect(0, 0, spanWidth, spanHeight);
    graphics.fillColor(selected ? Theme.COLOR_BASE : (id % 2 == 0 ? Colors.GREY_DARK : Colors.GREY_MIDDLE));

    super.refresh();
  }

  @override
  void selectAction() {
    downAction();
    mouseEnabled = false;
    title.defaultTextFormat = title.defaultTextFormat..color = Colors.WHITE;
  }

  @override
  void deselectAction() {
    mouseEnabled = true;
    upAction(null, false);
    title.defaultTextFormat = title.defaultTextFormat..color = Colors.ARCTIC_BLUE;
  }
}
