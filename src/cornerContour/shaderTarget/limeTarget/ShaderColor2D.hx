package cornerContour.shaderTarget.limeTarget;


inline
var vertexString: String =
    #if( !desktop || rpi )
    "precision mediump float;" +
    "precision mediump int;" + 
    #end
    'attribute vec2 vertexPosition;' +
    'attribute vec4 vertexColor;' +
    'varying vec4 vcol;' +
    'void main(void) {' +
        ' gl_Position = vec4(vertexPosition, .0, 1.0);'+
        ' vcol = vertexColor;' +
    '}';
    
inline
var fragmentString: String =
    #if( !desktop || rpi )
    "precision mediump float;" +
    "precision mediump int;" + 
    #end
    'varying vec4 vcol;' +
    'void main(void) {' +
        'vec4 color = vec4(vcol.rgb, vcol.a );' +
        'gl_FragColor = color;' +
    '}';
// just used for docs
enum abstract ShaderColor2D( String ){
    var vertexString_ = vertexString;
    var fragmentString_ = fragmentString;
}