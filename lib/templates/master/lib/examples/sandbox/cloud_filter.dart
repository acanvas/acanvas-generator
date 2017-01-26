part of maximal;

class CloudFilter extends BitmapFilter {
  final List<int> _renderPassSources = new List<int>();
  final List<int> _renderPassTargets = new List<int>();

  CloudFilter() {}

  //---------------------------------------------------------------------------

  BitmapFilter clone() {
    return new CloudFilter();
  }

  List<int> get renderPassSources => _renderPassSources;
  List<int> get renderPassTargets => _renderPassTargets;

  //---------------------------------------------------------------------------

  void apply(BitmapData bitmapData, [Rectangle<int> rectangle]) {}

  //---------------------------------------------------------------------------

  void renderFilter(RenderState renderState, RenderTextureQuad renderTextureQuad, int pass) {
    RenderContextWebGL renderContext = renderState.renderContext;
    RenderTexture renderTexture = renderTextureQuad.renderTexture;

    CloudFilterProgram renderProgram =
        renderContext.getRenderProgram(r"$CloudFilterProgram", () => new CloudFilterProgram());

    renderContext.activateRenderProgram(renderProgram);
    renderContext.activateRenderTexture(renderTexture);

    renderProgram.renderCloudFilterQuad();
  }
}

class CloudFilterProgram extends RenderProgram {
  RenderBufferVertex _renderBufferVertex;

  //---------------------------------------------------------------------------
  // aVertexPosition:   Float32(x), Float32(y)
  // aVertexTextCoord:  Float32(u), Float32(v)
  //---------------------------------------------------------------------------

  String get vertexShaderSource => """

    """;

  String get fragmentShaderSource => """
    #define TAU 6.28318530718

    const vec3 BackColor	= vec3(0.0, 0.4, 0.58);
    const vec3 CloudColor	= vec3(0.18,0.70,0.87);


    float Func(float pX)
    {
      return 0.6*(0.5*sin(0.1*pX) + 0.5*sin(0.553*pX) + 0.7*sin(1.2*pX));
    }


    float FuncR(float pX)
    {
      return 0.5 + 0.25*(1.0 + sin(mod(40.0*pX, TAU)));
    }


    float Layer(vec2 pQ, float pT)
    {
      vec2 Qt = 3.5*pQ;
      pT *= 0.5;
      Qt.x += pT;

      float Xi = floor(Qt.x);
      float Xf = Qt.x - Xi -0.5;

      vec2 C;
      float Yi;
      float D = 1.0 - step(Qt.y,  Func(Qt.x));

      // Disk:
      Yi = Func(Xi + 0.5);
      C = vec2(Xf, Qt.y - Yi );
      D =  min(D, length(C) - FuncR(Xi+ pT/80.0));

      // Previous disk:
      Yi = Func(Xi+1.0 + 0.5);
      C = vec2(Xf-1.0, Qt.y - Yi );
      D =  min(D, length(C) - FuncR(Xi+1.0+ pT/80.0));

      // Next Disk:
      Yi = Func(Xi-1.0 + 0.5);
      C = vec2(Xf+1.0, Qt.y - Yi );
      D =  min(D, length(C) - FuncR(Xi-1.0+ pT/80.0));

      return min(1.0, D);
    }



    void main() {
      // Setup:
      vec2 UV = 2.0*(fragCoord.xy - iResolution.xy/2.0) / min(iResolution.x, iResolution.y);

      // Render:
      vec3 Color= BackColor;

      for(float J=0.0; J<=1.0; J+=0.2)
      {
        // Cloud Layer:
        float Lt =  iGlobalTime*(0.5  + 2.0*J)*(1.0 + 0.1*sin(226.0*J)) + 17.0*J;
        vec2 Lp = vec2(0.0, 0.3+1.5*( J - 0.5));
        float L = Layer(UV + Lp, Lt);

        // Blur and color:
        float Blur = 4.0*(0.5*abs(2.0 - 5.0*J))/(11.0 - 5.0*J);

        float V = mix( 0.0, 1.0, 1.0 - smoothstep( 0.0, 0.01 +0.2*Blur, L ) );
        vec3 Lc=  mix( CloudColor, vec3(1.0), J);

        Color =mix(Color, Lc,  V);
      }

      gl_FragColor = vec4(Color, 1.0);
    }
    """;

  //---------------------------------------------------------------------------

  @override
  void activate(RenderContextWebGL renderContext) {
    super.activate(renderContext);

    _renderBufferVertex = renderContext.renderBufferVertex;
    _renderBufferVertex.activate(renderContext);
  }

  //---------------------------------------------------------------------------

  void renderCloudFilterQuad() {}
}
