package cornerContour.drawTarget;
import cornerContour.Pen2D;

inline
function rearrangeDrawData( pen: Pen2D, g: nme.display.Graphics ){
    var pen = pen2D;
    var data = pen.arr;
    var n = Std.int( data.size/7 );
    if( n == 0 ) return;
    var verts = new Array<Float>();
    var cols = new Array<Int>();
    verts[ 6 * n - 1 ] = 0.0;
    cols[ n * 3 - 1 ]  = 0;
    var i = 0;
    var c = 0;
    var col: Int;
    for( i in 0...n ){
       pen.pos = i;
       verts[ i++ ] = data.ax;
       verts[ i++ ] = data.ay;
       verts[ i++ ] = data.bx;
       verts[ i++ ] = data.by;
       verts[ i++ ] = data.cx;
       verts[ i++ ] = data.cy;
       col = Std.int( data.color )
       cols[ c++ ] = col;
       cols[ c++ ] = col;
       cols[ c++ ] = col;
    } 
    g.drawTriangles( verts, null, null, null, cols );
}


inline
function resizeStage( view: nme.display.Sprite, e: nme.events.Event ){
    var s = Lib.current.stage;
    var scale =  Math.min( s.stageWidth, s.stageHeight )/2.5;
    view.scaleX = view.scaleY = scale;
    view.x = s.stageWidth/2 - view.width/1.9;
    view.y = scale * 0.005;
}