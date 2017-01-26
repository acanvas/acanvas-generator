part of stagexl_example;

class Curve extends Shape implements Animatable {
  CurveData _curveData1;
  CurveData _curveData2;

  GraphicsCommandMoveTo _moveto;
  GraphicsCommandBezierCurveTo _bezier;
  GraphicsCommandStrokeColor _stroke;
  double _time = 0.0;

  Curve(CurveData curveData1, CurveData curveData2) {
    _curveData1 = curveData1;
    _curveData2 = curveData2;
    _moveto = this.graphics.moveTo(0, 0);
    _bezier = this.graphics.bezierCurveTo(0, 0, 0, 0, 0, 0);
    _stroke = this.graphics.strokeColor(Color.White, 15);
    this.advanceTime(0.0);
  }

  bool advanceTime(num delta) {
    var t = Transition.easeInOutCubic(min(_time += delta, 1.0));
    var p = new CurveData.interpolate(_curveData1, _curveData2, t);

    _moveto.x = p.x1;
    _moveto.y = p.y1;
    _bezier.controlX1 = p.controlX1;
    _bezier.controlY1 = p.controlY1;
    _bezier.controlX2 = p.controlX2;
    _bezier.controlY2 = p.controlY2;
    _bezier.endX = p.x2;
    _bezier.endY = p.y2;
    _stroke.width = p.width;
    _stroke.color = p.color;

    return true;
  }

  void animateTo(CurveData curveData) {
    _curveData1 = _curveData2;
    _curveData2 = curveData;
    _time = 0.0;
  }
}
