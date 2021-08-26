package cornerContour.shape;
import cornerContour.IPen;
inline
function circle( pen: IPen
               , ax: Float, ay: Float
               , radius: Float
               , ?color: Null<Int>
               , ?sides: Int = 36, ?omega: Float = 0. ): Int {
    var pi: Float = Math.PI;
    var theta: Float = pi/2 + omega;
    var step: Float = pi*2/sides;
    var bx: Float;
    var by: Float;
    var cx: Float;
    var cy: Float;
    for( i in 0...sides ){
        bx = ax + radius*Math.sin( theta );
        by = ay + radius*Math.cos( theta );
        theta += step;
        cx = ax + radius*Math.sin( theta );
        cy = ay + radius*Math.cos( theta );
        pen.triangle2DFill( ax, ay, bx, by, cx, cy, color );
    }
    return sides;
}

inline
function circleOutline( pen: IPen
               , ax: Float, ay: Float
               , radius: Float
               , thick: Float
               , ?color: Null<Int>
               , ?sides: Int = 36, ?omega: Float = 0. ): Int {
    var pi: Float = Math.PI;
    var theta: Float = pi/2 + omega;
    var step: Float = pi*2/sides;
    var bx: Float;
    var by: Float;
    var cx: Float;
    var cy: Float;
    var b2x: Float;
    var b2y: Float;
    var c2x: Float;
    var c2y: Float;
    var r2 = radius - thick;
    for( i in 0...sides ){
        //    a  b
        //    d  c
        // abd
        // bcd
        bx = ax + radius*Math.sin( theta );
        by = ay + radius*Math.cos( theta );
        b2x = ax + r2*Math.sin( theta );
        b2y = ay + r2*Math.cos( theta );
        theta += step;
        cx = ax + radius*Math.sin( theta );
        cy = ay + radius*Math.cos( theta );
        c2x = ax + r2*Math.sin( theta );
        c2y = ay + r2*Math.cos( theta );
        pen.triangle2DFill( bx, by, cx, cy, b2x, b2y, color );
        pen.triangle2DFill( cx, cy, c2x, c2y, b2x, b2y, color );
    }
    return sides*2;
}
inline
function circleRadial( pen: IPen
                     , ax: Float, ay: Float
                     , rx: Float, ry: Float // -1 to 1 offset centre.
                     , radius: Float
                     , ?color: Null<Int>
                     , ?sides: Int = 36, ?omega: Float = 0. ): Int {
    var pi: Float = Math.PI;
    var theta: Float = pi/2 + omega;
    var step: Float = pi*2/sides;
    var bx: Float;
    var by: Float;
    var cx: Float;
    var cy: Float;
    if( rx > 1. ) rx = 1;
    if( rx < -1. ) rx = -1;
    if( ry > 1. ) ry = 1;
    if( ry < -1. ) ry = -1;
    var mx: Float = ax + rx*radius;
    var my: Float = ay - ry*radius;
    for( i in 0...sides ){
        bx = ax + radius*Math.sin( theta );
        by = ay + radius*Math.cos( theta );
        theta += step;
        cx = ax + radius*Math.sin( theta );
        cy = ay + radius*Math.cos( theta );
        pen.triangle2DFill( mx, my, bx, by, cx, cy, color );
    }
    return sides;
}
inline
function circleRadialOnSide( pen: IPen
                           , ax: Float, ay: Float
                           , rx: Float, ry: Float // -1 to 1 offset centre.
                           , radius: Float 
                           , color: Null<Int>
                           , ?sides: Int = 36
                           , ?omega: Float = 0. ): Int {
    var pi = Math.PI;
    var theta = pi/2;
    var step = pi*2/sides;
    theta -= step/2 + omega;
    var bx: Float = 0;
    var by: Float = 0;
    var cx: Float = 0;
    var cy: Float = 0;
    if( rx > 1. ) rx = 1;
    if( rx < -1. ) rx = -1;
    if( ry > 1. ) ry = 1;
    if( ry < -1. ) ry = -1;
    var mx: Float = ax + rx*radius;
    var my: Float = ay - ry*radius;
    var dx = ax + radius*Math.sin( theta );
    var dy = ay + radius*Math.cos( theta );
    for( i in 0...( sides-1) ){
        bx = ax + radius*Math.sin( theta );
        by = ay + radius*Math.cos( theta );
        theta += step;
        cx = ax + radius*Math.sin( theta );
        cy = ay + radius*Math.cos( theta );
        pen.triangle2DFill( mx, my, bx, by, cx, cy, color );
    }
    pen.triangle2DFill( mx, my, cx, cy, dx, dy, color ); // will not render without?
    return sides;
}
// TODO: Add circle outlines
class Circles {
    public var circle_: ( pen: IPen
                        , ax: Float, ay: Float
                        , radius: Float
                        , ?color: Null<Int>
                        , ?sides: Int
                        , ?omega: Float ) -> Int = circle;
    public var circleRadial_: ( pen: IPen
                              , ax: Float, ay: Float
                              , rx: Float, ry: Float // -1 to 1 offset centre.
                              , radius: Float
                              , ?color: Null<Int>
                              , ?sides: Int
                              , ?omega: Float ) -> Int = circleRadial;
    public var circleRadialOnSide_: ( pen: IPen
                                    , ax: Float, ay: Float
                                    , rx: Float, ry: Float // -1 to 1 offset centre.
                                    , radius: Float 
                                    , color: Null<Int>
                                    , ?sides: Int
                                    , ?omega: Float ) -> Int = circleRadialOnSide;
}