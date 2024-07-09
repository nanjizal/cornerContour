package cornerContour;


// some of the methods are overkill likely to pair these down slightly.
enum abstract StyleEndLine( Int ) from Int to Int {
    var no;
    var begin;
    var end;
    var both;
    var halfRound;
    var quadrant;
    var triangleBegin;
    var triangleEnd;
    var triangleBoth;
    var arrowBegin;
    var arrowEnd;
    var arrowBoth;
    var circleBegin;
    var circleEnd;
    var circleBoth;
    var squareBegin;
    var squareEnd;
    var squareBoth;
    var ellipseBegin;
    var ellipseEnd;
    var ellipseBoth;
    // overkill removed
    //var bottomHalfRound;
    //var bottomRounded;
    
    public var isNo( get, never ): Bool;
    inline function get_isNo(): Bool {
        return thisAbstract == no;
    }
    
    public var isBegin( get, never ): Bool;
    inline function get_isBegin(): Bool {
        return thisAbstract == begin;
    }
    
    public var isEnd( get, never ): Bool;
    inline function get_isEnd(): Bool {
        return thisAbstract == end;
    }
    
    public var isBoth( get, never ): Bool;
    inline function get_isBoth(): Bool {
        return thisAbstract == both;
    }
    
    public var isBeginBoth( get, never ): Bool;
    inline function get_isBeginBoth(): Bool {
        return isBegin || isBoth;
    }
    
    public var isEndBoth( get, never ): Bool;
    inline function get_isEndBoth(): Bool {
        return isEnd || isBoth;
    }
    
    public var isQuadrant( get, never ): Bool;
    inline function get_isQuadrant(): Bool {
        return thisAbstract == quadrant;
    }
    
    public var isHalfRound( get, never ): Bool;
    inline function get_isHalfRound(): Bool {
        return thisAbstract == halfRound;
    }
    
    public var isTriangleBegin( get, never ): Bool;
    inline function get_isTriangleBegin(): Bool {
        return thisAbstract == triangleBegin;
    }
    
    public var isTriangleEnd( get, never ): Bool;
    inline function get_isTriangleEnd(): Bool {
        return thisAbstract == triangleEnd;
    }
    
    public var isTriangleBoth( get, never ): Bool;
    inline function get_isTriangleBoth(): Bool {
        return thisAbstract == triangleBoth;
    }
    
    public var isTriangleBeginBoth( get, never ): Bool;
    inline function get_isTriangleBeginBoth(): Bool {
        return isTriangleBegin || isTriangleBoth;
    }
    
    public var isTriangleEndBoth( get, never ): Bool;
    inline function get_isTriangleEndBoth(): Bool {
        return isTriangleEnd || isTriangleBoth;
    }
    
    public var isArrowBegin( get, never ): Bool;
    inline function get_isArrowBegin(): Bool {
        return thisAbstract == arrowBegin;
    }
    
    public var isArrowEnd( get, never ): Bool;
    inline function get_isArrowEnd(): Bool {
        return thisAbstract == arrowEnd;
    }
    
    public var isArrowBoth( get, never ): Bool;
    inline function get_isArrowBoth(): Bool {
        return thisAbstract == arrowBoth;
    }
    
    public var isArrowBeginBoth( get, never ): Bool;
    inline function get_isArrowBeginBoth(): Bool {
        return isArrowBegin || isArrowBoth;
    }
    
    public var isArrowEndBoth( get, never ): Bool;
    inline function get_isArrowEndBoth(): Bool {
        return isArrowEnd || isArrowBoth;
    }
    
    public var isCircleBegin( get, never ): Bool;
    inline function get_isCircleBegin(): Bool {
        return thisAbstract == circleBegin;
    }
    
    public var isCircleEnd( get, never ): Bool;
    inline function get_isCircleEnd(): Bool {
        return thisAbstract == circleEnd;
    }
    
    public var isCircleBoth( get, never ): Bool;
    inline function get_isCircleBoth(): Bool {
        return thisAbstract == circleBoth;
    }
    
