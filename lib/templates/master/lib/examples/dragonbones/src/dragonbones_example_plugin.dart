part of dragonbones_example;

class DragonBonesExamplePlugin extends AbstractRdPlugin {
  int sorting;
  DragonBonesExamplePlugin(this.sorting) : super(910) {}

  @override
  void configureScreens() {
    addScreen(DragonBonesExampleScreenIDs.DRAGONBONES_HOME, () => new DragonbonesHome(DragonBonesExampleScreenIDs.DRAGONBONES_HOME), transition: EffectIDs.DEFAULT, tree_order: sorting);

    addScreen(DragonBonesExampleScreenIDs.DEMON, () => new DragonBonesDemon(DragonBonesExampleScreenIDs.DEMON),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(
        DragonBonesExampleScreenIDs.DRAGON_NEW, () => new DragonBonesDragonNew(DragonBonesExampleScreenIDs.DRAGON_NEW),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(
        DragonBonesExampleScreenIDs.SWORDS_MAN, () => new DragonBonesSwordsMan(DragonBonesExampleScreenIDs.SWORDS_MAN),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(DragonBonesExampleScreenIDs.UBBIE, () => new DragonBonesUbbie(DragonBonesExampleScreenIDs.UBBIE),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  
  }
}
