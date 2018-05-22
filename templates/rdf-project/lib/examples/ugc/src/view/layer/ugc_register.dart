part of ugc_example;

/**
 * @author nilsdoehring
 */
class UGCRegister extends UGCAbstractLayer
    implements IFBModelAware, IGoogleModelAware {
  String _imageName;
  MdInput _user;
  MdInput _email;
  MdInput _pass;

  FBModel _fbModel;
  @override
  set fbModel(FBModel fbModel) {
    _fbModel = fbModel;
  }

  GoogleModel _googleModel;
  @override
  set googleModel(GoogleModel gModel) {
    _googleModel = gModel;
  }

  UGCRegister(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);

    _imageName =
        "ugc-${new DateTime.now().millisecondsSinceEpoch * (1 + new math.Random().nextDouble())}";

    _reflow.addChild(
        Theme.getHeadline(getProperty("headline"), color: Colors.BLACK));
    _reflow.addChild(Theme.getCopy(getProperty("copy"), color: Colors.BLACK));

    //social login
    _reflow.addChild(Theme.getHeadline(getProperty("social.headline"),
        size: 20, color: Colors.BLACK));
    _reflow.addChild(Theme.getButton(label: getProperty("button.fb"))
      ..submitEvent =
          new RdSignal(FBEvents.USER_LOGIN, new FacebookLoginVO(), _onFB));
    _reflow.addChild(Theme.getButton(label: getProperty("button.gplus"))
      ..submitEvent = new RdSignal(
          GoogleEvents.USER_LOGIN,
          new GoogleLoginVO(scopes: [
            getProperty("plugin.ugc.user.google.scopes.profile", true),
            getProperty("plugin.ugc.user.google.scopes.email", true)
          ]),
          _onGoogle));

    //normal signup with u/e/p
    _reflow.addChild(Theme.getHeadline(getProperty("normal.headline"),
        size: 20, color: Colors.BLACK));

    _user = Theme.getInput(
        label: getProperty("username"),
        required: getProperty("username.required"),
        name: "user");
    _reflow.addChild(_user);

    _reflow.addChild(Theme.getCopy(getProperty("email.desc"),
        color: Colors.BLACK, size: 14));
    _email = Theme.getInput(
        label: getProperty("email"),
        required: getProperty("email.required"),
        name: "user");
    _reflow.addChild(_email);

    _reflow.addChild(Theme.getCopy(getProperty("password.desc"),
        color: Colors.BLACK, size: 14));
    _pass = Theme.getInput(
        label: getProperty("password"),
        password: true,
        required: getProperty("password.required"),
        name: "user");
    _reflow.addChild(_pass);

    _reflow.addChild(
        Theme.getButton(label: getProperty("button.finish"), shadow: false)
          ..submitCallback = _onInputForm
          ..submitCallbackParams = []
          ..inheritSpan = false);

    onInitComplete();
  }

  void _onFB() {
    //todo GET_INFO

    _user.setText(_fbModel.user.name);
    _email.setText(_fbModel.user.email);
    _pass.disable();

    UGCUserDTO user = new UGCUserDTO();
    user.network = UGCUserDTO.NETWORK_FACEBOOK;
    user.name = _fbModel.user.name;
    user.pic = _fbModel.user.pic_square;
    user.uid = _fbModel.user.uid;
    user.locale = _fbModel.user.locale;

    new RdSignal(UGCEvents.USER_REGISTER, user).dispatch();

    UGCUserExtendedDTO ext = new UGCUserExtendedDTO();
    ext.uid = _fbModel.user.uid;
    ext.hash = _fbModel.user.email; //todo encrypt
    ext.email = _fbModel.user.email;
    ext.email_confirmed = 1;

    new RdSignal(UGCEvents.USER_REGISTER_EXTENDED, ext).dispatch();

    _createUGCItem();
  }

  void _onGoogle() {
    String middle = _googleModel.user.name.middleName == ""
        ? ""
        : _googleModel.user.name.middleName + " ";
    String username = _googleModel.user.name.givenName +
        " " +
        middle +
        _googleModel.user.name.familyName;
    _user.setText(username);
    _user.disable();
    String email = _googleModel.user.emails[0].value;
    _email.setText(email);
    _email.disable();
    _pass.disable();

    UGCUserDTO user = new UGCUserDTO();
    user.network = UGCUserDTO.NETWORK_GPLUS;
    user.name = username;
    user.pic = _googleModel.user.image.url;
    user.uid = _googleModel.user.id;
    user.locale = _googleModel.user.language;

    new RdSignal(UGCEvents.USER_REGISTER, user).dispatch();

    UGCUserExtendedDTO ext = new UGCUserExtendedDTO();
    ext.uid = _googleModel.user.id;
    ext.hash = email; //todo encrypt
    ext.email = email;
    ext.email_confirmed = 1;

    new RdSignal(UGCEvents.USER_REGISTER_EXTENDED, ext).dispatch();

    _createUGCItem();
  }

  void _onInputForm() {
    if (_pass.validate() && _user.validate() && _email.validate()) {
      UGCUserDTO user = new UGCUserDTO();
      user.network = UGCUserDTO.NETWORK_INPUTFORM;
      user.name = _user.getText();
      user.pic = null;
      user.uid = _email.getText();
      user.locale = RdConstants.MARKET;

      new RdSignal(UGCEvents.USER_REGISTER, user).dispatch();

      UGCUserExtendedDTO ext = new UGCUserExtendedDTO();
      ext.uid = _googleModel.user.id;
      ext.hash = _email.getText(); //todo encrypt
      ext.email = _email.getText();
      ext.email_confirmed = 1;

      new RdSignal(UGCEvents.USER_REGISTER_EXTENDED, ext).dispatch();

      _createUGCItem();
    }
  }

  void _createUGCItem() {
    UGCItemDTO itemDAO = new UGCItemDTO();
    itemDAO.title = "Test Image Title";
    itemDAO.description = "Test Image Description";

    UGCImageItemDTO imageDAO = new UGCImageItemDTO();
    imageDAO.url_big = _imageName + ".jpg";
    ;
    imageDAO.url_thumb = _imageName + "_thumb.jpg";
    imageDAO.w = 400;
    imageDAO.h = 400;

    itemDAO.type = UGCItemDTO.TYPE_IMAGE;
    itemDAO.type_dao = imageDAO;

    new RdSignal(UGCEvents.CREATE_ITEM, itemDAO, _uploadImage).dispatch();
  }

  void _uploadImage() {
    IOImageUploadVO vo = new IOImageUploadVO(_imageName, model.imageToUpload,
        getProperty("project.host.upload", true));
    new RdSignal(IOEvents.UPLOAD_IMAGE, vo, _onImageUploaded).dispatch();
  }

  void _onImageUploaded() {
    new RdSignal(StateEvents.ADDRESS_SET,
            getProperty("${UGCExampleScreenIDs.UGCHOME}.url", true))
        .dispatch();
  }
}