    public var isCircleBeginBoth( get, never ): Bool;
    inline function get_isCircleBeginBoth(): Bool {
        return isCircleBegin || isCircleBoth;
    }
    
    public var isCircleEndBoth( get, never ): Bool;
    inline function get_isCircleEndBoth(): Bool {
        return isCircleEnd || isCircleBoth;
    }
    
    public var isSquareBegin( get, never ): Bool;
    inline function get_isSquareBegin(): Bool {
        return thisAbstract == squareBegin;
    }
    
    public var isSquareEnd( get, never ): Bool;
    inline function get_isSquareEnd(): Bool {
        return thisAbstract == squareEnd;
    }
    
    public var isSquareBoth( get, never ): Bool;
    inline function get_isSquareBoth(): Bool {
        return thisAbstract == squareBoth;
    }
    
    public var isSquareBeginBoth( get, never ): Bool;
    inline function get_isSquareBeginBoth(): Bool {
        return isSquareBegin || isSquareBoth;
    }
    
    public var isSquareEndBoth( get, never ): Bool;
    inline function get_isSquareEndBoth(): Bool {
        return isSquareEnd || isSquareBoth;
    }
     
    public var isEllipseBegin( get, never ): Bool;
    inline function get_isEllipseBegin(): Bool {
        return thisAbstract == ellipseBegin;
    }
    
    public var isEllipseEnd( get, never ): Bool;
    inline function get_isEllipseEnd(): Bool {
        return thisAbstract == ellipseEnd;
    }
    
    public var isEllipseBoth( get, never ): Bool;
    inline function get_isEllipseBoth(): Bool {
        return thisAbstract == ellipseBoth;
    }
    
    public var isEllipseBeginBoth( get, never ): Bool;
    inline function get_isEllipseBeginBoth(): Bool {
        return isEllipseBegin || isEllipseBoth;
    }
    
    public var isEllipseEndBoth( get, never ): Bool;
    inline function get_isEllipseEndBoth(): Bool {
        return isEllipseEnd || isEllipseBoth;
    }
    
    // implementing self to make it easier to switch.
    public var thisAbstract( get, never ): StyleEndLine;
    inline function get_thisAbstract(): StyleEndLine {
       return ( this: StyleEndLine );
    }
    
    // DOME?
    
    public var isArc( get, never ): Bool;
    inline
    function get_isArc(): Bool {
        return isBegin || isEnd || isBoth;
    }
    
    public var isForButton( get, never ): Bool;
    inline function get_isForButton(): Bool {
        return isQuadrant || isHalfRound;
    }
    
    public var isArrow( get, never ): Bool;
    inline
    function get_isArrow(): Bool {
        return isArrowBegin || isArrowEnd || isArrowBoth;
    }
    
    public var isArrowEnding( get, never ): Bool;
    inline
    function get_isArrowEnding(): Bool {
        return isArrowEnd || isArrowBoth;
    }
    
    public var isTriangle( get, never ): Bool;
    inline
    function get_isTriangle(): Bool {
        return isTriangleBegin || isTriangleEnd || isTriangleBoth;
    }
    
    public var isSquare( get, never ): Bool;
    inline
    function get_isSquare(): Bool {
        return isSquareBegin || isSquareEnd || isSquareBoth;
    }
    
    public var isCircle( get, never ): Bool;
    inline
    function get_isCircle(): Bool {
        return isCircleBegin || isCircleEnd || isCircleBoth;
    }
    
    public var isEllipse( get, never ): Bool;
    inline
    function get_isEllipse(): Bool {
        return isEllipseBegin || isEllipseEnd || isEllipseBoth;
    }
    
