part of isometric_example;

class IsoApplication extends Sprite {
  IsoApplication() {
    var box = new IsoBox();
    box.styleType = RenderStyleType.SHADED;
    box.fills = [
      new SolidColorFill(0xff0000, .5),
      new SolidColorFill(0x00ff00, .5),
      new SolidColorFill(0x0000ff, .5),
      new SolidColorFill(0xff0000, .5),
      new SolidColorFill(0x00ff00, .5),
      new SolidColorFill(0x0000ff, .5)
    ];
    box.setSize(25, 50, 40);
    box.moveTo(0, 0, 0);

    var grid = new IsoGrid();
    grid.showOrigin = true;
    grid.setGridSize(10, 10);
    grid.moveTo(0, 0, 0);

    var scene = new IsoScene();
    scene.hostContainer = this;
    scene.addChild(grid);
    scene.addChild(box);
    scene.isoRender();
  }
}
