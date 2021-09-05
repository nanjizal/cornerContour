package cornerContour;
import cornerContour.io.Array2DTriangles;
import cornerContour.io.Array2DTriGrad;
/*
typedef PosSizeContraint = {
    // <T:PosSizeContraint>
    public var pos( get, set ): Float;
    public var size( get, never ): Int;
}
*/
class Pen2DGrad implements IPen {
      public var arr = new Array2DTriGrad(); 
      public function new( col: Int, ?colB: Null<Int>, ?colC: Null<Int> ){
          trace( 'Pen2DGrad ');
          currentColor = col;
          trace( ' arr ' + arr );
          var hasB = ( colB == null );
          var hasC = ( colC == null );
          //var isGrad = hasB && hasC;
          
          if( !hasB ) colB = col;
          colorB = colB;
          if( !hasC ) colC = col;
          colorC = colC;
      }
      public var pos( get, set ): Float;
      inline function get_pos(): Float {
          return arr.pos;
       
      }
      inline function set_pos( val: Float ): Float {
          arr.pos = val;
          return val;
      }
      public var size( get, never ): Int;
      inline function get_size(): Int {
          var v = arr.size;
          return v;
      }
      public inline
      function triangle2DFill( ax: Float, ay: Float
                                  , bx: Float, by: Float
                                  , cx: Float, cy: Float
                                  , ?color: Null<Int> ): Int {
          if( color == null || color == -1 ) color = currentColor;
          arr.triangle2DFill( ax, ay, bx, by, cx, cy, color );
          arr.pos = arr.pos + 1;
          return 1;
      }
      public function triangle2DGrad( ax: Float, ay: Float
                                    , bx: Float, by: Float
                                    , cx: Float, cy: Float
                                    , ?colorA: Null<Int>, ?colorB: Null<Int>, ?colorC: Null<Int> ): Int {
          if( colorA == null || colorA == -1 ) colorA = currentColor;
          if( colorB == null || colorB == -1 ) colorB = this.colorB;
          if( colorC == null || colorC == -1 ) colorC = this.colorC;
          arr.triangle2DGrad( ax, ay, bx, by, cx, cy, colorA, colorB, colorC );
          arr.pos = arr.pos + 1;
          return 1;
      }
      /*
      // removed as lighter to do manually.
      public inline
      function applyFill( fill2D: ( Float, Float, Float, Float, Float, Float, Int )->Void ): Int {
          return arr.applyFill( fill2D );
      }
      */
      public var currentColor: Int;
      public var colorB: Int;
      public var colorC: Int;
}