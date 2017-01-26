part of particle_example;

class ParticleExample extends AbstractReflowScreen {
  ResourceManager _resourceManager;

  num _originalTextWidth;

  ParticleEmitter _particleEmitter;

  ParticleExample(String id) : super(id) {}

  /// This is the place where you add anything to this method that needs initialization.
  /// This especially applies to members of the display list.

  @override
  void init({Map params: null}) {
    super.init(params: params);

    //-------------------------

    var particleConfig = {
      "maxParticles": 2000,
      "duration": 0,
      "lifeSpan": 0.7,
      "lifespanVariance": 0.2,
      "startSize": 16,
      "startSizeVariance": 10,
      "finishSize": 53,
      "finishSizeVariance": 11,
      "shape": "circle",
      "emitterType": 0,
      "location": {"x": 0, "y": 0},
      "locationVariance": {"x": 5, "y": 5},
      "speed": 100,
      "speedVariance": 33,
      "angle": 0,
      "angleVariance": 360,
      "gravity": {"x": 0, "y": 0},
      "radialAcceleration": 20,
      "radialAccelerationVariance": 0,
      "tangentialAcceleration": 10,
      "tangentialAccelerationVariance": 0,
      "minRadius": 0,
      "maxRadius": 100,
      "maxRadiusVariance": 0,
      "rotatePerSecond": 0,
      "rotatePerSecondVariance": 0,
      "compositeOperation": "source-over",
      "startColor": {"red": 1, "green": 0.74, "blue": 0, "alpha": 1},
      "finishColor": {"red": 1, "green": 0, "blue": 0, "alpha": 0}
    };

    _particleEmitter = new ParticleEmitter(particleConfig);
    _particleEmitter.setEmitterLocation(spanWidth / 2, spanHeight / 2);
    addChild(_particleEmitter);
    Rd.JUGGLER.add(_particleEmitter);

    //-------------------------

    var mouseEventListener = (me) {
      if (me.buttonDown) _particleEmitter.setEmitterLocation(me.localX, me.localY);
    };

    var glassPlate = new GlassPlate(spanWidth, spanHeight);
    glassPlate.onMouseDown.listen(mouseEventListener);
    glassPlate.onMouseMove.listen(mouseEventListener);
    addChild(glassPlate);

    addChild(reflow);

    onInitComplete();
  }

  /// Positioning logic goes here. Use spanWidth and spanHeight to find out about available space.

  @override
  void refresh() {
    super.refresh();
  }

  /// Put anything here that needs special disposal.
  /// Note that the super function already takes care of display objects.

  @override
  void dispose({bool removeSelf: true}) {
    Rd.JUGGLER.remove(_particleEmitter);
    super.dispose();
  }

  /// Set spanWidth and spanHeight according to calculations in Dimensions class.

  @override
  void span(num spanWidth, num spanHeight, {bool refresh: true}) {
    super.span(spanWidth, spanHeight, refresh: refresh);
  }

  /// Use this in case all your fade in / fade out stuff is the same for all screens

  @override
  void appear({double duration: MLifecycle.APPEAR_DURATION_DEFAULT}) {
    super.appear(duration: duration);
  }

  @override
  void disappear({double duration: MLifecycle.DISAPPEAR_DURATION_DEFAULT, bool autoDispose: false}) {
    super.disappear(duration: duration, autoDispose: autoDispose);
  }
}
