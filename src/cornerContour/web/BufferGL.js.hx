package cornerContour.web;
#if js
import js.html.webgl.RenderingContext;
import js.html.webgl.Buffer;
import js.html.webgl.Program;

import haxe.io.Float32Array;
import cornerContour.web.BufferGL;
import cornerContour.web.GL;
import js.lib.Uint16Array;
import js.lib.Uint8Array;
//@:transitive
inline
function bufferSetup( gl:           GL
                    , program:      Program
                    , data:         Float32Array
                    , ?isDynamic:    Bool = false ): Buffer {
    var buf: Buffer = gl.createBuffer();
    var staticDraw  = GL.STATIC_DRAW;
    var dynamicDraw = GL.DYNAMIC_DRAW;
    var arrayBuffer = GL.ARRAY_BUFFER;
    gl.bindBuffer( arrayBuffer, buf );
    ( isDynamic )? dataSet( gl, untyped data, dynamicDraw ): dataSet( gl, untyped data, staticDraw );
    //gl.bindBuffer( RenderingContext.ARRAY_BUFFER, null );
    return buf;	
}

// change to DYNAMIC_DRAW
inline 
function passIndicesToShader( gl: GL, indices: Array<Int>, ?isDynamic: Bool = false ): Buffer {
        var buf: Buffer = gl.createBuffer(); // triangle indicies data 
        var staticDraw  = GL.STATIC_DRAW;
        var dynamicDraw = GL.DYNAMIC_DRAW;
        var arrBuffer = GL.ELEMENT_ARRAY_BUFFER;
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

inline
function dataSet( gl: GL, data: Float32Array, isDraw: Int ){
    var arrayBuffer = GL.ARRAY_BUFFER;
    gl.bufferData( arrayBuffer, untyped data, isDraw );
}

inline
function inputAttribute( gl: GL, program: Program, name: String ): Int {
    return gl.getAttribLocation( program, name );
}

inline
function inputAttEnable(  gl: GL, program: Program, name: String
                        , size: Int, stride: Int, off: Int ){
    var inp            = inputAttribute( gl, program, name );
    var elementBytes   = Float32Array.BYTES_PER_ELEMENT;
    var fp             = GL.FLOAT;
    var strideBytes    = stride*elementBytes;
    var offBytes       = off*elementBytes;
    gl.vertexAttribPointer( inp, size, fp, false, strideBytes, offBytes );
    gl.enableVertexAttribArray( inp );
    return inp;
}
inline
function interleaveXY_RGBA( gl:            GL
                           , program:       Program 
                           , data:          Float32Array
                           , xyName:       String
                           , rgbaName:      String
                           , ?isDynamic:    Bool = false ): Buffer {
    var vbo          = bufferSetup( gl, program, data, isDynamic ); 
    // X Y   R G B A
    inputAttEnable( gl, program, xyName,   2, 6, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 6, 2 );
    return vbo;
}
inline
function updateBufferXY_RGBA( gl:       GL
                           , program:     Program 
                           , xyzName:     String
                           , rgbaName:    String ){
    inputAttEnable( gl,  program, xyzName, 2, 6, 0 );
    inputAttEnable( gl, program, rgbaName, 4, 6, 2 );
}

// just used for docs
class BufferGL{
    public var bufferSetup_: ( gl: GL
                             , program: Program
                             , data: Float32Array
                             , ?isDynamic: Bool ) -> Buffer = bufferSetup;
    public var passIndicesToShader_: ( gl:           GL
                                     , indices:   Array<Int>
                                     , ?isDynamic: Bool ) -> Buffer = passIndicesToShader;
    public var interleaveXY_RGBA_: ( gl:       RenderingContext
                                    , program:   Program 
                                    , data:      Float32Array
                                    , inPosName: String
                                    , inColName: String
                                    , ?isDynamic: Bool )->Buffer = interleaveXY_RGBA;   
}
#end