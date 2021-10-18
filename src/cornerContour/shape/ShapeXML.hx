package cornerContour.shape;
import cornerContour.shape.Circles;
import cornerContour.shape.Ellipses;
import cornerContour.shape.Lines;
import cornerContour.shape.Pies;
import cornerContour.shape.Quads;
import haxe.xml.Access;

inline function parseFloat( s: String ){
    return Std.parseFloat( s );
}
inline function parseInt( s: String ){
    return Std.parseInt( s );
}
enum abstract ShapeSvgName( String ) from String to String {
    var svgRect     = 'rect';
    var svgCircle   = 'circle';
    var svgEllipse  = 'ellipse';
    var svgLine     = 'line';
    var svgPolyline = 'polyline';
    var svgPolygon  = 'polygon';
    var svgNone     = 'none';
}
/*
// need to consider rotation?
enum abstact ShapeRegularName( String ) from String to String {
    var svgRegularTriangle  = 'regularTriangle';
    var svgSquare           = 'square';
    var svgRegularPentagon  = 'regularPentagon';
    var svgRegularHexagon   = 'regularHexagon';
}
*/
@:forward
abstract ShapeXML( haxe.xml.Access ) {
    inline function new(xml:haxe.xml.Access ){
        this = xml;
    }
    @:from
    static public function fromString(s:String) {
        var accessXML = new haxe.xml.Access( Xml.parse(s).firstElement() );
        return new ShapeXML( accessXML );
    }
    public inline
    function shapeName(): String {
        //var shapeName: ShapeSvgName = cast( this.name, ShapeSvgName );
        var shape: Access = this;
        return switch( shape.name ){
            case svgRect:
                if( this.has.rx || this.has.ry ) {
                    'Rounded Rectangle';
                } else {
                    'Rectangle';
                }
            case svgCircle:
                'Circle';
            case svgEllipse:
                'Ellipse';
            case svgLine:
                'Line';
            case svgPolyline:
                'PolyLine';
            case svgPolygon:
                'Polygon';
            case _:
                'other';
        }
    }
    public inline 
    function draw( pen: IPen
                 , dx: Float = 0., dy: Float = 0.
                 , sx: Float = 1., sy: Float = 1.
                 , scaleThick: Float = 1. ){
        var shape: Access = this;
        var att = shape.att;
        var thick = 1.;
        var px = dx;
        var py = dy;
        var rx = 0.5;
        var ry = 0.5;
        var width = 100.;
        var height = 100.;
        var stroke = 0xFF000000;
        var fill = 0xFF000000;
        var x2 = 100.;
        var y2 = 100.;
        var r = 0.;
        if( shape.has.x )      px =     dx + parseFloat( att.x );
        if( shape.has.y )      py =     dy + parseFloat( att.y );
        if( shape.has.width )  width =  sx * parseFloat( att.width );
        if( shape.has.height ) height = sy * parseFloat( att.height );
        if( shape.has.rx )     rx =     sx * parseFloat( att.rx );
        if( shape.has.ry )     ry =     sy * parseFloat( att.ry );
        if( shape.has.cx )     px =     dx + parseFloat( att.cx );
        if( shape.has.cy )     py =     dy + parseFloat( att.cy );
        
        if( shape.has.x1 )     px =     dx + parseFloat( att.x1 );
        if( shape.has.y1 )     py =     dy + parseFloat( att.y1 );
        if( shape.has.x2 )     x2 =     px + sx * ( parseFloat( att.x2 ) - parseFloat( att.x1 ) );
        if( shape.has.y2 )     y2 =     py + sy * ( parseFloat( att.y2 ) - parseFloat( att.y1 ) );
        
        if( shape.has.r )      r =      parseFloat( att.r )*(sx+sy)/2;
        if( shape.has.fill )   fill =   parseInt( att.fill );
        if( shape.has.stroke ) stroke = parseInt( att.stroke );
        if( shape.has.stroke_width ) thick = scaleThick * parseFloat( att.stroke_width );
        
        switch( shape.name ){
            case svgRect:
                if( shape.has.rx || shape.has.ry ) {
                    if( shape.has.fill ){
                        if( att.fill != 'transparent' ){
                            roundedRectangle( pen, px, py, rx, ry, width, height, fill );
                        }
                    }
                    if( shape.has.stroke ){
                        roundedRectangleOutline( pen, px, py, rx, ry, width, height, thick, stroke );
                    }
                } else {
                    if( shape.has.fill ){
                        if( att.fill != 'transparent' ){
                            rectangle( pen, px, py, width, height, fill );
                        }
                    }
                    if( shape.has.stroke ){
                        rectangleOutline( pen, px, py, width, height, thick, thick, stroke );
                    }
                }
            case svgCircle:
                if( shape.has.fill ){
                    if( att.fill != 'transparent' ){
                        circle( pen, px, py, r, fill );
                    }
                }
                if( shape.has.stroke ){
                    circleOutline( pen, px, py, r, thick, stroke );
                }
            case svgEllipse:
                if( shape.has.fill ){
                    if( att.fill != 'transparent' ){
                        ellipse( pen, px, py, rx, ry, fill );
                    }
                }
                if( shape.has.stroke ){
                    ellipseOutline( pen, px, py, rx, ry, thick, stroke );
                }
            case svgLine:
                lineXY( pen, px, py, x2, y2, thick, stroke );
            case svgPolyline:
            //trace('drawing polyline');
                polyline( pen, att.points, thick, stroke, dx, dy, sx, sy );
            case svgPolygon:
                if( shape.has.fill ){
                    if( att.fill != 'transparent' ){
                        polygon( pen, att.points, fill, dx, dy, sx, sy );
                    }
                }
                if( shape.has.stroke ){
                    polylineJoin( pen, att.points, thick, stroke, dx, dy, sx, sy );
                }
            case _:
                'other';
        }
    }
    // perhaps too nieve
    public inline function polyline( pen: IPen, points: String, ?width = 1., ?color: Int
                                   , dx: Float = 0., dy: Float = 0.
                                   , sx: Float = 1., sy: Float = 1.
                                   ){
        var p = points.split(' ');
        var v: Array<String> = p[0].split(',');
        var x1 = dx + Std.parseFloat( v[0] ) * sx;
        var y1 = dy + Std.parseFloat( v[1] ) * sy;
        var x2: Float = 0;
        var y2: Float = 0;
        for( i in 1...p.length ){
            v = p[i].split(',');
            x2 = dx + Std.parseFloat( v[0] ) * sx;
            y2 = dy + Std.parseFloat( v[1] ) * sy;
            lineXY( pen, x1, y1, x2, y2, width, color );
            x1 = x2;
            y1 = y2;
        }
    }
    public inline function polylineJoin( pen: IPen, points: String, ?width = 1., ?color: Int
                                   , dx: Float = 0., dy: Float = 0.
                                   , sx: Float = 1., sy: Float = 1.
                                   ){
        var p = points.split(' ');
        var v: Array<String> = p[0].split(',');
        var x1 = dx + Std.parseFloat( v[0] ) * sx;
        var y1 = dy + Std.parseFloat( v[1] ) * sy;
        var ox = x1;
        var oy = y1;
        var x2: Float = 0;
        var y2: Float = 0;
        for( i in 1...p.length ){
            v = p[i].split(',');
            x2 = dx + Std.parseFloat( v[0] ) * sx;
            y2 = dy + Std.parseFloat( v[1] ) * sy;
            lineXY( pen, x1, y1, x2, y2, width, color );
            x1 = x2;
            y1 = y2;
        }
        lineXY( pen, x1, y1, ox, oy, width, color );
    }
    // perhaps too nieve
    public inline function polygon( pen: IPen, points: String, ?color: Int
                                   , dx: Float = 0., dy: Float = 0.
                                   , sx: Float = 1., sy: Float = 1.
                                   ){
        var p = points.split(' ');
        var v: Array<String> = p[0].split(',');
        var arr = new Array<Array<Float>>();
        var x0: Float;
        var y0: Float;
        var minX = 10000000.0;
        var maxX = -10000000.0;
        var minY = 100000000.0;
        var maxY = -100000000.0;
        for( i in 0...p.length ){
            v = p[i].split(',');
            x0 = dx + Std.parseFloat( v[0] ) * sx;
            y0 = dy + Std.parseFloat( v[1] ) * sy;
            if( x0 < minX ) minX = x0;
            if( x0 > maxX ) maxX = x0;
            if( y0 < minY ) minY = y0;
            if( y0 > maxY ) maxY = y0;
            arr[i] = [ x0, y0 ];
        }
        var cx = minX + ( maxX - minX )/2;
        var cy = minY + ( maxY - minY )/2;
        //circle( pen, cx, cy, 10, 0xFF0000 );
        x0 = arr[0][0];
        y0 = arr[0][1];
        var ox = x0;
        var oy = y0;
        var x1: Float = 0.;
        var y1: Float = 0.;
        for( i in 1...arr.length ){
            x1 = arr[i][0];
            y1 = arr[i][1];
            pen.triangle2DFill( x0, y0, cx, cy, x1, y1, color );
            x0 = x1;
            y0 = y1;
        }
        pen.triangle2DFill( x0, y0, cx, cy, ox, oy, color );
    }
}