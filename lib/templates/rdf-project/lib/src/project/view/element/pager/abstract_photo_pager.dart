part of rockdot_template;

/**
 * @author nilsdoehring
 */
class AbstractPhotoPager extends PagerSprite {
  int DATA_PAGESIZE = 0;
  static const int WIDTH_BUTTON = Dimensions.HEIGHT_RASTER;

  String labelPrev;
  String labelNext;
  String labelEmpty;
  int buttonWidth;

  int maskWidth;
  int maskHeight;
  int maskX;
  int maskY;

  Mask _imageListMask;
  UITextField _tfNothingFound;
  Shape _bg;

  AbstractPhotoPager(this.labelPrev, this.labelNext, this.labelEmpty,
      {this.buttonWidth: WIDTH_BUTTON, this.DATA_PAGESIZE: 100})
      : super() {
    name = "element.pager.multi";

    chunkSize = DATA_PAGESIZE;

    // bg
    _bg = new Shape();
    addChildAt(_bg, 0);

    setupProxy();

    btnPrev = new PagerPrevNextButton(labelPrev);
    btnPrev.submitCallback = onClickPrev;
    addChild(btnPrev);

    btnNext = new PagerPrevNextButton(labelNext);
    btnNext.submitCallback = onClickNext;
    addChild(btnNext);
  }
  @override
  void span(spanWidth, spanHeight, {bool refresh: true}) {
    super.span(spanWidth, spanHeight, refresh: refresh);
  }

  void setupProxy() {
    throw new StateError("Override this method, would you?");
  }

  @override
  void refresh() {
    rows = (spanHeight / (listItemHeight + listItemSpacer)).ceil();
    chunkSize = rows * (spanWidth / (listItemWidth + listItemSpacer)).round();

    super.refresh();

    maskWidth = spanWidth - 2 * listItemSpacer;
    maskHeight = (listItemHeight + listItemSpacer) * rows -
        Dimensions.HEIGHT_RASTER -
        2 * listItemSpacer;

    _imageListMask =
        new Mask.rectangle(listItemSpacer, 0, maskWidth, maskHeight);
    // holder.mask = _imageListMask;

    if (loaded == true) {
      if (holder.numChildren > 0) {
        disposeChild(holder.getChildAt(0));
      }

      resetAndLoad();
    }

    btnPrev.x = 0;
    btnPrev.y = spanHeight - Dimensions.HEIGHT_RASTER;
    btnPrev.span((spanWidth / 2).round(), Dimensions.HEIGHT_RASTER);

    btnNext.x = (spanWidth / 2).round();
    btnNext.y = spanHeight - Dimensions.HEIGHT_RASTER;
    btnNext.span((spanWidth / 2).round(), Dimensions.HEIGHT_RASTER);

    if (_tfNothingFound != null) {
      _tfNothingFound.x = buttonWidth + Dimensions.SPACER;
    }
  }

  @override
  void setData(List data) {
    if (pressedNext == true) {
      _pageChange(
          super.setData, data, -holder.width, listItemSpacer + maskWidth, 0);
    } else {
      _pageChange(super.setData, data, maskWidth, -maskWidth, 0);
    }

    loaded = false;
    refresh();
    loaded = true;
  }

  void _pageChange(Function cb, List listItems, num xCurrentTarget,
      num xComingInitial, num xComingTarget) {
    DisplayObject current =
        holder.numChildren == 0 ? null : holder.getChildAt(0);

    Sprite coming = pageCreate(listItems);
    coming.x = xComingInitial;
    holder.addChildAt(coming, 0);

    if (current != null && chunksPlaced.length > 0) {
      Rd.JUGGLER.addTween(current, 0.3, Transition.easeInQuintic)
        ..animate.x.to(xCurrentTarget)
        ..onComplete = () => disposeChild(current);

      Rd.JUGGLER.addTween(coming, 0.3, Transition.easeInQuintic)
        ..animate.x.to(xComingTarget);

      if (pressedNext) {
        Rd.JUGGLER.delayCall(() => cb.call(listItems), 0.55);
      } else
        Rd.JUGGLER.delayCall(() => cb.call(listItems), 0.7);
    } else {
      disposeChild(current);
      coming.x = xComingTarget;
      cb.call(listItems);
    }
  }

  void _createNothingFoundInfo() {
    if (_tfNothingFound == null) {
      _tfNothingFound =
          Theme.getCopy(labelEmpty, size: 11, color: Colors.GREY_DARK);
      _tfNothingFound.alpha = 0;
      addChild(_tfNothingFound);
    }

    Rd.JUGGLER.addTween(_tfNothingFound, 0.3)..animate.alpha.to(1);
  }

  Sprite pageCreate(List listItems) {
    BoxSprite imageListHolder = new BoxSprite();
    int numPlacedPhotos = 0;

    BoxSprite item;
    int currentWidth = 0;
    int currentLine = 0;

    // --- lineSprite: one sprite for each line - to center!
    Sprite lineSprite = new Sprite();
    lineSprite.name = "lineSprite" + currentLine.toString();
    imageListHolder.addChild(lineSprite);

    for (int i = 0; i < listItems.length; i++) {
      if (currentLine < rows) {
        item = getPagerItem(listItems[i]);

        // --- new line
        if (rows > 1 &&
            currentWidth + listItemWidth > spanWidth - 2 * listItemSpacer &&
            ++currentLine < rows) {
          item.x = 0;
          currentWidth = 0;

          lineSprite = new Sprite();
          lineSprite.name = "lineSprite" + currentLine.toString();
          lineSprite.y = (listItemHeight + listItemSpacer) * currentLine;
          imageListHolder.addChild(lineSprite);
          // --- same line
        } else {
          item.x = currentWidth;
        }

        // --- update currentWidth
        currentWidth += listItemWidth + listItemSpacer;

        // --- display photo: big: don't show cutted image / small: show cutted image and mask
        if (rows > 1) {
          if (currentWidth - listItemSpacer < spanWidth) {
            lineSprite.addChild(item);
            numPlacedPhotos++;
          } else {
            currentWidth -= listItemWidth + listItemSpacer;
          }

          lineSprite.x = (spanWidth / 2 - (currentWidth).toInt() / 2);
        } else {
          lineSprite.addChild(item);
          if (currentWidth - listItemSpacer < spanWidth) {
            numPlacedPhotos++;
          } else {
            break;
          }
        }
      } else {
        break;
      }
    }

    if (numPlacedPhotos == 0) {
      _createNothingFoundInfo();
    }

    chunksPlaced.add(numPlacedPhotos);
    return imageListHolder;
  }

  BoxSprite getPagerItem(dynamic vo) {
    throw new StateError("Override this method, would you?");
  }

  void onItemClicked(dynamic vo) {
    if (disableClick == false) {
      submitCallback.call(vo);
    }
  }
}
