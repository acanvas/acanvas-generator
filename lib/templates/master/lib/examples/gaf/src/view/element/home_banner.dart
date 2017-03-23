part of gaf_example;

class HomeBanner extends RockdotBoxSprite {
  ImageSprite spr1;


    HomeBanner() : super() {
        //prefix used for retrieval of properties
        name = "element.home_banner";
        spr1 = new ImageSprite();
        addChild(spr1);
        spr1.bitmapData = GAFAssets.gaf_companies;
      //  spr1.inheritSpan = true;
    }

    @override void span(num spanWidth, num spanHeight, {bool refresh: true}){
      super.span(spanWidth, spanHeight, refresh: refresh);
    }

    @override void refresh() {
      super.refresh();

      spr1.scaleToWidth(spanWidth);
    }

    @override
    void dispose({bool removeSelf: true}) {

      // your cleanup operations here

      Rd.JUGGLER.removeTweens(this);
      super.dispose(removeSelf: removeSelf);
    }
}