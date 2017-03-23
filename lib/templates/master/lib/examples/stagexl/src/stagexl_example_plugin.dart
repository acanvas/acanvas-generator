part of stagexl_example;

class StagexlExamplePlugin extends AbstractRdPlugin {
  int sorting;
  StagexlExamplePlugin(this.sorting) : super(910) {}

  @override
  void configureScreens() {
    addScreen(StageXLExampleScreenIDs.STAGE_XLHOME, () => new StageXLHome(StageXLExampleScreenIDs.STAGE_XLHOME),
        transition: EffectIDs.DEFAULT, tree_order: sorting);

    addScreen(StageXLExampleScreenIDs.BASIC_BITMAPDATA_HIDPI,
        () => new BitmapDataHiDPI(StageXLExampleScreenIDs.BASIC_BITMAPDATA_HIDPI),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    if(Rd.WEBGL){
      addScreen(StageXLExampleScreenIDs.BASIC_SPRITE3D, () => new Sprite3DExample(StageXLExampleScreenIDs.BASIC_SPRITE3D),
          transition: EffectIDs.DEFAULT, tree_parent: sorting);
    }
    addScreen(StageXLExampleScreenIDs.NORMAL_MAP_FILTER, () => new MapFilter(StageXLExampleScreenIDs.NORMAL_MAP_FILTER),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(StageXLExampleScreenIDs.BEZIER, () => new BezierExample(StageXLExampleScreenIDs.BEZIER),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(StageXLExampleScreenIDs.DRAG, () => new DragExample(StageXLExampleScreenIDs.DRAG),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(StageXLExampleScreenIDs.LOGO, () => new Logo(StageXLExampleScreenIDs.LOGO),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);
    addScreen(StageXLExampleScreenIDs.MEMORY, () => new MemoryExample(StageXLExampleScreenIDs.MEMORY),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
