part of physics_example;

class PhysicsExamplePlugin extends AbstractAcPlugin {
  int sorting;
  PhysicsExamplePlugin(this.sorting) : super(900 + sorting) {}

  @override
  void configureScreens() {
    addScreen(PhysicsExampleScreenIDs.PAPER_PHYSICS,
        () => new MdPhysics(PhysicsExampleScreenIDs.PAPER_PHYSICS),
        transition: EffectIDs.DEFAULT, tree_order: sorting);
  }
}
