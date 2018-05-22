part of babylon_example;

class BabylonExamplePlugin extends AbstractRdPlugin {
  int sorting;
  BabylonExamplePlugin(this.sorting) : super(900 + sorting) {}

  @override
  void configureScreens() {
    if (!Rd.WEBGL) {
      return;
    }

    addScreen(BabylonExampleScreenIDs.BABYLON_HOME,
        () => new BabylonHome(BabylonExampleScreenIDs.BABYLON_HOME),
        transition: EffectIDs.DEFAULT, tree_order: sorting);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
