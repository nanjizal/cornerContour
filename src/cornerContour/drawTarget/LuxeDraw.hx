package cornerContour.drawTarget;
import cornerContour.Pen2D;
import cornerContour.color.ColorHelp;

// Luxe haxe has been depreciated but decided to test my local version anyway.

import phoenix.Batcher.PrimitiveType;
import phoenix.Vector;
import phoenix.geometry.Vertex;
import luxe.Vector;
import phoenix.geometry.Geometry;
import luxe.Color;

inline
function createMesh(): Geometry {
    return new Geometry({
            primitive_type:PrimitiveType.triangles,
            batcher: Luxe.renderer.batcher
    });
}

inline
function renderToTriangles( pen: Pen2D, g: Geometry
                          , s: Float = 1., ox: Float = 0., oy: Float = 0. ){
    var data = pen.arr;
    var totalTriangles = Std.int( data.size/7 );
    for( i in 0...totalTriangles ){
        pen.pos = i;
        g.add( 
            new Vertex( 
                new Vector( ox + data.ax * s, oy + data.ay * s )
                , data.color ) 
            );
        g.add( 
            new Vertex( 
                new Vector( ox + data.bx * s, oy + data.by * s )
                , data.color ) 
            );
        g.add( 
            new Vertex( 
                new Vector( ox + data.cx * s, oy + data.cy * s )
                , data.color ) 
            );
    }
}