    public var isBeginLine( get, never ): Bool;
    inline 
    function get_isBeginLine(): Bool {
       return switch( thisAbstract ){ 
            case begin 
               | both
               | halfRound 
               | quadrant 
               | triangleBegin 
               | triangleBoth 
               | arrowBegin 
               | arrowBoth 
               | circleBegin 
               | circleBoth
               | squareBegin
               | squareBoth
               | ellipseBegin
               | ellipseBoth :
               true;
             case no 
               | end
               | triangleEnd
               | arrowEnd
               | circleEnd
               | squareEnd
               | ellipseEnd :
               false;
        }
    }
    public var isBeginSymetrical( get, never ): Bool;
    inline 
    function get_isBeginSymetrical(): Bool {
       return switch( thisAbstract ){ 
            case begin 
               | both
               | triangleBegin 
               | triangleBoth 
               | arrowBegin 
               | arrowBoth 
               | circleBegin 
               | circleBoth 
               | squareBegin
               | squareBoth 
               | ellipseBegin
               | ellipseBoth:
               true;
             case no 
               | halfRound 
               | quadrant 
               | end
               | triangleEnd
               | arrowEnd
               | circleEnd
               | squareEnd
               | ellipseEnd:
               false;
        }
    }
    
    public var isEndLine( get, never ): Bool;
    inline 
    function get_isEndLine(): Bool {
        return switch( thisAbstract ){ 
            case end 
               | both 
               | halfRound 
               | quadrant 
               | triangleEnd 
               | triangleBoth 
               | arrowEnd 
               | arrowBoth 
               | circleEnd 
               | circleBoth 
               | squareEnd 
               | squareBoth
               | ellipseEnd
               | ellipseBoth:
               true;
             case no  
               | begin 
               | triangleBegin 
               | arrowBegin 
               | circleBegin 
               | squareBegin
               | ellipseBegin:
               false;
        }
    }
    
    public var isEndSymetrical( get, never ): Bool;
    inline 
    function get_isEndSymetrical(): Bool {
        return switch( thisAbstract ){ 
            case end 
               | both 
               | halfRound 
               | quadrant 
               | triangleEnd 
               | triangleBoth 
               | arrowEnd 
               | arrowBoth 
               | circleEnd 
               | circleBoth 
               | squareEnd 
               | squareBoth
               | ellipseEnd
               | ellipseBoth:
               true;
             case no  
               | begin 
               | triangleBegin 
               | arrowBegin 
               | circleBegin 
               | squareBegin
               | ellipseBegin:
               false;
        }
    }
    
    public var isBothLine( get, never ): Bool;
    inline 
    function get_isBothLine(){
        return switch( thisAbstract ){ 
            case both
               | halfRound 
               | quadrant 
               | triangleBoth  
               | arrowBoth  
               | circleBoth  
               | squareBoth
               | ellipseBoth :
               true;
             case no 
               | end 
               | begin 
               | triangleBegin 
               | triangleEnd 
               | arrowBegin 
               | arrowEnd 
               | circleBegin 
               | circleEnd 
               | squareBegin 
               | squareEnd 
               | ellipseBegin
               | ellipseEnd:
               false;
        }
    }

    public var hasCurves( get, never ): Bool;
    inline 
    function get_hasCurves(){
        return switch( thisAbstract ){ 
            case begin 
               | end 
               | both 
               | halfRound 
               | quadrant 
               | circleBegin 
               | circleEnd 
               | circleBoth
               | ellipseBegin
               | ellipseEnd
               | ellipseBoth:
               true;
            case no
               | triangleBegin 
               | triangleEnd 
               | triangleBoth
               | arrowBegin 
               | arrowEnd 
               | arrowBoth 
               | squareBegin 
               | squareEnd 
               | squareBoth:
               false;
        }
    }
    
    public var isStraightEdgesBegins( get, never ): Bool;
    inline
    function get_isStraightEdgesBegins(): Bool {
        return isTriangleBeginBoth || isArrowBeginBoth || isSquareBeginBoth;
    }
    
    public var isStraightEdgesEnds( get, never ): Bool;
    inline
    function get_isStraightEdgesEnds(): Bool {
        return isTriangleEndBoth || isArrowEndBoth || isSquareEndBoth;
    }
}
