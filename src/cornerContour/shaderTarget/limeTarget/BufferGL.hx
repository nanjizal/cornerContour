package cornerContour.shaderTarget.limeTarget;

import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
//import lime.utils.Float32Array;
import lime.graphics.opengl.GLBuffer;
import haxe.io.Float32Array;

import cornerContour.shaderTarget.limeTarget.BufferGL;
/*
#if js
import js.html.webgl.RenderingContext;
import js.html.webgl.Buffer;
import js.html.webgl.Program;
*/

//import cornerContourWebGLTest.GL;
//import js.lib.Uint16Array;
//import js.lib.Uint8Array;

//@:transitive
inline
function bufferSetup( gl:           WebGLRenderContext
                    , program:      GLProgram
                    , data:         Float32Array
                    , ?isDynamic:    Bool = false ): GLBuffer {
    var buf: GLBuffer = gl.createBuffer();
    var staticDraw  = gl.STATIC_DRAW;
    var dynamicDraw = gl.DYNAMIC_DRAW;
    var arrayBuffer = gl.ARRAY_BUFFER;
    gl.bindBuffer( arrayBuffer, buf );
    ( isDynamic )? dataSet( gl, untyped data, dynamicDraw ): dataSet( gl, untyped data, staticDraw );
    //gl.bindBuffer( RenderingContext.ARRAY_BUFFER, null );
    return buf;	
}

/*
// change to DYNAMIC_DRAW
inline 
function passIndicesToShader( gl: WebGLRenderContext, indices: Array<Int>, ?isDynamic: Bool = false ): Buffer {
        var buf: Buffer = gl.createBuffer(); // triangle indicies data 
        var staticDraw  = gl.STATIC_DRAW;
        var dynamicDraw = gl.DYNAMIC_DRAW;
        var arrBuffer = gl.ELEMENT_ARRAY_BUFFER;
        gl.bindBuffer( arrBuffer, buf );
        if( isDynamic ){ 
            gl.bufferData( arrBuffer
                         , new Uint16Array( indices )
                         , dynamicDraw );
        } else {
            gl.bufferData( arrBuffer
                         , new Uint16Array( indices )
                         , staticDraw );
        }
        gl.bindBuffer( arrBuffer, null );
        return buf;
}
*/

inline
function dataSet( gl: WebGLRenderContext, data: Float32Array, isDraw: Int ){
    var arrayBuffer = gl.ARRAY_BUFFER;
    gl.bufferData( arrayBuffer, untyped data, isDraw );
}

inline
function inputAttribute( gl: WebGLRenderContext, program: GLProgram, name: String ): Int {
    return gl.getAttribLocation( program, name );
}

inline
function inputAttEnable(  gl: WebGLRenderContext, program: GLProgram, name: String
                        , size: Int, stride: Int, off: Int ){
    var inp            = inputAttribute( gl, program, name );
    var elementBytes   = Float32Array.BYTES_PER_ELEMENT;
    var fp             = gl.FLOAT;
    var strideBytes    = stride*elementBytes;
    var offBytes       = off*elementBytes;
    gl.vertexAttribPointer( inp, size, fp, false, strideBytes, offBytes );
    gl.enableVertexAttribArray( inp );
    return inp;
}
inline
function interleaveXY_RGBA( gl:            WebGLRenderContext
                           , program:       GLProgram 
                           , data:          Float32Array
                           , xyName:       String
                           , rgbaName:      String
                           , ?isDynamic:    Bool = false ): GLBuffer {
    var vbo          = bufferSetup( gl, program, data, isDynamic ); 
    // X Y   R G B A
    inputAttEnable( gl,  program, xyName, 2, 6, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 6, 2 );
    return vbo;
}
inline
function updateBufferXY_RGBA( gl:       WebGLRenderContext
                           , program:     GLProgram 
                           , xyzName:     String
                           , rgbaName:    String ){
    inputAttEnable( gl,  program, xyzName, 2, 6, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 6, 2 );
}

// just used for docs
class BufferGL{
    public var bufferSetup_: ( gl: WebGLRenderContext
                             , program: GLProgram
                             , data: Float32Array
                             , ?isDynamic: Bool ) -> GLBuffer = bufferSetup;
    /*public var passIndicesToShader_: ( gl:           GL
                                     , indices:   Array<Int>
                                     , ?isDynamic: Bool ) -> Buffer = passIndicesToShader;*/
    public var interleaveXY_RGBA_: ( gl:       WebGLRenderContext
                                    , program:   GLProgram 
                                    , data:      Float32Array
                                    , inPosName: String
                                    , inColName: String
                                    , ?isDynamic: Bool )->GLBuffer = interleaveXY_RGBA;   
}