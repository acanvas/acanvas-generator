part of rockdot_template;

/*
 * This is the application's plugin.
 * It is set up the same way as any other plugin of Rockdot.
 */
class Project extends AbstractRdPlugin {
  static const String MODEL = "Project.MODEL";

  Project() : super(1000) {}

  /**
   * Registers Commands with FrontController
   * You can then access them from anywhere:
   * new RdSignal(ProjectEvents.SOME_COMMAND, optionalParam, optionalFunctionCallback).dispatch();
   */
  @override
  void configureCommands() {
    commandMap[ProjectEvents.APP_INIT] = () => new InitCommand();
    commandMap[StateEvents.MESSAGE_SHOW] = () => new MessageShowCommand();
    commandMap[StateEvents.MESSAGE_HIDE] = () => new MessageHideCommand();
    // ## COMMAND INSERTION PLACEHOLDER - DO NOT REMOVE ## //

    /* Add this Project's Init Command to RdBootstrap Command Sequence */
    projectInitCommand = ProjectEvents.APP_INIT;
  }

  /**
   * Register this Project's Model as injectable
   * Any class requiring this Model can implement IModelAware and the ObjectFactory will take care.
   * This is called Interface Injection, the only kind of injection available in Spring Dart so far.
   * Feel free to add more injectors. Also have a look at the Plugins defined in bootstrap.dart
   */
  @override
  void configureInjectors() {
    RdContextUtil.registerInstance(objectFactory, MODEL, new Model());
    objectFactory.addObjectPostProcessor(new ModelInjector(objectFactory));
  }

  /**
   * Define Screen Transitions here
   */
  @override
  void configureTransitions() {
    addTransition(EffectIDs.DEFAULT, new BasicEffect(), .4, ScreenConstants.TRANSITION_PARALLEL);
    addTransition(EffectIDs.DEFAULT_MODAL, new CenterZoomTransition(), .5);
    addTransition(EffectIDs.SWIPE, new HLeftSwipeTransition(), .6);
  }

  /**
   * The screens (read: pages) used by this Project.
   * In Rockdot Actionscript, these were defined in XML.
   * We have yet to come up with an approach for Dart - XML doesn't make sense.
   */
  @override
  void configureScreens() {
    addScreen(ScreenIDs.HOME, () => new Home(ScreenIDs.HOME), tree_order: 0, tree_parent: -1);
    //addScreen(ScreenIDs.TWO, () => new Two(ScreenIDs.TWO), tree_order: 11, tree_parent: 1);
    //addLayer(ScreenIDs.LAYER_PHOTO, () => new Layer(ScreenIDs.LAYER_PHOTO), transition: EffectIDs.DEFAULT_MODAL, tree_parent: 60);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  
  }
}
