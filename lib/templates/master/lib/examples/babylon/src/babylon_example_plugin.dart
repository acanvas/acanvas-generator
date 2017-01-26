part of babylon_example;

class BabylonExamplePlugin extends AbstractRdPlugin {
  int sorting;
  BabylonExamplePlugin(this.sorting) : super(990) {}

  @override
  void configureScreens() {
    addScreen(BabylonExampleScreenIDs.BABYLON_HOME, () => new BabylonHome(BabylonExampleScreenIDs.BABYLON_HOME), transition: EffectIDs.DEFAULT, tree_order: sorting);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  
  }
}
