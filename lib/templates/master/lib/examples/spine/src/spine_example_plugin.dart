part of spine_example;

class SpineExamplePlugin extends AbstractRdPlugin {
  int sorting;
  SpineExamplePlugin(this.sorting) : super(900 + sorting) {}

  @override
  void configureScreens() {
    addScreen(SpineExampleScreenIDs.SPINE_HOME, () => new SpineHome(SpineExampleScreenIDs.SPINE_HOME),
        transition: EffectIDs.DEFAULT, tree_order: sorting);
    addScreen(SpineExampleScreenIDs.GOBLINS_FFD, () => new SpineGoblinsFfd(SpineExampleScreenIDs.GOBLINS_FFD),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(SpineExampleScreenIDs.HERO, () => new SpineHero(SpineExampleScreenIDs.HERO),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(SpineExampleScreenIDs.POWERUP, () => new SpinePowerup(SpineExampleScreenIDs.POWERUP),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(SpineExampleScreenIDs.RAPTOR, () => new SpineRaptor(SpineExampleScreenIDs.RAPTOR),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(SpineExampleScreenIDs.BOY, () => new SpineBoy(SpineExampleScreenIDs.BOY),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(SpineExampleScreenIDs.BOY_MESH, () => new SpineBoyMesh(SpineExampleScreenIDs.BOY_MESH),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(SpineExampleScreenIDs.TANK, () => new SpineTank(SpineExampleScreenIDs.TANK),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(SpineExampleScreenIDs.TEXTURE_ATLAS, () => new SpineTextureAtlas(SpineExampleScreenIDs.TEXTURE_ATLAS),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(SpineExampleScreenIDs.VINE, () => new SpineVine(SpineExampleScreenIDs.VINE),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(SpineExampleScreenIDs.STRETCHY_MAN, () => new SpineStretchyMan(SpineExampleScreenIDs.STRETCHY_MAN),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
