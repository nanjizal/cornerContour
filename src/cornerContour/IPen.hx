package cornerContour;
interface IPen {
    public var currentColor: Int;
    public var colorB: Int;
    public var colorC: Int;
    public function triangle2DFill( ax: Float, ay: Float
                                  , bx: Float, by: Float
                                  , cx: Float, cy: Float
                                  , ?color: Null<Int> ): Int;
    public function triangle2DGrad( ax: Float, ay: Float
                                  , bx: Float, by: Float
                                  , cx: Float, cy: Float
                                  , ?colorA: Null<Int>, ?colorB: Null<Int>, ?colorC: Null<Int> ): Int;
    public var pos( get, set ): Float;
    public var size( get, never ): Int;
}
