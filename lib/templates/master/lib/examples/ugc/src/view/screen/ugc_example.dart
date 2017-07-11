part of ugc_example;

class UGCExample extends AbstractReflowScreen {
  static const int WIDTH_BUTTON = 240;

  MdWrap _wrap01;

  UGCExample(String id) : super(id) {}

  @override
  void init({Map<String, String> params: null}) {
    super.init(params: params);



    /*
    */

    addChild(reflow);
    onInitComplete();
  }
}
