package cornerContour.color;

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
function argbInt( a: Int, r: Int, g: Int, b: Int ): Int
    return ( a << 24 ) | ( r << 16 ) | ( g << 8 ) | b;
    
inline 
function alphaAvg( a: Int, b: Int  ): Float {
    return (alphaChannel(a)+alphaChannel(b))/2;
}
inline
function alphaBetween( a: Int, b: Int, t0: Float = 0.5 ){
    var t1 = 1.-t0;
    return t0*alphaChannel(a) + t1*alphaChannel(b);
}
inline 
function redAvg( a: Int, b: Int  ): Float {
    return (redChannel(a)+redChannel(b))/2;
}
inline
function redBetween( a: Int, b: Int, t0: Float = 0.5 ){
    var t1 = 1.-t0;
    return t0*redChannel(a) + t1*redChannel(b);
}
inline 
function greenAvg( a: Int, b: Int  ): Float {
    return (greenChannel(a)+greenChannel(b))/2;
}
inline
function greenBetween( a: Int, b: Int, t0: Float = 0.5 ){
    var t1 = 1.-t0;
    return t0*greenChannel(a) + t1*greenChannel(b);
}
inline 
function blueAvg( a: Int, b: Int  ): Float {
    return (blueChannel(a)+blueChannel(b))/2;
}
inline
function blueBetween( a: Int, b: Int, t0: Float = 0.5 ){
    var t1 = 1.-t0;
    return t0*blueChannel(a) + t1*blueChannel(b);
}
inline
function from_argb( a: Float, r: Float, g: Float, b: Float ): Int
    return ( toHexInt( a ) << 24 ) 
         | ( toHexInt( r ) << 16 ) 
         | ( toHexInt( g ) << 8 ) 
         |   toHexInt( b );    
 inline
 function argbIntBetween( c0: Int, c1: Int, t: Float = 0.5 ): Int {
     var a = alphaBetween( c0, c1, t );
     var r = redBetween(   c0, c1, t );
     var g = greenBetween( c0, c1, t );
     var b = blueBetween(  c0, c1, t );
     return from_argb( a, r, g, b );
 }
inline
function argbIntAvg( c0: Int, c1: Int ): Int {
    var a = alphaAvg( c0, c1 );
    var r = redAvg(   c0, c1 );
    var g = greenAvg( c0, c1 );
    var b = blueAvg(  c0, c1 );
    return from_argb( a, r, g, b );
}
inline
function toHexInt( c: Float ): Int
    return Math.round( c * 255 );
inline
function rgbInt( c: Int ): Int
    return ( c << 8 ) >> 8;
inline
function colorAlpha( color: Int, alpha: Float ){
    // throws aways alpha on c and uses the new a value.
    return ( toHexInt( alpha ) << 24 ) | rgbInt( color );
}
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