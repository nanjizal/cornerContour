package cornerContour.web;
//#if js
import js.html.webgl.RenderingContext;
import js.html.webgl.ContextAttributes;
import js.html.webgl.Texture;
import js.html.webgl.Shader;
import js.html.webgl.UniformLocation;
import js.html.webgl.Program;
import js.html.Image;
import js.lib.Uint16Array;
import js.lib.Uint8Array;
import cornerContour.web.GL;
import cornerContour.color.ColorHelp;

inline
function setAsRGBA( gl: GL, img: Image ){
    gl.texImage2D( GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, img );
}
inline
function setAsRGB( gl: GL, img: Image ){
    gl.texImage2D( GL.TEXTURE_2D, 0, GL.RGB, GL.RGB, GL.UNSIGNED_BYTE, img );
}
inline
function updateAsARGB( gl: GL, texture: Texture, img: Image ){
    //trace(' IMAGE ' + img );
    //gl.bindTexture( GL.TEXTURE_2D, texture );
    gl.texSubImage2D( GL.TEXTURE_2D, 0, 0, 0, GL.RGBA, GL.UNSIGNED_BYTE, img );
    //textureStandard( gl );
    //activateTexture( gl, texture, 0 );
}
/*
inline
function updateAsRGB( gl: GL, img: Image ){
    gl.texSubImage2D( GL.TEXTURE_2D, 0, 0, 0, GL.RGB, GL.UNSIGNED_BYTE, img );
}
*/
inline
function setAsPixel( gl: GL ){
    final pixel = new Uint8Array([ 255, 255, 255, 255 ]);
    var _2D     = GL.TEXTURE_2D;
    gl.texImage2D( _2D, 0, GL.RGBA, 1, 1, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixel );
}
inline
function transformUV( gl: GL
                    , program: Program
                    , name:    String
                    , ?val:     Array<Float> ): UniformLocation {
    var uvTransform = gl.getUniformLocation( program, name );
    if( val == null ){
        val = [ 1.,0.,0.
              , 0.,1.,0.
              , 0.,0.,1.];
    }
    gl.uniformMatrix3fv( uvTransform,false, val );
    return uvTransform;
}
inline
function imageUniform( gl:            GL
                     , program:      Program
                     , name:         String
                     , ?preMultAlpha: Bool = true ): UniformLocation {
    var imgUniform = gl.getUniformLocation( program, name );
    gl.uniform1i( imgUniform, 0 );
    gl.enable( GL.DEPTH_TEST );
    
    gl.enable( GL.BLEND );
    if( preMultAlpha ) {
        premulipliedAlpha( gl );
    } else {
        nonPreMultipliedAlpha( gl );
    }
    gl.depthMask(false);
    gl.disable( GL.CULL_FACE );
    return imgUniform;
}

