package cornerContour.color;

inline
function stringColor( col: Int, ?alpha: Float ): String {
    return if( alpha != null && alpha != 1.0 ){
        var r = (col >> 16) & 0xFF;
        var g = (col >> 8) & 0xFF;
        var b = (col) & 0xFF;
        'rgba($r,$g,$b,$alpha)';
    } else {
        '#' + StringTools.hex( col, 6 );
    }
}
inline
function stringHashARGB( col: Int ): String
    return '#' + StringTools.hex( col, 8 );
inline
function alphaChannel( int: Int ) : Float
    return ((int >> 24) & 255) / 255;
inline
function redChannel( int: Int ) : Float
    return ((int >> 16) & 255) / 255;
inline
function greenChannel( int: Int ) : Float
    return ((int >> 8) & 255) / 255;
inline
function blueChannel( int: Int ) : Float
    return (int & 255) / 255;
inline
function AplusRGB( col: Int, alpha: Int ): Int
    return alpha << 24 | col;
inline
function argbInt( a: Int, r: Int, g: Int, b: Int ): Int
    return ( a << 24 ) | ( r << 16 ) | ( g << 8 ) | b;
inline
function avg( p: Float, q: Float ): Float 
    return ( p + q )/2;
inline
function between( a: Float, b: Float, t: Float = 0.5 ): Float 
    return t*a + (1.-t)*b;
inline 
function alphaAvg( a: Int, b: Int  ): Float
    return avg( alphaChannel( a ),alphaChannel( b ) );
inline
function alphaBetween( a: Int, b: Int, t: Float = 0.5 ): Float
    return between( alphaChannel( a ), alphaChannel( b ), t );
inline 
function redAvg( a: Int, b: Int  ): Float
    return avg( redChannel( a ), redChannel( b ) );
inline
function redBetween( a: Int, b: Int, t: Float = 0.5 ): Float
    return between( redChannel( a ), redChannel( b ), t );
inline 
function greenAvg( a: Int, b: Int  ): Float
    return avg( greenChannel( a ), greenChannel( b ) );
inline
function greenBetween( a: Int, b: Int, t: Float = 0.5 ): Float
    return between( greenChannel( a ), greenChannel( b ), t );
inline 
function blueAvg( a: Int, b: Int  ): Float
    return avg( blueChannel( a ), blueChannel( b ) );
inline
function blueBetween( a: Int, b: Int, t: Float = 0.5 ): Float
    return between( blueChannel( a ), blueChannel( b ), t );
inline
function from_argb( a: Float, r: Float, g: Float, b: Float ): Int
    return ( toHexInt( a ) << 24 ) 
         | ( toHexInt( r ) << 16 ) 
         | ( toHexInt( g ) << 8 ) 
         |   toHexInt( b );
inline
function argbIntAvg( a: Int, b: Int ): Int
    return from_argb( alphaAvg( a, b )
                    , redAvg( a, b )
                    , greenAvg( a, b )
                    , blueAvg( a, b ) );
inline
function argbIntBetween( a: Int, b: Int, t: Float = 0.5 ): Int
     return from_argb( alphaBetween( a, b, t )
                     , redBetween(   a, b, t )
                     , greenBetween( a, b, t )
                     , blueBetween(  a, b, t ) );
inline
function hexToARGB( int: Int ):{ a: Float, r: Float, g: Float, b: Float }{
     var a = ((int >> 24) & 255) / 255;
     var r = ((int >> 16) & 255) / 255;
     var g = ((int >> 8) & 255) / 255;
     var b = (int & 255) / 255;
     return { a: a, r: r, g: g, b: b };
 }
inline
function toHexInt( c: Float ): Int
    return Math.round( c * 255 );
inline
function rgbInt( c: Int ): Int
    return ( c << 8 ) >> 8;
    

inline
function toHexInt( c: Float ): Int
    return Math.round( c * 255 );

inline
function getAlpha( c: Float ): Float
    return ((Std.int(c) >> 24) & 255 )/255;

inline
function getColor( c: Float ): Int
    return rgbInt( Std.int( c ) );
        
// throws aways alpha on c and uses the new a value.
inline
function colorAlpha( color: Int, alpha: Float ): Int
    return ( toHexInt( alpha ) << 24 ) | rgbInt( color );
class ColorHelp {
    public var rgbInt_: ( c: Int ) -> Int = rgbInt;
    public var colorAlpha_: ( color: Int, alpha: Float ) -> Int = colorAlpha;
    public var from_argb_: ( a: Float, r: Float, g: Float, b: Float ) -> Int = from_argb;
    public var toHexInt_: ( c: Float ) -> Int = toHexInt;
    public var alphaChannel_: ( int: Int ) -> Float = alphaChannel;
    public var redChannel_: ( int: Int ) -> Float = redChannel;
    public var greenChannel_: ( int: Int ) -> Float = greenChannel;
    public var blueChannel_: ( int: Int ) -> Float = blueChannel;
    
    public var argbInt_:( a: Int, r: Int, g: Int, b: Int ) -> Int = argbInt;
    public var alphaAvg_:( a: Int, b: Int  ) -> Float = alphaAvg;
    public var redAvg_:( a: Int, b: Int  ) -> Float = redAvg;
    public var greenAvg_:( a: Int, b: Int  ) -> Float = greenAvg;
    public var blueAvg_:( a: Int, b: Int  ) -> Float = blueAvg;
    public var argbIntAvg_:( c0: Int, c1: Int ) -> Int = argbIntAvg;
}