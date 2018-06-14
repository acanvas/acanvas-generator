part of moppiflower_example;

class SoundAnalyzer {
  int _bands = 16;
  AnalyserNode _analyzer;
  Sound _audio;
  SoundChannel _soundChannel;

  bool _loaded = false;

  SoundAnalyzer() : super() {
    if (Rd.IOS) {
      _startWebAudio();
      /*
      TEST B:
      if (SoundMixer.engine != "Mock")
        AudioElementSound.load("assets/moppiflower/Santogold-Starstruck-Southbound-Hangers-Remix.mp3").then((sound) {
          _audio = sound;
          _start();
        });
       */
    } else {
      _startWebAudio();
    }
  }

  void _startIos() {
    _startWebAudio();
  }

  void _startWebAudio() {
    WebAudioApiSound
        .load(
            "assets/moppiflower/Santogold-Starstruck-Southbound-Hangers-Remix.mp3")
        .then((sound) {
      _audio = sound;
      _start();
    });
  }

  void _start() {
    _analyzer = WebAudioApiMixer.audioContext.createAnalyser();
    _analyzer.fftSize = 512; //32 - 32768

    _soundChannel = _audio.play();
    SoundMixer.webAudioApiMixer.inputNode.connectNode(_analyzer);
    //WebAudioApiMixer.audioContext.destination.connectNode(_analyzer);
    //_analyzer.connectNode(WebAudioApiMixer.audioContext.destination);

    _loaded = true;
  }

  void update(MoppiFlowerModel m, {BoxSprite s: null}) {
    if (!_loaded) {
      return;
    }

    Uint8List arr = new Uint8List(_analyzer.frequencyBinCount);
    _analyzer.getByteFrequencyData(arr);

    List<int> bands = new List.filled(_bands, 0);
    for (int i = 0; i < arr.length; i++) {
      int index = (i / (arr.length / _bands)).floor();
      bands[index] += arr[i];
    }

    double chartMax = bands.reduce(math.max).toDouble();
    double chartMin = bands.reduce(math.min).toDouble();

    m.bass = (bands[3] - chartMin) / chartMax;
    m.mid = (bands[11] - chartMin) / chartMax;
    m.high = 2 * (bands[14] - chartMin) / chartMax;

    if (m.bass.isNaN) m.bass = 0.0;
    if (m.mid.isNaN) m.mid = 0.0;
    if (m.high.isNaN) m.high = 0.5;

    //print("factors - b:${m.bass} , m:${m.mid} , h:${m.high}");

    if (s != null) {
      double y, h;
      int x;
      int w = (s.spanWidth / bands.length).round();
      for (int i = 0; i < bands.length; i++) {
        x = i * w;
        h = 240.0 * ((bands[i] - chartMin) / chartMax);
        y = s.spanHeight - h;
        s.graphics..rect(x, y, w, h);
      }
      s.graphics.strokeColor(Color.White, 2.0);
    }
  }

  void dispose() {
    _soundChannel.stop();
    _audio = null;
  }
}