// https://webglfundamentals.org/webgl/lessons/webgl-and-alpha.html
inline 
function premulipliedAlpha( gl: GL ){
    gl.blendFunc( GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
}
inline
function nonPreMultipliedAlpha( gl: GL ){
    gl.blendFunc( GL.ONE, GL.ONE_MINUS_SRC_ALPHA );
}
inline
function colorUniform( gl:      GL
                     , program: Program
                     , name:    String
                     , int: Int ): UniformLocation {
    var argb = hexToARGB( int );
    return rgbaUniform( gl, program, name, argb.r, argb.g, argb.b, argb.a );
}
inline
function rgbaUniform( gl: GL 
                    , program: Program
                    , name: String
                    , red: Float
                    , green: Float
                    , blue: Float
                    , alpha: Float ){
    var colUniform = gl.getUniformLocation( program, name );
    gl.uniform4f( colUniform, red, green, blue, alpha );
    return colUniform;
}

// Not currently used!!
inline
function updateTexture( gl: GL, texture: Texture, image: Image ){
    var _2D     = GL.TEXTURE_2D;
    var rgba    = GL.RGBA;
    var texture = gl.createTexture();
    var srcType = GL.UNSIGNED_BYTE;
    gl.bindTexture( _2D, texture );
    /*gl.texImage2D( _2D, 0, rgba, 1, 1, 0, rgba, srcType,
                  new Uint8Array([0, 0, 255, 255])); */
    setAsRGBA( gl, image );
    return texture;
}
inline
function isPowerOf2( value: Int ){
    return (value & (value - 1)) == 0;
}

/*
gl.bindTexture(gl.TEXTURE_2D, this._texture);
gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, 1);

// mop: it is the first call
if (!this._texture.isReady) {
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, img);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
} else {
  gl.texSubImage2D(gl.TEXTURE_2D, 0, 0, 0, gl.RGBA, gl.UNSIGNED_BYTE, img);
}
gl.bindTexture(gl.TEXTURE_2D, null);
*/

inline
function uploadImage( gl: GL, imageIndex: Int, image: Image, ?midMap: Bool = false ): Texture {
    var _2D     = GL.TEXTURE_2D;
    var RGBA    = GL.RGBA;
    var texture = gl.createTexture();
    gl.bindTexture( _2D, texture );
    setAsPixel( gl );
    var midMap = (isPowerOf2(image.width) && isPowerOf2(image.height));
    if( !midMap ) textureStandard( gl ); // hard coded for now
    setAsRGBA( gl, image );
    //midMap = true;
    if( midMap ) gl.generateMipmap( _2D );
    activateTexture( gl, texture, imageIndex );
    return texture;
}
inline
function activateTexture( gl: GL, texture: Texture, imageIndex: Int ){
    var _2D = GL.TEXTURE_2D;
    switch( imageIndex ){
        case 0: gl.activeTexture( GL.TEXTURE0 );
        case 1: gl.activeTexture( GL.TEXTURE1 );
        case 2: gl.activeTexture( GL.TEXTURE2 );
        case 3: gl.activeTexture( GL.TEXTURE3 );
        case 4: gl.activeTexture( GL.TEXTURE4 );
        case 5: gl.activeTexture( GL.TEXTURE5 );
        case 6: gl.activeTexture( GL.TEXTURE6 );
        default: gl.activeTexture( GL.TEXTURE7 );
    }
    gl.bindTexture( _2D, texture );
}
inline
function textureStandard( gl: GL ){
    //nearestTexture();
    linearTexture( gl );
    clampTexture( gl );
    //repeatTexture( gl );
}
inline 
function unpackAlign( gl: GL ){
    gl.pixelStorei( GL.UNPACK_ALIGNMENT,4);
}
inline
function unpackPremultiplyAlpha( gl: GL ){
    gl.pixelStorei( GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1 );
}
inline
function linearTexture( gl: GL ){
    var _2D     = GL.TEXTURE_2D;
    var linear  = GL.LINEAR;
    var mag     = GL.TEXTURE_MAG_FILTER;
    var min     = GL.TEXTURE_MIN_FILTER;
    gl.texParameteri( _2D, mag, linear );
    gl.texParameteri( _2D, min, linear );
}
inline
function nearestTexture( gl: GL ){
    var _2D     = GL.TEXTURE_2D;
    var nearest = GL.NEAREST;
    var mag     = GL.TEXTURE_MAG_FILTER;
    var min     = GL.TEXTURE_MIN_FILTER;
    gl.texParameteri( _2D, mag, nearest );
    gl.texParameteri( _2D, min, nearest );
}
inline
function clampTexture( gl: GL ){
    var _2D     = GL.TEXTURE_2D;
    var clamp   = GL.CLAMP_TO_EDGE;
    var _S      = GL.TEXTURE_WRAP_S;
    var _T      = GL.TEXTURE_WRAP_T;
    gl.texParameteri( _2D, _S, clamp );
    gl.texParameteri( _2D, _T, clamp );
}
inline
function repeatTexture( gl: GL ){
    var _2D     = GL.TEXTURE_2D;
    var repeat  = GL.REPEAT;
    var _S      = GL.TEXTURE_WRAP_S;
    var _T      = GL.TEXTURE_WRAP_T;
    gl.texParameteri( _2D, _S, repeat );
    gl.texParameteri( _2D, _T, repeat );
}
inline
function repeatMirrorTexture( gl: GL ){
    var _2D     = GL.TEXTURE_2D;
    var repeat  = GL.MIRRORED_REPEAT;
    var _S      = GL.TEXTURE_WRAP_S;
    var _T      = GL.TEXTURE_WRAP_T;
    gl.texParameteri( _2D, _S, repeat );
    gl.texParameteri( _2D, _T, repeat );
}
// just used for docs
class ImageGL {
    public var imageUniform_:    ( gl:           GL
                                 , program:      Program
                                 , name:        String
                                 , ?preMultAlpha: Bool ) -> UniformLocation = imageUniform;
    public var uploadImage_:     ( gl:           GL
                                 , imageIndex:   Int
                                 , image:        Image
                                 , ?midMap:       Bool ) -> Texture   = uploadImage;
    public var updateTexture_:   ( gl:           GL
                                 , texture:      Texture
                                 , image:        Image ) -> Void   = updateTexture;
    public var activateTexture_: ( gl:           GL
                                 , texture:      Texture
                                 , imageIndex:   Int ) -> Void = activateTexture;
    public var textureStandard_: ( gl:           GL ) -> Void = textureStandard;
}
//#end