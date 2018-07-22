part of facebook_example;

@retain
class FacebookHome extends AbstractReflowScreen implements IFBModelAware {
  static const int WIDTH_BUTTON = 240;

  MdWrap _wrap01;

  FBModel _fbModel;
  @override
  void set fbModel(FBModel fbModel) {
    _fbModel = fbModel;
  }

  FacebookHome(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _wrap01 = Theme.getWrap(label: getProperty("col01"), align: AlignH.CENTER);
    _wrap01.addChild(Theme.getButton(label: getProperty("button01"))
      ..submitEvent = new AcSignal(
          FBEvents.USER_LOGIN,
          new FacebookLoginVO(
              nextSignal: new AcSignal(
                  StateEvents.ADDRESS_SET,
                  getProperty(FacebookExampleScreenIDs.FACEBOOK_ALBUMS + ".url",
                      true)))));
    _wrap01.addChild(Theme.getButton(label: getProperty("invite.button"))
      ..submitEvent = new AcSignal(
          FBEvents.PROMPT_INVITE,
          new VOFBInvite(
              getProperty("invite.dialog.title"),
              getProperty("invite.dialog.copy"),
              getProperty("invite.payload"))));
    _wrap01.addChild(Theme.getButton(label: getProperty("share.button"))
      ..submitEvent = new AcSignal(
          FBEvents.PROMPT_SHARE,
          new VOFBShare(VOFBShare.TYPE_SHARE_OG, getProperty("share.message"),
              getProperty("share.link"), getProperty("share.image"))));
    if (_fbModel.userAlbums != null && !_fbModel.userAlbums.isEmpty) {
      _uploadScreenshotToFacebook(_fbModel.userAlbums);
    }
    _wrap01.span(300, 340);

    reflow.addChild(_wrap01);

    addChild(reflow);
    onInitComplete();
  }

  void _uploadScreenshotToFacebook(List albums) {
    FBAlbumVO firstAlbum = albums.where((e) => e.can_upload).first;
    _wrap01.addChild(Theme.getButton(label: getProperty("upload.button"))
      ..submitEvent = new AcSignal(
          FBEvents.PHOTO_UPLOAD,
          new VOFBPhotoUpload(getProperty("upload.filename"), firstAlbum.id,
              bmd: Assets.acanvas_logo_wide_bnw, message: getProperty("upload.message"))));
  }
}
