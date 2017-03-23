part of facebook_example;

class FacebookExamplePlugin extends AbstractRdPlugin {
  int sorting;
  FacebookExamplePlugin(this.sorting) : super(900 + sorting) {}

  @override
  void configureScreens() {
    addScreen(
        FacebookExampleScreenIDs.FACEBOOK_EXAMPLE, () => new FacebookHome(FacebookExampleScreenIDs.FACEBOOK_EXAMPLE),
        transition: EffectIDs.DEFAULT, tree_order: sorting);
    addScreen(
        FacebookExampleScreenIDs.FACEBOOK_ALBUMS, () => new FacebookAlbums(FacebookExampleScreenIDs.FACEBOOK_ALBUMS),
        transition: EffectIDs.DEFAULT, tree_parent: -2);
    addScreen(
        FacebookExampleScreenIDs.FACEBOOK_PHOTOS, () => new FacebookPhotos(FacebookExampleScreenIDs.FACEBOOK_PHOTOS),
        transition: EffectIDs.DEFAULT, tree_parent: -2);
  }
}
