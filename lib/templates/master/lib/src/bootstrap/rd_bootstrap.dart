part of rockdot_template;

///  The RdBootstrap class manages instantiation of and programmatic additions to our [ApplicationContext].
///  Most often, you will instantiate and load this class in [Entrypoint]

class RdBootstrap extends AbstractRdBootstrap {
  int _exampleOrder;

  RdBootstrap(Stage stage) : super(stage) {
    // Defaults are injected from public.properties
    // TODO add support for setting these via GET

    LoaderInfo loaderInfo = new LoaderInfo();
    loaderInfo.language = "@project.default.language@";
    loaderInfo.country = "@project.default.country@";
    loaderInfo.market = "@project.default.market@";
    RdConstants.setLoaderInfo(loaderInfo);

    //----------------------------

    // The Property Files we want to load initially

    propertyFiles = ["config/locale/${RdConstants.LANGUAGE}.properties", "config/project.properties"];

    // The Plugins we want to use
    Plugins ps = new Plugins();
    plugins = ps.plugins;
  }

  /// Load Webfonts and Assets

  Future load() async {
    // Add Fonts to load
    RdFontUtil.addFont(Fonts.ROBOTO_LOADSTRING);

    await Assets.load();
    await RdFontUtil.loadFonts();
    await loadApplicationContext();
  }
}
