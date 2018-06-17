part of moppiflower_example;

class MoppiFlowerExamplePlugin extends AbstractAcPlugin {
  static const String MODEL = "MoppiFlowerExample.MODEL";

  int sorting;
  MoppiFlowerExamplePlugin(this.sorting) : super(900 + sorting) {}

  @override
  void configureScreens() {
    addScreen(MoppiFlowerExampleScreenIDs.MOPPI_DEMO,
        () => new MoppiFlowerExample(MoppiFlowerExampleScreenIDs.MOPPI_DEMO),
        transition: EffectIDs.DEFAULT, tree_order: sorting);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
