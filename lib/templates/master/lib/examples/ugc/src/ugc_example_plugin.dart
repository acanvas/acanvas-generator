part of ugc_example;

class UGCExamplePlugin extends AbstractRdPlugin {
  int sorting;
  UGCExamplePlugin(this.sorting) : super(940) {}

  @override
  void configureScreens() {
    addScreen(UGCExampleScreenIDs.UGC_GALLERY, () => new UGCGallery(UGCExampleScreenIDs.UGC_GALLERY),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);

    addScreen(UGCExampleScreenIDs.UGCHOME, () => new UGCHome(UGCExampleScreenIDs.UGCHOME),
        transition: EffectIDs.DEFAULT, tree_order: sorting);
    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
