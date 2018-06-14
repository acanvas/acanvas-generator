part of isometric_example;

class IsometricExamplePlugin extends AbstractRdPlugin {
  int sorting;
  IsometricExamplePlugin(this.sorting) : super(900 + sorting) {}

  @override
  void configureScreens() {
    addScreen(IsometricExampleScreenIDs.GOBLINS,
        () => new IsometricGoblins(IsometricExampleScreenIDs.GOBLINS),
        transition: EffectIDs.DEFAULT, tree_order: sorting);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
