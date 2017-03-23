part of @package@;

class @element@ extends RockdotBoxSprite {

    @element@() : super() {
        //prefix used for retrieval of properties
        name = "element.@elementproperty@";

        //initialize your stuff here
    }

    @override void span(num spanWidth, num spanHeight, {bool refresh: true}){
      super.span(spanWidth, spanHeight, refresh: refresh);
    }

    @override void refresh() {
      super.refresh();

      // your redraw operations here
    }

    @override
    void dispose({bool removeSelf: true}) {

      // your cleanup operations here

      Rd.JUGGLER.removeTweens(this);
      super.dispose(removeSelf: removeSelf);
    }
}