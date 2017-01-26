part of facebook_example;

class AbstractPolaroidPager extends AbstractPhotoPager {
  static const num WIDTH_BUTTON = MdDimensions.WIDTH_BUTTON_MINIMAL;
  static const num HEIGHT_BUTTON = MdDimensions.HEIGHT_BUTTON;

  UITextField _tfNothingFound;
  Shape _bg;
  List _items;

  AbstractPolaroidPager(String labelPrev, String labelNext, String labelEmpty,
      {int buttonWidth: WIDTH_BUTTON, int DATA_PAGESIZE: 100})
      : super(labelPrev, labelNext, labelEmpty, buttonWidth: buttonWidth, DATA_PAGESIZE: DATA_PAGESIZE) {
    name = "element.pager.polaroid";
  }

  @override
  void refresh() {
    super.refresh();

    rows = (spanHeight / (listItemHeight)).floor();
    chunkSize = rows * (spanWidth / (listItemWidth)).floor();

    holder.x = 0;

    btnPrev.span(buttonWidth, HEIGHT_BUTTON);
    btnPrev.scaleX = -1;
    btnPrev.y = spanHeight - btnPrev.height;

    btnNext.span(buttonWidth, HEIGHT_BUTTON);
    btnNext.x = spanWidth - buttonWidth;
    btnNext.y = spanHeight - btnNext.height;
  }

  @override
  Sprite pageCreate(List listItems) {
    BoxSprite imageListHolder = new BoxSprite();
    int numPlacedPhotos = 0;

    PolaroidItemButton item;
    int currentWidth = (listItemWidth / 2).round();
    int currentLine = 0;
    num rot;

    _items = [];
    enabled = false;
    Random rand = new Random();

    for (int i = 0; i < listItems.length; i++) {
      if (currentLine < rows) {
        item = getPagerItem(listItems[i]) as PolaroidItemButton;

        if (pressedNext) {
          item.x = spanWidth + 150;
        } else {
          item.x = -item.width - 150;
        }
        item.y = rand.nextDouble() * spanHeight;
        if (i % 2 != 0) {
          rot = (rand.nextDouble().abs());
        } else {
          rot = -(rand.nextDouble().abs());
        }
        //item.filters = [new DropShadowFilter(2, 90, 0xdd000000, 10, 10)];
        item.rot = rot;
        item.name = i.toString();

        item.xPos = currentWidth + (new Random().nextInt(50) - 25);
        item.yPos = 180 + listItemHeight * (currentLine);
        if (rows > 1 && currentWidth + listItemWidth > spanWidth - 80 && ++currentLine < rows) {
          currentWidth = (listItemWidth / 2).round();
        } else {
          currentWidth += listItemWidth;
        }

        _items.add(item);

        Rd.JUGGLER.removeTweens(item);
        Rd.JUGGLER.addTween(item, 0.8, Transition.easeOutQuintic)
          ..delay = i * 0.1
          ..animate.x.to(item.xPos)
          ..animate.y.to(item.yPos)
          ..animate.rotation.to(rot);
        // --- update currentWidth

        imageListHolder.addChild(item);
        numPlacedPhotos++;
      } else {
        break;
      }
    }

    chunksPlaced.add(numPlacedPhotos);
    return imageListHolder;
  }

  void _onItemSelect(InteractEvent event) {
    PolaroidItemButton photo = (event.target as PolaroidItemButton);
    PolaroidItemButton otherPhoto;
    DisplayObjectContainer holder = photo.parent;

    Rectangle intersectRect;
    int photoIndex = holder.getChildIndex(photo);
    int dir;

    if (photoIndex != holder.numChildren - 1) {
      // Is not on top. Move other away
      // graphics.clear();
      for (int i = photoIndex + 1; i < holder.numChildren; i++) {
        otherPhoto = (holder.getChildAt(i) as PolaroidItemButton);
        if (photo.hitTestObject(otherPhoto)) {
          // if you want to debug:
          // graphics.lineStyle(8,0xff0000);
          // graphics.drawRect(intersectRect.x, intersectRect.y, intersectRect.width, intersectRect.height);
          dir = otherPhoto.x > photo.x ? 1 : -1;

          //yoyo tween
          num xOriginal = otherPhoto.x;
          Rd.JUGGLER.addTween(otherPhoto, 0.3, Transition.easeInQuintic)
            ..animate.x.to(otherPhoto.xPos + dir * (photo.width / 2));
          Rd.JUGGLER.addTween(otherPhoto, 0.7, Transition.easeOutQuintic)
            ..animate.x.to(otherPhoto.xPos)
            ..delay = .4;
        }
      }
      Rd.JUGGLER.removeTweens(photo);

      Tween tween = new Tween(photo, 0.6, Transition.easeOutQuintic)
        ..delay = 0.2
        ..animate.x.to(spanWidth / 2)
        ..animate.y.to(spanHeight / 2)
        ..animate.rotation.to(0)
        ..animate.scaleX.to(2.7)
        ..animate.scaleY.to(2.7)
        ..onStart = () => (photo.parent as DisplayObjectContainer)
            .swapChildren(photo, photo.parent.getChildAt(photo.parent.numChildren - 1));
      Rd.JUGGLER.add(tween);
      //  DropShadowFilter ds = new DropShadowFilter(20, 45, 0xff000000, 15, 15);
      //  photo.filters = [ds];

    } else {
      // Is on top. Do nothing.
      Rd.JUGGLER.removeTweens(photo);
      Tween tween = new Tween(photo, 0.6, Transition.easeOutQuintic)
        ..delay = 0.2
        ..animate.x.to(spanWidth / 2)
        ..animate.y.to(spanHeight / 2)
        ..animate.rotation.to(0)
        ..animate.scaleX.to(2.7)
        ..animate.scaleY.to(2.7);
      Rd.JUGGLER.add(tween);

      // DropShadowFilter ds = new DropShadowFilter(20, 45, 0xff000000, 15, 15);
      // photo.filters = [ds];
    }
  }

  void _onItemDeselect(InteractEvent event) {
    if (stage == null) return;

    PolaroidItemButton photo = (event.target as PolaroidItemButton);

    Rd.JUGGLER.removeTweens(photo);
    Tween tween = new Tween(photo, 0.6, Transition.easeOutQuintic)
      ..delay = 0.2
      ..animate.x.to(photo.xPos)
      ..animate.y.to(photo.yPos)
      ..animate.rotation.to(photo.rot)
      ..animate.scaleX.to(1)
      ..animate.scaleY.to(1);
    Rd.JUGGLER.add(tween);

    // DropShadowFilter ds = new DropShadowFilter(2, 45, 0xff000000, 10, 10);
    // photo.filters = [ds];
  }
}
