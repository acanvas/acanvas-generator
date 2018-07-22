part of acanvas_template;

/**
 * @author Nils Doehring (nilsdoehring@gmail.com)
 */
class ListMenuCell extends SelectableButton {
  UITextField label;
  int fontColor;

  ListMenuCell([this.fontColor = Theme.MD_BUTTON_FONT_COLOR]) : super() {
    selfSelect = false;
    MdRipple ripple = new MdRipple(color: Theme.HIGHLIGHT_MAIN_COMP)..opacity = 1;
    addChild(ripple);

    label = Theme.getHeadline("empty", size: 14, color: fontColor);
    addChild(label);
  }

  @override
  SelectableButton clone() => new ListMenuCell(fontColor);

  @override
  void set data(Object newdata) {
    if (newdata != data) {
      super.data = newdata;
      if (data != null && data is StateVO) {
        label.text = (data as StateVO).title;
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
    label.text = label.text.toUpperCase();
    label.width = spanWidth - 10;
    label.x = 2 * Dimensions.SPACER;
    label.y = (spanHeight / 2 - label.textHeight / 2).round();

    graphics.clear();
    graphics.rect(0, 0, spanWidth, spanHeight);
    graphics.fillColor(selected
        ? Theme.HIGHLIGHT_MAIN
        : (id % 2 == 0 ? Colors.GREY_DARK : Colors.GREY_MIDDLE));

    super.refresh();
  }

  @override
  void selectAction() {
    downAction();
    mouseEnabled = false;
    label.defaultTextFormat = label.defaultTextFormat..color = Colors.WHITE;
  }

  @override
  void deselectAction() {
    mouseEnabled = true;
    upAction(null, false);
    label.defaultTextFormat = label.defaultTextFormat
      ..color = Theme.HIGHLIGHT_MAIN;
  }
}
