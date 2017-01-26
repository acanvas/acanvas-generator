part of dragonbones_example;

class DragonbonesHome extends AbstractReflowScreen {

  DragonbonesHome(String id) : super(id) {
  }

    //----------------------------------------------------------------------------
  
  @override
    void init({Map params : null}) {
      super.init(params: params);

      addChild(reflow);

      // your initialization operations here

      onInitComplete();
    }

    //----------------------------------------------------------------------------

    @override void refresh() {
      super.refresh();

      // your redraw operations here
    }

    //----------------------------------------------------------------------------

    @override
    void dispose({bool removeSelf: true}) {

      // your cleanup operations here

      Rd.JUGGLER.removeTweens(this);
      super.dispose();
    }

    //----------------------------------------------------------------------------
}