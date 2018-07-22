part of acanvas_template;

///  The AcBootstrap class manages instantiation of and programmatic additions to our [ApplicationContext].
///  Most often, you will instantiate and load this class in [Entrypoint]

class AcBootstrap extends AbstractAcBootstrap {
  int _exampleOrder;

  AcBootstrap(Stage stage) : super(stage) {
    // Defaults are injected from public.properties
    // TODO add support for setting these via GET

    LoaderInfo loaderInfo = new LoaderInfo();
    loaderInfo.language = "";
    loaderInfo.country = "";
    loaderInfo.market = "";
    AcConstants.setLoaderInfo(loaderInfo);

    //----------------------------

    // The Property Files we want to load initially

    propertyFiles = [
      "config/locale/${AcConstants.LANGUAGE}.properties",
      "config/project.properties"
    ];

    // The Plugins we want to use
    Plugins ps = new Plugins();
    plugins = ps.plugins;
  }

  /// Load Webfonts and Assets

  Future load() async {
    // Add Fonts to load
    AcFontUtil.addFont(Fonts.ROBOTO_LOADSTRING);

    await Assets.load();
    // TODO detect internet connectivity
    await AcFontUtil.loadFonts();
    await loadApplicationContext();
  }
}
