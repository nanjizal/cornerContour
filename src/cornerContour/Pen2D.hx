package cornerContour;
import cornerContour.io.Array2DTriangles;
class Pen2D implements IPen {
      public var arr = new Array2DTriangles();
      public function new( col: Int ){
          currentColor = col;
      }
      public var pos( get, set ): Float;
      inline function get_pos(): Float {
          return arr.pos;
       
      }
      inline function set_pos( val: Float ): Float {
          arr.pos = val;
          return val;
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
      /*
      // removed as lighter to do manually.
      public inline
      function applyFill( fill2D: ( Float, Float, Float, Float, Float, Float, Int )->Void ): Int {
          return arr.applyFill( fill2D );
      }
      */
      public var currentColor: Int;
}
