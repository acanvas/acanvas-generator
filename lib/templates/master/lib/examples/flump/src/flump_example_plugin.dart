part of flump_example;

class FlumpExamplePlugin extends AbstractRdPlugin {
  int sorting;
  FlumpExamplePlugin(this.sorting) : super(910) {}

  @override
  void configureScreens() {
    addScreen(FlumpExampleScreenIDs.GOBLINS, () => new FlumpGuy(FlumpExampleScreenIDs.GOBLINS),
        transition: EffectIDs.DEFAULT, tree_order: 500);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
