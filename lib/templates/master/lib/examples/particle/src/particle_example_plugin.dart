part of particle_example;

class ParticleExamplePlugin extends AbstractRdPlugin {
  int sorting;
  ParticleExamplePlugin(this.sorting) : super(910) {}

  @override
  void configureScreens() {
    addScreen(ParticleExampleScreenIDs.PARTICLE, () => new ParticleExample(ParticleExampleScreenIDs.PARTICLE),
        transition: EffectIDs.DEFAULT, tree_order: sorting);

    // ## SCREEN INSERTION PLACEHOLDER - DO NOT REMOVE ## //
  }
}
