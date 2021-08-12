package cornerContour;
interface IPen {
    public var currentColor: Int;
    public function triangle2DFill( ax: Float, ay: Float
                                  , bx: Float, by: Float
                                  , cx: Float, cy: Float
                                  , ?color: Null<Int> ): Int;
    public var pos( get, set ): Float;
    public var size( get, never ): Int;
}
