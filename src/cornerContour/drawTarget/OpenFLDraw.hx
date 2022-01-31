package cornerContour.drawTarget;
import cornerContour.Pen2D;
import cornerContour.color.ColorHelp;

inline
function rearrangeDrawData( pen: Pen2D, g: openFL.display.Graphics ){
    var data = pen.arr;
    var totalTriangles = Std.int( data.size/7 );
    
    var vert = new Array<Float>();
    var ind = new Array<Int>();
    var vertices: openfl.Vector<Float>;
    var indices: openfl.Vector<Int>;
    var color_: Int = 0;
    var alpha_: Float = 0.;
    var lastColor: Int = -1;
    var lastAlpha: Float = -1.;
    var vCount = 0;
    var iCount = 0;
    var count = 0;
    var i = 1;
    pen.pos = i;
    lastColor = rgbInt( Std.int( data.color ) );
    lastAlpha = getAlpha( data.color );
    while( i < totalTriangles ){
        pen.pos = i;
        //if( i != 0 ){
            color_ = rgbInt( Std.int( data.color ) );
            alpha_ = getAlpha( data.color );
            //}
        if( color_ != lastColor || alpha_ != lastAlpha ){
            vertices = new openfl.Vector<Float>( vCount, true, vert );
            indices = new openfl.Vector<Int>( iCount, true, ind );
            if( vertices.length != 0 ){
                g.lineStyle( 0, 0xFFFFFF, 0 );
                g.beginFill( lastColor, lastAlpha );
                g.drawTriangles( vertices, indices );
                g.endFill();
            }
            vert = [];
            ind = [];
            vCount = 0;
            iCount = 0;
            count = 1;
        }
        vert.push( data.ax );
        vert.push( data.ay );
        vert.push( data.bx );
        vert.push( data.by );
        vert.push( data.cx );
        vert.push( data.cy );
        ind.push( iCount );
        iCount++;
        ind.push( iCount );
        iCount++;
        ind.push( iCount );
        iCount++;
        vCount+= 6;
        lastColor = color_;
        lastAlpha = alpha_;
        i++;
    }
    if( vert.length != 0 ){
        vertices = new openfl.Vector<Float>( vCount, true, vert );
        indices = new openfl.Vector<Int>( iCount, true, ind );
        g.lineStyle( 0, 0xFFFFFF, 0 );
        g.beginFill( color_, alpha_ );
        g.drawTriangles( vertices, indices );
        g.endFill();
    }
}

inline
function rearrangeDrawData2( pen: Pen2D, g: openFL.display.Graphics ){
    var pen = pen2D;
    var data = pen.arr;
    var totalTriangles = Std.int( data.size/7 );
    
    for( i in 0...totalTriangles ){
        pen.pos = i;
        g.lineStyle( 0, 0xFFFFFF, 0 );
        g.beginFill( rgbInt( Std.int( data.color ) ), getAlpha( data.color ) );
        g.moveTo( data.ax, data.ay );
        g.lineTo( data.bx, data.by );
        g.lineTo( data.cx, data.cy );
        g.lineTo( data.ax, data.ay );
        g.endFill();
    }
}