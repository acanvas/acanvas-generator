part of gaf_example;

class GAFExamplePlugin extends AbstractRdPlugin {
  int sorting;
  GAFExamplePlugin(this.sorting) : super(900 + sorting) {}

  @override
  void configureScreens() {
    addScreen(GAFExampleScreenIDs.GAF_HOME, () => new GafHome(GAFExampleScreenIDs.GAF_HOME),
        transition: EffectIDs.DEFAULT, tree_order: sorting);

    addScreen(GAFExampleScreenIDs.GAF_BUNDLE_ZIP, () => new GafBundleZip(GAFExampleScreenIDs.GAF_BUNDLE_ZIP),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(GAFExampleScreenIDs.GAF_FIREMAN, () => new GafFireman(GAFExampleScreenIDs.GAF_FIREMAN),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(GAFExampleScreenIDs.GAF_GUN_SWAP, () => new GafGunSwap(GAFExampleScreenIDs.GAF_GUN_SWAP),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(GAFExampleScreenIDs.GAF_NAMED_PARTS, () => new GafNamedParts(GAFExampleScreenIDs.GAF_NAMED_PARTS),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(GAFExampleScreenIDs.GAF_ROCKET, () => new GafRocket(GAFExampleScreenIDs.GAF_ROCKET),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(GAFExampleScreenIDs.GAF_SEQUENCES, () => new GafSequences(GAFExampleScreenIDs.GAF_SEQUENCES),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(GAFExampleScreenIDs.GAF_SKELETON, () => new GafSkeleton(GAFExampleScreenIDs.GAF_SKELETON),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(GAFExampleScreenIDs.GAF_SLOT_MACHINE, () => new GafSlotMachine(GAFExampleScreenIDs.GAF_SLOT_MACHINE),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(GAFExampleScreenIDs.GAF_SOUND, () => new GafSound(GAFExampleScreenIDs.GAF_SOUND),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
