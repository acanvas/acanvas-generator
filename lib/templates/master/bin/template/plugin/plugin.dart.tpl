part of @package@;

class @plugin@Plugin extends AbstractPlugin {
  @plugin@Plugin() : super(500) {
  }
  
  /**
   * Registers Commands with FrontController 
   * You can then access them from anywhere:
   * new RdSignal(@plugin@Events.SOME_COMMAND, optionalParam, optionalCompleteCallback).dispatch();
   */
  @override void configureCommands() {

    commandMap[@plugin@Events.INIT] = @plugin@PluginInitCommand;
    commandMap[@plugin@Events.SAMPLE] = @plugin@SampleCommand;
    // ## COMMAND INSERTION PLACEHOLDER - DO NOT REMOVE ## //


    /* Add this Plugin's Init Command to RdBootstrap Command Sequence */
    projectInitCommand = @plugin@Events.INIT;
  }

  /**
     * Register this Plugin's Model as injectable
     * Any class requiring this Model can implement I@plugin@ModelAware and the ObjectFactory will take care.
     * This is called Interface Injection, the only kind of injection available in Spring Dart so far.
     * Feel free to add more injectors. 
     */
  @override void configureInjectors() {
    RdContextUtil.registerInstance(objectFactory, @plugin@Constants.MODEL_@pluginUpperCase@, new @plugin@Model());
    objectFactory.addObjectPostProcessor(new @plugin@ModelInjector(objectFactory));
  }

}
