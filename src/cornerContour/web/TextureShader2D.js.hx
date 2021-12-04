package cornerContour.web;
// Currently uses this but switch to other vertex once add modelViewProjection code
inline
var textureVertexString1: String =
    'attribute vec2 vertexPosition;' +
    'attribute vec4 vertexColor;' +
    'attribute vec2 vertexTexture;' +

    'varying vec4 vcol;' +
    'varying vec2 vtexture;' +
    
    'uniform mat3 uvTransform;' +
    
    'void main(void) {' + 
        ' gl_Position = vec4(vertexPosition, .0, 1.0);'+
        //' gl_Position = vec4( vertexPosition, 1.0);' +
        //' vtexture = vec2( vertexTexture.x , 1.-vertexTexture.y );' +
        ' vec3 texChange = uvTransform * vec3(vertexTexture, 1.0);' + 
        ' vtexture = vec2( texChange );' +
        ' vcol = vertexColor;' +
    '}';
inline
var textureVertexString2: String =
    'attribute vec2 vertexPosition;' +
    'attribute vec4 vertexColor;' +
    'attribute vec2 vertexTexture;' +
    
    'varying vec4 vcol;' +
    'varying vec2 vtexture;' +
    
    'uniform mat3 uvTransform;' +
    
    'uniform mat4 modelViewProjection;' +
    
    'void main(void) {' +
        ' gl_Position = modelViewProjection * vec4(vertexPosition, .0, 1.0);'+
        //' vtexture = vec2( vertexTexture.x , 1.-vertexTexture.y );' +
        ' vec3 texChange = uvTransform * vec3(vertexTexture, 1.0);' + 
        ' vtexture = vec2( texChange );' +
        ' vcol = vertexColor;' +
    '}';
inline
var textureFragmentString: String =
    'precision mediump float;' +
    'precision mediump int;' +
    
    'varying vec4 vcol;' +
    'varying vec2 vtexture;' +
    
    'uniform sampler2D uImage0;' +
    'uniform vec4 bgColor;' +
    'void main(void) {' +
    'if (vtexture.x < 0.0 || vtexture.y < 0.0 || vtexture.x > 1.0 || vtexture.y > 1.0) {' +
        ' gl_FragColor = bgColor; '+
    '} else {'+
        'vec4 texcolor = texture2D( uImage0, vec2( vtexture.s, vtexture.t ) ).rgba * vcol;' +
        'texcolor.rgb *= vcol.a; ' + 
        'if( texcolor.a < 1. ){' +
            'texcolor = mix( bgColor, texcolor, texcolor.a ); '+
            '}'+
        'gl_FragColor = texcolor;'+
        '}'+
    '}';
    
// just used for docs
enum abstract TextureShaders2D( String ){
    var textureVertexString1_ = textureVertexString1;
    var textureVertexString2_ = textureVertexString2;
    var textureFragmentString_ = textureFragmentString;
}