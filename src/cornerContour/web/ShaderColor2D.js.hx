package cornerContour.web;

inline
var vertexString: String =
    'attribute vec2 vertexPosition;' +
    'attribute vec4 vertexColor;' +
    'varying vec4 vcol;' +
    'void main(void) {' +
        ' gl_Position = vec4(vertexPosition, .0, 1.0);'+
        ' vcol = vertexColor;' +
    '}';
    
inline
var fragmentString: String =
    'precision mediump float;'+
    'varying vec4 vcol;' +
    'void main(void) {' +
        'vec4 color = vec4(vcol.rgb, 1. );' +
        'color *= vcol.a; ' + 
        'gl_FragColor = color;' +
    '}';
// just used for docs
enum abstract ShaderColor2D( String ){
    var vertexString_ = vertexString;
    var fragmentString_ = fragmentString;
}