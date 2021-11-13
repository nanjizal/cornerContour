package cornerContour.web;
// cornerContour
import cornerContour.io.Float32Array;
import cornerContour.io.ColorTriangles2D;
import cornerContour.io.IteratorRange;
import cornerContour.Pen2D;

// webgl gl stuff
import cornerContour.web.ShaderColor2D;
import cornerContour.web.HelpGL;
import cornerContour.web.BufferGL;
import cornerContour.web.GL;

// js webgl 
import js.html.webgl.Buffer;
import js.html.webgl.RenderingContext;
import js.html.webgl.Program;
import js.html.webgl.Texture;

import js.html.webgl.RenderingContext;
import js.html.CanvasRenderingContext2D;
// TODO: could not get access and allow to work properly so everything public
@:structInit
class Renderer_ {
    // general inputs
    public final vertexPosition         = 'vertexPosition';
    public final vertexColor            = 'vertexColor';
    public var gl:               RenderingContext;
    public var pen:              Pen2D;
    public var width:            Float;
    public var height:           Float;
    public var program:          Program;
    public var buf:              Buffer;
    public var arrData:   ColorTriangles2D;
    public var len:              Int;//
    public var totalTriangles:   Int;
    public var bufferLength:     Int;
    public var triSize:          Int;
    public var currData:         Float32Array;
    public function new( gl: RenderingContext, pen: Pen2D,
                         width: Float, height: Float ){
        this.gl     = gl;
        this.pen    = pen;
        this.width  = width;
        this.height = height;
    }
}
@:transitive
@:forward
abstract Renderer( Renderer_ ) from Renderer_ {
    public inline 
    function new( r: Renderer_ ){
        this = r;
    }
    public inline
    function rearrangeData(){
        var data = this.pen.arr;
        // triangle length
        this.totalTriangles = Std.int( data.size/7 );
        this.bufferLength = this.totalTriangles*3;
         // xy rgba = 6
        this.triSize = 6 * 3;
        this.len = Std.int( this.totalTriangles * this.triSize );
        this.arrData = new ColorTriangles2D( this.len );
        for( i in 0...this.totalTriangles ){
            this.pen.pos = i;
            // populate arrData.
            this.arrData.pos    = i;
            this.arrData.argb   = Std.int( data.color );
            this.arrData.ax     = gx( data.ax );
            this.arrData.ay     = gy( data.ay );
            this.arrData.bx     = gx( data.bx );
            this.arrData.by     = gy( data.by );
            this.arrData.cx     = gx( data.cx );
            this.arrData.cy     = gy( data.cy );
        }
    }
    public inline
    function setup(){
        setProgramColor();
        setupInputColor();
        setProgramMode();
        updateData();
    }
    inline
    function setProgramColor(){
        this.program = programSetup( this.gl, vertexString, fragmentString );
    }
    inline
    function setProgramMode() {
        this.gl.useProgram( this.program );
        updateBufferXY_RGBA( this.gl, this.program
                           , this.vertexPosition, this.vertexColor );
        this.gl.bindBuffer( GL.ARRAY_BUFFER, this.buf );
    }
    public inline
    function setupInputColor(){
        this.gl.bindBuffer( GL.ARRAY_BUFFER, null );
        this.gl.useProgram( this.program );
        var arr = this.arrData.getFloat32Array();
        this.buf = interleaveXY_RGBA( this.gl
                               , this.program
                               , arr
                               , this.vertexPosition, this.vertexColor, true );
        this.gl.bindBuffer( GL.ARRAY_BUFFER, this.buf );
    }
    public inline
    function updateData(){
        this.currData = this.arrData.getFloat32Array();
    }
    public inline
    function drawData( range: IteratorRange ){
        var partData = this.currData.subarray( range.start*this.triSize, range.max*this.triSize );
        this.gl.bufferSubData( GL.ARRAY_BUFFER, 0, cast partData );
        this.gl.useProgram( this.program );
        this.gl.drawArrays( GL.TRIANGLES, 0, Std.int( ( range.max - range.start ) * 3));
    }
    public inline
    function gx( v: Float ): Float {
        return -( 1 - 2*v/this.width );
    }
    public inline
    function gy( v: Float ): Float {
        return ( 1 - 2*v/this.height );
    }
}