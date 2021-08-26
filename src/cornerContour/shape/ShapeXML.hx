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
    function shapeName() {
        return switch( this.name ){
            case 'rect':
                if( this.has.rx || this.has.ry ) {
                    'Rounded Rectangle';
                } else {
                    'Rectangle';
                }
            case 'circle':
                'Circle';
            case 'ellipse':
                'Ellipse';
            case 'Line':
                'Line';
            case 'polyline':
                'PolyLine';
            case 'polygon':
                'Polygon';
            case _:
                'other';
        }
    }
    public inline 
    function draw( pen: IPen ){
        var shape: Access = this;
        var att = shape.att;
        switch( shape.name ){
            case 'rect':
                if( shape.has.rx || shape.has.ry ) {
                    if( shape.has.fill ){
                        roundedRectangle( pen, parseFloat( att.x ), parseFloat( att.y )
                                        , parseFloat( att.rx ), parseFloat( att.ry )
                                        , parseFloat( att.width ), parseFloat( att.height )
                                        , parseInt( att.fill ) );
                    }
                    if( shape.has.stroke ){
                        roundedRectangleOutline( pen, parseFloat( att.x ), parseFloat( att.y )
                                        , parseFloat( att.rx ), parseFloat( att.ry )
                                        , parseFloat( att.width ), parseFloat( att.height )
                                        , parseFloat( att.stroke_width )
                                        , parseInt( att.stroke ) );
                    }
                } else {
                    if( shape.has.fill ){
                        rectangle( pen, parseFloat( att.x ), parseFloat( att.y )
                                 , parseFloat( att.width ), parseFloat( att.height )
                                 , parseInt( att.fill ) );
                    }
                    if( shape.has.stroke ){
                        rectangleOutline( pen, parseFloat( att.x ), parseFloat( att.y )
                                 , parseFloat( att.width ), parseFloat( att.height )
                                 , parseFloat( att.stroke_width )
                                 , parseInt( att.stroke ) );
                    }
                }
            case 'circle':
            // att.fill att.stroke use for filled and outline circle.
                if( shape.has.fill ){
                    circle( pen, parseFloat( att.cx ), parseFloat( att.cy )
                          , parseFloat( att.r )
                          , parseInt( att.fill ) );
                }
                if( shape.has.stroke ){
                    circleOutline( pen, parseFloat( att.cx ), parseFloat( att.cy )
                                 , parseFloat( att.r )
                                 , parseFloat( att.stroke_width )
                                 , parseInt( att.stroke ) );
                }
            case 'ellipse':
            // att.fill att.stroke use for filled and outline circle.
                if( shape.has.fill ){
                    ellipse( pen, parseFloat( att.cx ), parseFloat( att.cy )
                           , parseFloat( att.rx ), parseFloat( att.ry )
                           , parseInt( att.fill ) );
                }
                if( shape.has.stroke ){
                    ellipseOutline( pen, parseFloat( att.cx ), parseFloat( att.cy )
                                  , parseFloat( att.rx ), parseFloat( att.ry )
                                  , parseFloat( att.stroke_width )
                                  , parseInt( att.stroke ) );
                }
            case 'line':
                lineXY( pen, parseFloat( att.x1 ), Std.parseFloat( att.y1 )
                      , parseFloat( att.x2 ), parseFloat( att.y2 )
                      , parseFloat( att.stroke_width )
                      , parseInt( att.stroke ) );
            case 'polyline':
                polyline( pen, att.points
                        , parseFloat( att.stroke_width )
                        , parseInt( att.stroke ) );
            case 'polygon':
                polygon( pen, att.points, parseInt( att.fill ) );
            case _:
                'other';
        }
    }
    // perhaps too nieve
    public inline function polyline( pen: IPen, points: String, ?width = 1., ?color: Int ){
        var p = points.split(' ');
        var v: Array<String> = p[0].split(',');
        var x1 = Std.parseFloat( v[0] );
        var y1 = Std.parseFloat( v[1] );
        var x2: Float = 0;
        var y2: Float = 0;
        for( i in 1...p.length ){
            v = p[i].split(',');
            x2 = Std.parseFloat( v[0] );
            y2 = Std.parseFloat( v[1] );
            lineXY( pen, x1, y1, x2, y2, width, color );
            x1 = x2;
            y1 = y2;
        }
    }
    // perhaps too nieve
    public inline function polygon( pen: IPen, points: String, ?color: Int ){
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
            x0 = Std.parseFloat( v[0] );
            y0 = Std.parseFloat( v[1] );
            if( x0 < minX ) minX = x0;
            if( x0 > maxX ) maxX = x0;
            if( y0 < minY ) minY = y0;
            if( y0 > maxY ) maxY = y0;
            arr[i] = [ x0, y0 ];
        }
        var cx = maxX - minX;
        var cy = maxY - minY;
        x0 = arr[0][0];
        y0 = arr[0][1];
        var x1: Float = 0.;
        var y1: Float = 0.;
        for( i in 1...arr.length ){
            x1 = arr[i][0];
            y1 = arr[i][1];
            pen.triangle2DFill( x0, y0, cx, cy, x1, y1, color );
            x0 = x1;
            y0 = y1;
        }
    }
}