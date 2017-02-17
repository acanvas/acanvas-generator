part of material_example;

class MaterialExamplePlugin extends AbstractRdPlugin {
  int sorting;
  MaterialExamplePlugin(this.sorting) : super(920) {}

  @override
  void configureScreens() {
    addScreen(MaterialExampleScreenIDs.MATERIAL_HOME, () => new MaterialHome(MaterialExampleScreenIDs.MATERIAL_HOME),
        transition: EffectIDs.DEFAULT, tree_order: sorting);
    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //

    //App Bar 20
    addScreen(MaterialExampleScreenIDs.PAPER_APP_BAR_EXAMPLE,
        () => new MdAppBarExample(MaterialExampleScreenIDs.PAPER_APP_BAR_EXAMPLE),
        transition: EffectIDs.DEFAULT, tree_order: 20, tree_parent: sorting);
    //Buttons 30
    addScreen(MaterialExampleScreenIDs.PAPER_BUTTONS, () => new MdButtons(MaterialExampleScreenIDs.PAPER_BUTTONS),
        transition: EffectIDs.DEFAULT, tree_order: 30, tree_parent: sorting);
    addScreen(MaterialExampleScreenIDs.PAPER_FABS, () => new MdFabs(MaterialExampleScreenIDs.PAPER_FABS),
        transition: EffectIDs.DEFAULT, tree_order: 31, tree_parent: sorting);
    addScreen(
        MaterialExampleScreenIDs.PAPER_CHECKBOXES, () => new MdCheckboxes(MaterialExampleScreenIDs.PAPER_CHECKBOXES),
        transition: EffectIDs.DEFAULT, tree_order: 32, tree_parent: sorting);
    addScreen(MaterialExampleScreenIDs.PAPER_RADIO_BUTTONS,
        () => new MdRadioButtons(MaterialExampleScreenIDs.PAPER_RADIO_BUTTONS),
        transition: EffectIDs.DEFAULT, tree_order: 33, tree_parent: sorting);
    addScreen(MaterialExampleScreenIDs.PAPER_TOGGLES, () => new MdToggles(MaterialExampleScreenIDs.PAPER_TOGGLES),
        transition: EffectIDs.SWIPE, tree_order: 34, tree_parent: sorting);
    //TODO Date Picker 40
    //TODO Dialog 50
    addScreen(MaterialExampleScreenIDs.PAPER_DIALOGS, () => new MdDialogs(MaterialExampleScreenIDs.PAPER_DIALOGS),
        transition: EffectIDs.SWIPE, tree_order: 60, tree_parent: sorting);
    /*addLayer(ScreenIDs.LAYER_PHOTO, () => new Layer(ScreenIDs.LAYER_PHOTO), transition: EffectIDs.DEFAULT_MODAL, tree_parent: 60, tree_parent: sorting);*/
    //TODO Dropdown Menu 70
    //TODO Icons 80
    addScreen(MaterialExampleScreenIDs.PAPER_ICON_BUTTONS,
        () => new MdIconButtons(MaterialExampleScreenIDs.PAPER_ICON_BUTTONS),
        transition: EffectIDs.DEFAULT, tree_order: 90, tree_parent: sorting);
    //TODO Menu 100
    //TODO Progress 110
    //TODO Sliders 120
    //TODO Tabs 130
    //Text 140
    addScreen(MaterialExampleScreenIDs.PAPER_TEXTS, () => new MdTexts(MaterialExampleScreenIDs.PAPER_TEXTS),
        transition: EffectIDs.DEFAULT, tree_order: 140, tree_parent: sorting);
    //TODO Time Picker 150
    //Toasts 160
    addScreen(MaterialExampleScreenIDs.PAPER_TOASTS, () => new MdToasts(MaterialExampleScreenIDs.PAPER_TOASTS),
        transition: EffectIDs.DEFAULT, tree_order: 160, tree_parent: sorting);
    //TODO Toolbars 170
    //3D & Shaders 175
    addScreen(MaterialExampleScreenIDs.SHADER_EXAMPLE, () => new ShaderExample(MaterialExampleScreenIDs.SHADER_EXAMPLE),
        transition: EffectIDs.SWIPE, tree_order: 175, tree_parent: sorting);
  }
}
