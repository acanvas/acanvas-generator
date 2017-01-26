part of bitmapfont_example;

class BitmapFontExamplePlugin extends AbstractRdPlugin {
  int sorting;
  BitmapFontExamplePlugin(this.sorting) : super(910) {}

  @override
  void configureScreens() {
    addScreen(BitmapFontExampleScreenIDs.BITMAP_FONT_HOME, () => new BitmapFontHome(BitmapFontExampleScreenIDs.BITMAP_FONT_HOME), transition: EffectIDs.DEFAULT, tree_order: sorting);

    addScreen(BitmapFontExampleScreenIDs.SIMPLE, () => new BitmapfontSimple(BitmapFontExampleScreenIDs.SIMPLE),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);

    addScreen(BitmapFontExampleScreenIDs.TEXTURE_ATLAS,
        () => new BitmapfontTextureAtlas(BitmapFontExampleScreenIDs.TEXTURE_ATLAS),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);

    addScreen(BitmapFontExampleScreenIDs.DISTANCE_FIELD,
        () => new BitmapfontDistanceField(BitmapFontExampleScreenIDs.DISTANCE_FIELD),
        transition: EffectIDs.DEFAULT, tree_parent: sorting);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  
  }
}
