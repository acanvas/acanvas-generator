part of stagexl_example;

// ---------------------------------------------------

class CubeFace extends Sprite3D {

  CubeFace(int color, BitmapData bitmapData) {

    Bitmap back = new Bitmap(new BitmapData(150, 150, color));
    Bitmap icon = new Bitmap(bitmapData);
    this.addChild(back..alignPivot());
    this.addChild(icon..alignPivot());

    // set perspective projection to none because this Sprite3D will
    // be inside of another Sprite3D (the cube) which will define the
    // perspective projection for all its children.
    this.perspectiveProjection = new PerspectiveProjection.none();

    // hide the CubeFace if it isn't forward facing
    this.onEnterFrame.listen(_onEnterFrame);
  }

  void _onEnterFrame(EnterFrameEvent e) {
    this.visible = this.isForwardFacing;
  }
}