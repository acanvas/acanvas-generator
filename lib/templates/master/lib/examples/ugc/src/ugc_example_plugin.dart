part of ugc_example;

class UGCExamplePlugin extends AbstractRdPlugin {
  int sorting;
  UGCExamplePlugin(this.sorting) : super(940) {}

  @override
  void configureScreens() {
    addScreen(UGCExampleScreenIDs.UGCHOME, () => new UGCHome(UGCExampleScreenIDs.UGCHOME),
        transition: EffectIDs.DEFAULT, tree_order: sorting);
    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //

    addLayer(UGCExampleScreenIDs.UGC_LAYER_UPLOAD, () => new UGCUpload(UGCExampleScreenIDs.UGC_LAYER_UPLOAD),
        transition: EffectIDs.DEFAULT_MODAL, tree_parent: sorting);

    addLayer(UGCExampleScreenIDs.UGC_LAYER_VIEW, () => new UGCView(UGCExampleScreenIDs.UGC_LAYER_VIEW),
        transition: EffectIDs.DEFAULT_MODAL, tree_parent: sorting);

    addLayer(UGCExampleScreenIDs.UGC_LAYER_REGISTER, () => new UGCRegister(UGCExampleScreenIDs.UGC_LAYER_REGISTER),
        transition: EffectIDs.DEFAULT_MODAL, tree_parent: sorting);
  }
}
