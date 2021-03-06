part of particle_example;

class ParticleExamplePlugin extends AbstractAcPlugin {
  int sorting;
  ParticleExamplePlugin(this.sorting) : super(900 + sorting) {}

  @override
  void configureScreens() {
    addScreen(ParticleExampleScreenIDs.PARTICLE,
        () => new ParticleExample(ParticleExampleScreenIDs.PARTICLE),
        transition: EffectIDs.DEFAULT, tree_order: sorting);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
