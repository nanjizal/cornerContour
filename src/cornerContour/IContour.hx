package cornerContour;

interface IContour {
    public var pointsClock:     Array<Float>;
    public var pointsAnti:      Array<Float>;
    public var endCapFactor:    Float;
    public
    function triangleJoin( ax_: Float, ay_: Float
                         , bx_: Float, by_: Float
                         , width_: Float, curveEnds: Bool = false
                         , overlap: Bool = false ): Void;
                         
    public 
    function line( ax_: Float, ay_: Float
                 , bx_: Float, by_: Float
                 , width_: Float
                 , ?endLineCurve: StyleEndLine = no ): Void;
                 
    public
    function reset(): Void;
    function end( width_: Float ): Void;
    public var mitreLimit: Float;
    public var useMitre: Bool;
}