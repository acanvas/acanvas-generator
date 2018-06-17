part of google_example;

class GoogleExamplePlugin extends AbstractAcPlugin {
  int sorting;
  GoogleExamplePlugin(this.sorting) : super(900 + sorting) {}

  @override
  void configureScreens() {
    addScreen(GoogleExampleScreenIDs.GOOGLE_EXAMPLE,
        () => new GoogleExample(GoogleExampleScreenIDs.GOOGLE_EXAMPLE),
        transition: EffectIDs.DEFAULT, tree_order: sorting);
    addScreen(GoogleExampleScreenIDs.GOOGLE_FRIENDS,
        () => new GoogleFriends(GoogleExampleScreenIDs.GOOGLE_FRIENDS),
        transition: EffectIDs.DEFAULT, tree_parent: -2);
  }
}
