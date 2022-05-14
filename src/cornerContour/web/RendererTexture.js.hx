package cornerContour.web;
// cornerContour
import cornerContour.io.Float32Array;
import cornerContour.io.TextureTriangles2D;
import cornerContour.io.IteratorRange;
import cornerContour.Pen2D;

// webgl gl stuff
import cornerContour.web.TextureShader2D;
import cornerContour.web.HelpGL;
import cornerContour.web.BufferGL;
import cornerContour.web.ImageGL;
import cornerContour.web.GL;
// js webgl 
import js.html.webgl.Buffer;
import js.html.webgl.RenderingContext;
import js.html.webgl.Program;
import js.html.webgl.Texture;
import js.html.Image;

import js.html.webgl.RenderingContext;
import js.html.CanvasRenderingContext2D;

/*
enum abstract ProgramMode(Int) {
  var ModeNone;
  var ModeColor;
  var ModeTexture;
}
*/

// TODO: could not get access and allow to work properly so everything public
@:structInit
private class RendererTexture_ {
    // general inputs
    public final vertexPosition         = 'vertexPosition';
    public final vertexTexture          = 'vertexTexture';
    final vertexColor            = 'vertexColor';
        // Texture uniforms
    public final uniformImage           = 'uImage0';
    public final uniformColor           = 'bgColor';
    public final uvTransform            = 'uvTransform';
    public var gl:                      RenderingContext;
    public var pen:              Pen2D;
    public var width:            Float;
    public var height:           Float;
    public var program:          Program;
    public var bufTexture:       Buffer;
    public var bufIndices:       Buffer;
    //public var dataGLtexture:    DataGL;
    var indicesTexture           = new Array<Int>();
    public var img:              Image;
    public var tex:              Texture;
    public var textureArr        = new Array<Texture>();
    public var transformUVArr    = [ 1.,0.,0.
                                   , 0.,1.,0.
                                   , 0.,0.,1.];
    public var hasImage:         Bool = true;
    public var arrData:   TextureTriangles2D;
    public var len:              Int;//
    public var totalTriangles:   Int;
    public var bufferLength:     Int;
    public var triSize:          Int;
    public var currData:         Float32Array;
    //public var mode: ProgramMode = ModeNone;
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
@:access( cornerContour.web.RendererTexture_ )
abstract RendererTexture( RendererTexture_ ) from RendererTexture_ {
    public inline 
    function new( r: RendererTexture_ ){
        this = r;
    }
    public inline
    function rearrangeData(){
        var data = this.pen.arr;
        // triangle length
        this.totalTriangles = Std.int( data.size/8 );
        this.bufferLength = this.totalTriangles*3;
         // xy rgba uv= 8
        this.triSize = 8 * 3;
        this.len = Std.int( this.totalTriangles * this.triSize );
        this.arrData = new TextureTriangles2D( this.len );
        for( i in 0...this.totalTriangles ){
            this.pen.pos = i;
            // populate arrData.
            this.arrData.pos    = i;
            this.arrData.argb   = Std.int( data.color );
            this.arrData.ax     = gx( data.ax );
            this.arrData.ay     = gy( data.ay );
            this.arrData.au     = ux( data.ax );
            this.arrData.av     = vy( data.ay );
            this.arrData.bx     = gx( data.bx );
            this.arrData.by     = gy( data.by );
            this.arrData.bu     = ux( data.bx );
            this.arrData.bv     = vy( data.by );
            this.arrData.cx     = gx( data.cx );
            this.arrData.cy     = gy( data.cy );
            this.arrData.cu     = ux( data.cx );
            this.arrData.cv     = vy( data.cy );
        }
    }
    public inline
    function setup(){
        setProgramTexture();
        if( this.hasImage ) setupInputTexture();
        //setProgramMode();
        modeEnable();
        updateData();
    }
    inline
    function setProgramTexture(){
        this.program = programSetup( this.gl
                                    , textureVertexString1
                                    , textureFragmentString );
    }
    inline
    function setupInputTexture(){
        this.tex = uploadImage( this.gl, 0, this.img );
        var arr = this.arrData.getFloat32Array();
        this.bufTexture = interleaveXY_RGBA_UV( this.gl
                        , this.program
                        , arr
                        , this.vertexPosition
                        , this.vertexColor
                        , this.vertexTexture, true );
        buildIndicesTexture( this.len );//dataGLtexture.size );
        this.bufIndices = passIndicesToShader( this.gl, this.indicesTexture, true );
    }
    public
    function drawTextureShape( range: IteratorRange, bgColor: Int ) {
        //var modeChange = setProgramMode( ModeTexture );
        colorUniform( this.gl, this.program, this.uniformColor, bgColor );
        //if( modeChange ) {
            imageUniform( this.gl, this.program, this.uniformImage );
            transformUV( this.gl, this.program, this.uvTransform, this.transformUVArr );
            //}
        var dynamicDraw = GL.DYNAMIC_DRAW;
        buildIndicesTexture( range.start - range.max );
        /*gl.bufferData( GL.ELEMENT_ARRAY_BUFFER
                     , new Uint16Array( indicesTexture  )
                     , dynamicDraw );*/
        drawData( range );
    }
    inline
    function buildIndicesTexture( size: Int ){
        var count = 0;
        var indicesTexture           = new Array<Int>();
        for( i in 0...size ) for( k in 0...3 ) indicesTexture.push( count++ );
        return indicesTexture;
    }
    
    public inline
    function updateData(){
        this.currData = this.arrData.getFloat32Array();
    }
    public inline
    function drawData( range: IteratorRange ){
        var min      = range.start*this.triSize;
        var max      = range.max*this.triSize;
        var partData = this.currData.subarray( min, max );
        this.gl.bufferSubData( GL.ARRAY_BUFFER, 0, cast partData );
        this.gl.useProgram( this.program );
        var no       = Std.int( ( range.max - range.start ) * 3);
        this.gl.drawArrays( GL.TRIANGLES, 0, no );
    }
    // call between changing to this shader
    public function modeEnable(){
        this.gl.useProgram( this.program );
        this.gl.bindBuffer( GL.ARRAY_BUFFER, this.bufTexture );
        //gl.bindBuffer( GL.ARRAY_BUFFER, bufIndices );
        
        updateBufferXY_RGBA_UV(  this.gl, this.program
                                , this.vertexPosition
                                , this.vertexColor
                                , this.vertexTexture );
        
    }
    public inline
    function withAlpha(){
        setAsRGBA( this.gl, this.img );
    }
    public inline
    function notAlpha(){
        setAsRGB( this.gl, this.img );
    }
    // Map x, y -> -1 to 1, and generate texture u,v 0 to 1
    // TODO: implement scale, offset?
    public inline
    function gx( v: Float ): Float {
        return -( 1 - 2*v/this.width );
    }
    public inline
    function gy( v: Float ): Float {
        return ( 1 - 2*v/this.height );
    }
    public inline
    function ux( v: Float ): Float {
        return v/this.width;
    }
    public inline
    function vy( v: Float ): Float {
        return v/this.height;
    }
}
