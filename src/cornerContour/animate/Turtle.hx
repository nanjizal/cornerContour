package cornerContour.animate;
import cornerContour.Sketcher;
import cornerContour.IPen;
import cornerContour.color.ColorHelp;

class Turtle {
    // Turtle code for repeating, currently not supporting nesting, but maybe nice in future.
    // nested would likley need more complex Array structures.
    
    var rotation:                   Float = 0.;
    var lastDistance                = 0.;
    var repeatCount                 = 0;
    var repeatCommands              = false;
    var turtleCommands              = new Array<TurtleCommand>();
    var turtleParameters            = new Array<Float>();
    public var turtleHistoryOn:     Bool;
    var historyParamPos             = new Array<Int>();
    var historyCommands             = new Array<TurtleCommand>();
    var historyParameters           = new Array<Float>();
    var sketcher:                   Sketcher;
    
    public
    function new( sketcher_: Sketcher ){
        sketcher = sketcher_;
        rotation = -Math.PI/2; // North
    }
    public var argb( get, set ): Float;
    inline
    function get_argb(): Float {
        return ( sketcher.pen.currentColor: Float ); 
    }
    inline
    function set_argb( col: Float ): Float {
        sketcher.pen.currentColor = Std.int( col );
        return col;
    }
    public var x( get, set ): Float;
    inline 
    function get_x(): Float {
        return sketcher.x;
    }
    inline 
    function set_x( x_:Float ): Float {
        sketcher.x = x_;
        return x;
    }
    public var y( get, set ): Float;
    inline 
    function get_y(): Float {
        return sketcher.y;
    }
    inline 
    function set_y( y_:Float ): Float {
        sketcher.y = y_;
        return y;
    }
    public var width( get, set ): Float;
    inline 
    function get_width(): Float {
        return sketcher.width;
    }
    inline 
    function set_width( width_:Float ): Float {
        sketcher.width = width_;
        return width;
    }
    public var penIsDown( get, set ): Bool;
    inline
    function get_penIsDown(): Bool {
        return sketcher.penIsDown;
    }
    inline
    function set_penIsDown( v: Bool ): Bool {
        sketcher.penIsDown = v;
        return v;
    }
    public var fill( get, set ): Bool;
    inline
    function get_fill(): Bool {
        return sketcher.fill;
    }
    inline
    function set_fill( v: Bool ): Bool {
        sketcher.fill = v;
        return v;
    }
    inline 
    function argbAlpha( color: Float, alpha: Float = 1. ) {
        if( alpha != 1. ) color = colorAlpha( Std.int( color ), alpha ); 
        argb = Std.int( color );
    }
    public inline
    function lineStyle( thickness: Float, color: Float, alpha: Float = 1. ): Turtle {
        if( turtleHistoryOn ){
                historyAdd( LINE_STYLE );
                historyParameters.push( thickness );
                if( alpha != 1. ) color = colorAlpha( Std.int( color ), alpha ); 
                historyParameters.push( color );
            }
        if( repeatCommands ){
            turtleCommands.push( LINE_STYLE );
            historyParameters.push( thickness );
            historyParameters.push( color );
        } else {
            sketcher.lineStyle( thickness, Std.int( color ), alpha );
        }
        return this;
    }
    public function traceHistory(){
        trace( historyCommands );
        trace( historyParameters );
    }
    function historyAdd( command: TurtleCommand ): Int {
        historyParamPos.push( historyParameters.length );
        historyCommands.push( command );
        return historyParameters.length;
    }
    public
    function playHistory( start = 0, end = - 1 ){
        playCommands( historyCommands, historyParameters, start, end );
    }
    /**
     * historyUndo need to manually clear the stage
     **/
    public
    function historyUndo( autoPlay: Bool = true ){
        historyCommands.pop();
        if( autoPlay ) playHistory();
    }
    public
    function playCommands( commands: Array<TurtleCommand>, parameters: Array<Float>, start = 0, end = -1 ){
        if( end == -1 ) end = commands.length;
        var v = parameters;
        var j: Int = historyParamPos[ start ];
        turtleHistoryOn = false;
        for( i in start...end ){
            var command: TurtleCommand = commands[ i ];
            switch ( command ){
                case FORWARD:
                    forward( v[ j ] );
                    j++;
                case FORWARD_CHANGE:
                    forwardChange( v[ j ] );
                    j++;
                case FORWARD_FACTOR:
                    forwardFactor( v[ j ] );
                    j++;
                case BACKWARD:
                    backward( v[ j ] );
                    j++;
               case PEN_UP:
                   penUp();
               case PEN_DOWN:
                   penDown();
               case LEFT:
                   left( v[ j ] );
                   j++;
               case RIGHT:
                   right( v[ j ] );
                   j++;
               case SET_ANGLE:
                   setAngle( v[ j ] );
                   j++;
               case NORTH:
                   north();
               case SOUTH:
                   south();
               case WEST:
                   west();
               case EAST:
                   east();
               case SET_POSITION:
                   setPosition( v[ j ], v[ j + 1 ] );
                   j += 2;
               case PEN_SIZE:
                   penSize( v[ j ] );
                   j++;
               case PEN_SIZE_CHANGE:
                   penSizeChange( v[ j ] );
                   j++;
               case PEN_SIZE_FACTOR:
                   penSizeFactor( v[ j ] );
                   j++;
               case CIRCLE:
                   circle( v[ j ] );
                   j++;
               case CIRCLE_SIDES:
                   circle( v[ j ], v[ j + 1 ] );
                   j += 2;
               case ARC:
                   arc( v[ j ], v[ j + 1 ] );
                   j += 2;
               case ARC_SIDES:
                   arc( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case MOVE_PEN:
                   movePen( v[ j ] );
                   j++;
               case TRIANGLE_ARCH:
                   triangleArch( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case ARCH_BEZIER:
                   archBezier( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case FILL_ON:
                   fillOn();
               case FILL_OFF:
                   fillOff();
               case LINE_STYLE:
                   lineStyle( v[ j ], v[ j + 1 ] );
                   j += 2;
               case BLACK:
                   black();
               case BLUE:
                   blue();
               case GREEN:
                   green();
               case CYAN:
                   cyan();
               case RED:
                   red();
               case MAGENTA:
                   magenta();
               case YELLOW:
                   yellow();
               case WHITE:
                   white();
               case BROWN:
                   brown();
               case LIGHT_BROWN:
                   lightBrown();
               case DARK_GREEN:
                   darkGreen();
               case DARKISH_BLUE:
                   darkishBlue();
               case TAN:
                   tan();
               case PLUM:
                   plum();
               case ORANGE:
                   orange();
               case GREY:
                   grey();
               case PEN_COLOR:
                   penColor( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case PEN_COLOR_CHANGE:
                   penColorChange( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case PEN_COLOR_B: // used for gradient ( default second color )
                   penColorB( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case PEN_COLOR_CHANGE_B:
                   penColorChangeB( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;   
               case PEN_COLOR_C: // used for gradient not mostly used, even then.
                   penColorC( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case PEN_COLOR_CHANGE_C:
                   penColorChangeC( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                   j += 3;
               case BEGIN_REPEAT:
                   beginRepeat( v[ j ] );
                   j++;
               case END_REPEAT:
                   repeatEnd();
            }
        }
    }
    /**
     * currently very limited,
     * only used for circle, arc sort of and forwardTriangle/forwardCurve
     */
    public inline
    function fillOn(): Turtle {
        if( turtleHistoryOn ) historyAdd( FILL_ON );
        if( repeatCommands ){
            turtleCommands.push( FILL_ON );
        } else {
            
            fill = true;
        }
        return this;
    }
    public inline
    function fillon(): Turtle {
        return fillOn();
    }
    public inline
    function fillOff(): Turtle {
        if( turtleHistoryOn ) historyAdd( FILL_OFF );
        if( repeatCommands ){
            turtleCommands.push( FILL_OFF );
        } else {
            
            fill = false;
        }
        return this;
    }
    public inline
    function filloff(): Turtle {
        return fillOff();
    }
    public inline
    function penUp(): Turtle {
        if( turtleHistoryOn ) historyAdd( PEN_UP );
        if( repeatCommands ){
            turtleCommands.push( PEN_UP );
        } else {
            
            penIsDown = false;
        }
        return this;
    }
    public inline
    function penup(): Turtle {
        return penUp();
    }
    public inline
    function up(): Turtle {
        return penUp();
    }
    public inline
    function penDown(): Turtle {
        if( turtleHistoryOn ) historyAdd( PEN_DOWN );
        if( repeatCommands ){
            turtleCommands.push( PEN_DOWN );
        } else {
            
            penIsDown = true;
        }
        return this;
    }
    public inline
    function pendown(): Turtle {
        return penDown();
    }
    public inline
    function down(): Turtle {
        return penDown();
    }
    public inline
    function toRadians( degrees: Float ): Float {
        return degrees*Math.PI/180;
    }
    public inline
    function left( degrees: Float ): Turtle {
        if( turtleHistoryOn ) {
                historyAdd( LEFT );
                historyParameters.push( degrees );
            }
        if( repeatCommands ){
            turtleCommands.push( LEFT );
            turtleParameters.push( degrees );
        } else {
            
            rotation -= toRadians( degrees );
        }
        return this;
    }
    public inline
    function lt( degrees: Float ): Turtle {
        return left( degrees );
    }
    public inline
    function right( degrees: Float ): Turtle {
        if( turtleHistoryOn ){
                historyAdd( RIGHT );
                historyParameters.push( degrees );
            }
        if( repeatCommands ){
            turtleCommands.push( RIGHT );
            turtleParameters.push( degrees );
        } else {
            
            rotation += toRadians( degrees );
        }
        return this;
    }
    public inline
    function turn( degrees: Float ): Turtle {
        return right( degrees );
    }
    public inline
    function rt( degrees: Float ): Turtle {
        return right( degrees );
    }
    public inline
    function setAngle( degrees: Float ): Turtle {
        if( turtleHistoryOn ){
                historyAdd( SET_ANGLE );
                historyParameters.push( degrees );
            }
        
        if( repeatCommands ){
            turtleCommands.push( SET_ANGLE );
            turtleParameters.push( degrees );
        } else {
            
            rotation = -Math.PI/2;
            rotation += toRadians( degrees );
        }
        return this;
    }
    public inline
    function forward( distance: Float ): Turtle {
        if( turtleHistoryOn ){
                historyAdd( FORWARD );
                historyParameters.push( distance );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD );
            turtleParameters.push( distance );
        } else {
            
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                lastDistance = distance;
                sketcher.lineTo( nx, ny );
            } else {
                sketcher.moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function forwardChange( deltaDistance: Float ): Turtle {
        if( turtleHistoryOn ){
                historyAdd( FORWARD_CHANGE );
                historyParameters.push( deltaDistance );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD_CHANGE );
            turtleParameters.push( deltaDistance );
        } else {
            
            var distance = lastDistance + deltaDistance;
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                lastDistance = distance + deltaDistance;
                sketcher.lineTo( nx, ny );
            } else {
                sketcher.moveTo( nx, ny );
            }
        }
        return this;
    }
    /**
     * allow you to use a factor ( times ) of last forward amount
     * beware forwards is called by other functions,
     * so may get last forward updated when not expected.
     */
    public inline
    function forwardFactor( factor: Float ): Turtle {
        if( turtleHistoryOn ){
                historyAdd( FORWARD_FACTOR );
                historyParameters.push( factor );
            }
        if( repeatCommands ){
            turtleCommands.push( FORWARD_FACTOR );
            turtleParameters.push( factor );
        } else {
            
            var distance = lastDistance * factor;
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                lastDistance = distance;
                sketcher.lineTo( nx, ny );
            } else {
                sketcher.moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function triangleArch(  distance: Float, distance2: Float, radius: Float ): Turtle {
        if( turtleHistoryOn ){
                historyAdd( TRIANGLE_ARCH );
                historyParameters.push( distance );
                historyParameters.push( distance2 );
                historyParameters.push( radius );
            }
        if( repeatCommands ){
            turtleCommands.push( TRIANGLE_ARCH );
            turtleParameters.push( distance );
            turtleParameters.push( distance2 );
            turtleParameters.push( radius );
        } else {
            
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                var thruX = x + distance2*Math.cos( rotation ) - radius*Math.cos( rotation + Math.PI/2 );
                var thruY = y + distance2*Math.sin( rotation ) - radius*Math.sin( rotation + Math.PI/2 );
                if( fill ){
                    sketcher.pen.triangle2DFill( x, y, thruX, thruY, nx, ny );
                }
                sketcher.lineTo( thruX, thruY );
                sketcher.lineTo( nx, ny );
                if( fill ){
                    sketcher.lineTo( x, y );
                }
                sketcher.moveTo( nx, ny );
            } else {
                sketcher.moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function archBezier( distance: Float, distance2: Float, radius: Float ): Turtle {
        if( turtleHistoryOn ){
                historyAdd( ARCH_BEZIER );
                historyParameters.push( distance );
                historyParameters.push( distance2 );
                historyParameters.push( radius );
            }
        if( repeatCommands ){
            turtleCommands.push( ARCH_BEZIER );
            turtleParameters.push( distance );
            turtleParameters.push( distance2 );
            turtleParameters.push( radius );
        } else {
            
            var nx = x + distance*Math.cos( rotation );
            var ny = y + distance*Math.sin( rotation );
            if( penIsDown ){
                var thruX = x + distance2*Math.cos( rotation ) - radius*Math.cos( rotation + Math.PI/2 );
                var thruY = y + distance2*Math.sin( rotation ) - radius*Math.sin( rotation + Math.PI/2 );
                sketcher.quadThru( thruX, thruY, nx, ny );
            } else {
                sketcher.moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function fd( distance: Float ): Turtle {
        return forward( distance );
    }
    public inline
    function backward( distance: Float ): Turtle {
        if( turtleHistoryOn ){
                historyAdd( BACKWARD );
                historyParameters.push( distance );
            }
        if( repeatCommands ){
            turtleCommands.push( BACKWARD );
            turtleParameters.push( distance );
        } else {
            
            var nx = x + distance*Math.cos( rotation + Math.PI );
            var ny = y + distance*Math.sin( rotation + Math.PI );
            if( penIsDown ){
                sketcher.lineTo( nx, ny );
            } else {
                sketcher.moveTo( nx, ny );
            }
        }
        return this;
    }
    public inline
    function bk( distance: Float ): Turtle {
        return backward( distance );
    }
    public inline
    function movePen( distance: Float ): Turtle {
        // TODO: implement history
        if( repeatCommands ){
            turtleCommands.push( MOVE_PEN );
            turtleParameters.push( distance );
        } else {
            if( penIsDown ) {
                penUp();
                forward( distance );
                penDown();
            } else {
                forward( distance );
            }
        }
        return this;
    }
    /**
     * circle
     *
     * Draw a circle with a given radius. The center is radius units left of the turtle if positive.
     * Otherwise radius units right of the turtle if negative.
     * The circle is drawn in an anticlockwise direction if the radius is positive, otherwise, it is drawn in a clockwise direction.
     **/
     public inline
     function circle( radius: Float, sides: Float = 24 ): Turtle {
         if( turtleHistoryOn ){
                 if( sides == 24 ){
                     historyAdd( CIRCLE );
                     historyParameters.push( radius );
                 } else {
                     historyAdd( CIRCLE_SIDES );
                     historyParameters.push( radius );
                     historyParameters.push( sides );
                 }
                 }
         return if( radius == 0 ) {
             this;
         } else {
             if( repeatCommands ){
                 if( sides == 24 ){
                     turtleCommands.push( CIRCLE );
                     turtleParameters.push( radius );
                 } else {
                     turtleCommands.push( CIRCLE_SIDES );
                     turtleParameters.push( radius );
                     turtleParameters.push( sides );
                 }
             } else {
                 
                 //Isosceles 
                 var beta       = (2*Math.PI)/sides;
                 var alpha      = ( Math.PI - beta )/2;
                 var rotate     = -( Math.PI/2 - alpha );
                 var baseLength = 0.5*radius*Math.sin( beta/2 );
                 var ox = x;
                 var oy = y;
                 var arr = [];
                 for( i in 0...48 ){
                     rotation += rotate;
                     var wasHistoryOn = turtleHistoryOn;
                     turtleHistoryOn = false;
                     forward( baseLength );
                     turtleHistoryOn = wasHistoryOn;
                     if( fill ){
                         arr.push(x);
                         arr.push(y);
                     }
                 }
                 if( fill ){
                     var cx = (ox + arr[arr.length-2])/2;
                     var cy = (oy + arr[arr.length-1])/2;
                     var l = arr.length;
                     var i = 2;
                     var lx = 0.;
                     var ly = 0.;
                     while( i < l ){
                         if( i > 2 ) {
                             sketcher.pen.triangle2DFill( lx, ly, arr[i], arr[i+1], cx, cy );
                         }
                         lx = arr[i];
                         ly = arr[i+1];
                         i+=2;
                     }
                 }
                 arr.resize( 0 );
              }
              this;
         }
     }
     public inline
     function arc( radius: Float, degrees: Float, sides: Float = 24 ): Turtle {
         if( turtleHistoryOn ){
                 if( sides == 24 ){
                     historyAdd( ARC );
                     historyParameters.push( radius );
                     historyParameters.push( degrees );
                 } else {
                     historyAdd( ARC_SIDES );
                     historyParameters.push( radius );
                     historyParameters.push( degrees );
                     historyParameters.push( sides );
                 }
                 }
         return if( radius == 0 ) {
             this;
         } else {
             if( repeatCommands ){
                 if( sides == 24 ){
                     turtleCommands.push( ARC );
                     turtleParameters.push( radius );
                     turtleParameters.push( degrees );
                 } else {
                     turtleCommands.push( ARC_SIDES );
                     turtleParameters.push( radius );
                     turtleParameters.push( degrees );
                     turtleParameters.push( sides );
                 }
             } else {
                 
                 //Isosceles 
                 var beta       = toRadians( degrees )/sides;
                 var alpha      = ( Math.PI - beta )/2;
                 var rotate     = -( Math.PI/2 - alpha );
                 var baseLength = 0.5*radius*Math.sin( beta/2 );
                 var ox = x;
                 var oy = y;
                 var arr = [];
                 arr.push(x);
                 arr.push(y);
                 for( i in 0...48 ){
                    rotation += rotate;
                    var wasHistoryOn = turtleHistoryOn;
                    turtleHistoryOn = false;
                    forward( baseLength );
                    turtleHistoryOn = wasHistoryOn;
                    if( fill ){
                        arr.push(x);
                        arr.push(y);
                    }
                 }
                 if( fill ){
                     var cx = (ox + arr[arr.length-2])/2;
                     var cy = (oy + arr[arr.length-1])/2;
                     var l = arr.length;
                     var i = 2;
                     var lx = 0.;
                     var ly = 0.;
                     sketcher.pen.triangle2DFill( ox, oy, arr[0], arr[1], cx, cy );
                     while( i < l ){
                         if( i > 2 ) {
                             sketcher.pen.triangle2DFill( lx, ly, arr[i], arr[i+1], cx, cy );
                         }
                         lx = arr[i];
                         ly = arr[i+1];
                         i+=2;
                     }
                     
                 }
                 arr.resize( 0 );
              }
              this;
         }
     }
     public inline
     function north(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( NORTH );
             }
         if( repeatCommands ){
             turtleCommands.push( NORTH );
         } else {
             
             rotation = -Math.PI/2;
         }
         return this;
     }
     public inline
     function rotationReset(){
         return north();
     }
     public inline
     function west(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( WEST );
             }
         if( repeatCommands ){
             turtleCommands.push( WEST );
         } else {
             
             rotation = 0;
         }
         return this;
     }
     public inline
     function east(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( WEST );
             }
         if( repeatCommands ){
             turtleCommands.push( EAST );
         } else {
             
             rotation = Math.PI;
         }
         return this;
     }
     public inline
     function south(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( SOUTH );
             }
         if( repeatCommands ){
             turtleCommands.push( SOUTH );
         } else {
             
             rotation = Math.PI/2;
         }
         return this;
     }
     public inline
     function heading(): Float {
         var deg = 180*rotation/Math.PI;
         // TODO: rationalize..
         return deg;
     }
     public inline
     function position():{ x: Float, y: Float }{
         return { x: x, y: y };
     }
     public inline
     function goto( x: Float, y: Float ): Turtle {
         return setPosition( x, y );
     }
     public inline
     function setPosition( x: Float, y: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( SET_POSITION );
                 historyParameters.push( x );
                 historyParameters.push( y );
             }
         if( repeatCommands ){
             turtleCommands.push( SET_POSITION );
             turtleParameters.push( x );
             turtleParameters.push( y );
         } else {
             
             sketcher.moveTo( x, y );
         }
         return this;
     }
     public inline
     function setposition( x: Float, y: Float ): Turtle {
         return setPosition( x, y );
     }
     public inline
     function penSize( w: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PEN_SIZE );
                 historyParameters.push( w );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_SIZE );
             turtleParameters.push( w );
         } else {
             
             sketcher.width = w;
         }
         return this;
     }
     public inline
     function pensize( w: Float ): Turtle {
         return penSize( w );
     }
     public inline
     function penSizeChange( dw: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PEN_SIZE_CHANGE );
                 historyParameters.push( dw );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_SIZE_CHANGE );
             turtleParameters.push( dw );
         } else {
             
             sketcher.width = width + dw;
         }
         return this;
     }
     public inline
     function penSizeFactor( factor: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PEN_SIZE_FACTOR );
                 historyParameters.push( factor );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_SIZE_FACTOR );
             turtleParameters.push( factor );
         } else {
             
             sketcher.width = sketcher.width * factor;
         }
         return this;
     }
     public inline
     function repeat( repeatCount_: Float ): Turtle {
         return beginRepeat( repeatCount_ );
     }
     public inline
     function loop( repeatCount_: Float ): Turtle {
         return beginRepeat( repeatCount_ );
     }
     public inline
     function beginRepeat( repeatCount_: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( BEGIN_REPEAT );
                 historyParameters.push( Math.round( repeatCount_ ) );
             }
         if( repeatCommands == true ){
             // if currently already in repeat then end repeat and restart.
             endRepeat();
         }
         if( repeatCount_ > 0 ) {
             
             repeatCount = Math.round( repeatCount_ );
             repeatCommands = true;
             turtleCommands.resize( 0 );// = new Array<TurtleCommand>;
             turtleParameters.resize( 0 ); //= new Array<Float>;
         }
         return this;
     }
     public inline
     function loopEnd(): Turtle {
         return endRepeat();
     }
     public inline
     function repeatEnd(): Turtle {
         return endRepeat();
     }
     public inline
     function endRepeat(): Turtle {
         repeatCommands = false;
         if( turtleHistoryOn ){
             historyAdd( END_REPEAT );
         }
         var wasHistoryOn = turtleHistoryOn;
         turtleHistoryOn = false;
         var v = turtleParameters;
         var j: Int = 0;
         for( k in 0...repeatCount ){
             for( i in 0...turtleCommands.length ){
                 var command: TurtleCommand = turtleCommands[ i ];
                 switch ( command ){
                     case FORWARD:
                         forward( v[ j ] );
                         j++;
                     case FORWARD_CHANGE:
                         forwardChange( v[ j ] );
                         j++;
                     case FORWARD_FACTOR:
                         forwardFactor( v[ j ] );
                         j++;
                     case BACKWARD:
                         backward( v[ j ] );
                         j++;
                    case PEN_UP:
                        penUp();
                    case PEN_DOWN:
                        penDown();
                    case LEFT:
                        left( v[ j ] );
                        j++;
                    case RIGHT:
                        right( v[ j ] );
                        j++;
                    case SET_ANGLE:
                        setAngle( v[ j ] );
                        j++;
                    case NORTH:
                        north();
                    case SOUTH:
                        south();
                    case WEST:
                        west();
                    case EAST:
                        east();
                    case SET_POSITION:
                        setPosition( v[ j ], v[ j + 1 ] );
                        j += 2;
                    case PEN_SIZE:
                        penSize( v[ j ] );
                        j++;
                    case PEN_SIZE_CHANGE:
                        penSizeChange( v[ j ] );
                        j++;
                    case PEN_SIZE_FACTOR:
                        penSizeFactor( v[ j ] );
                        j++;
                    case CIRCLE:
                        circle( v[ j ] );
                        j++;
                    case CIRCLE_SIDES:
                        circle( v[ j ], v[ j + 1 ] );
                        j += 2;
                    case ARC:
                        arc( v[ j ], v[ j + 1 ] );
                        j += 2;
                    case ARC_SIDES:
                        arc( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case MOVE_PEN:
                        movePen( v[ j ] );
                        j++;
                    case TRIANGLE_ARCH:
                        triangleArch( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case ARCH_BEZIER:
                        archBezier( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case FILL_ON:
                        fillOn();
                    case FILL_OFF:
                        fillOff();
                    case LINE_STYLE:
                        lineStyle( v[ j ], v[ j + 1 ] );
                        j += 2;
                    case BLACK:
                        black();
                    case BLUE:
                        blue();
                    case GREEN:
                        green();
                    case CYAN:
                        cyan();
                    case RED:
                        red();
                    case MAGENTA:
                        magenta();
                    case YELLOW:
                        yellow();
                    case WHITE:
                        white();
                    case BROWN:
                        brown();
                    case LIGHT_BROWN:
                        lightBrown();
                    case DARK_GREEN:
                        darkGreen();
                    case DARKISH_BLUE:
                        darkishBlue();
                    case TAN:
                        tan();
                    case PLUM:
                        plum();
                    case ORANGE:
                        orange();
                    case GREY:
                        grey();
                    case PEN_COLOR:
                        penColor( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case PEN_COLOR_CHANGE:
                        penColorChange( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case PEN_COLOR_B: // used for gradient ( default second color )
                        penColorB( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case PEN_COLOR_CHANGE_B:
                        penColorChangeB( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;   
                    case PEN_COLOR_C: // used for gradient not mostly used, even then.
                        penColorC( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case PEN_COLOR_CHANGE_C:
                        penColorChangeC( v[ j ], v[ j + 1 ], v[ j + 2 ] );
                        j += 3;
                    case BEGIN_REPEAT:
                    case END_REPEAT:
                 }
             }
             j = 0;
         }
         turtleHistoryOn = wasHistoryOn;
         turtleCommands.resize( 0 );
         turtleParameters.resize( 0 );
         return this;
     }
     public inline
     function penColor( r: Float, g: Float, b: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PEN_COLOR );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             #if NO_ALPHA
             argb =  ( Math.round( r   * 255 ) << 16) 
                   | ( Math.round( g * 255 ) << 8) 
                   |   Math.round( b  * 255 );
             #else
             argb = ( Math.round( 1 * 255 ) << 24 ) 
                  | ( Math.round( r   * 255 ) << 16) 
                  | ( Math.round( g * 255 ) << 8) 
                  |   Math.round( b  * 255 );
            #end
         }
         return this;
     }
     public inline
     function pencolor( r: Float, g: Float, b: Float ): Turtle {
         return penColor( r, g, b );
     }
     public inline
     function penColorChange( r: Float, g: Float, b: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PEN_COLOR_CHANGE );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_CHANGE );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             var c = sketcher.pen.currentColor;
             var r0 = (( c >> 16) & 255) / 255;
             var g0 = (( c >> 8) & 255) / 255;
             var b0 = (c & 255) / 255;
             argb = ( Math.round( 1 * 255 ) << 24 ) 
                    | ( Math.round( ( r0 + r ) * 255 ) << 16) 
                    | ( Math.round( ( g0 + g ) * 255 ) << 8) 
                    |   Math.round( ( b0 + b ) * 255 );
         }
         return this;
     }
     public inline
     function penColorB( r: Float, g: Float, b: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PEN_COLOR_B );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_B );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             sketcher.pen.colorB = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( r   * 255 ) << 16) 
                                 | ( Math.round( g * 255 ) << 8) 
                                 |   Math.round( b  * 255 );
         }
         return this;
     }
     public inline
     function penColorChangeB( r: Float, g: Float, b: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PEN_COLOR_CHANGE_B );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_CHANGE_B );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             var c = sketcher.pen.colorB;
             var r0 = (( c >> 16) & 255) / 255;
             var g0 = (( c >> 8) & 255) / 255;
             var b0 = (c & 255) / 255;
             sketcher.pen.colorB = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( ( r0 + r ) * 255 ) << 16) 
                                 | ( Math.round( ( g0 + g ) * 255 ) << 8) 
                                 |   Math.round( ( b0 + b ) * 255 );
         }
         return this;
     }
     public inline
     function penColorC( r: Float, g: Float, b: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PEN_COLOR_C );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_C );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             sketcher.pen.colorC = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( r   * 255 ) << 16) 
                                 | ( Math.round( g * 255 ) << 8) 
                                 |   Math.round( b  * 255 );
         }
         return this;
     }
     public inline
     function penColorChangeC( r: Float, g: Float, b: Float ): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PEN_COLOR_CHANGE_C );
                 historyParameters.push( r );
                 historyParameters.push( g );
                 historyParameters.push( b );
             }
         if( repeatCommands ){
             turtleCommands.push( PEN_COLOR_CHANGE_C );
             turtleParameters.push( r );
             turtleParameters.push( g );
             turtleParameters.push( b );
         } else {
             
             var c = sketcher.pen.colorC;
             var r0 = (( c >> 16) & 255) / 255;
             var g0 = (( c >> 8) & 255) / 255;
             var b0 = (c & 255) / 255;
             sketcher.pen.colorC = ( Math.round( 1 * 255 ) << 24 ) 
                                 | ( Math.round( ( r0 + r ) * 255 ) << 16) 
                                 | ( Math.round( ( g0 + g ) * 255 ) << 8) 
                                 |   Math.round( ( b0 + b ) * 255 );
         }
         return this;
     }
     // Default colours may need rethink.
     public inline
     function black(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( BLACK );
             }
         if( repeatCommands ){
             turtleCommands.push( BLACK );
         } else {
             argb = TurtleBlack;
         }
         return this;
     }
     public inline
     function blue(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( BLUE );
             }
         if( repeatCommands ){
             turtleCommands.push( BLUE );
         } else {
             argb = TurtleBlue;
         }
         return this;
     }
     public inline
     function green(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( GREEN );
             }
         if( repeatCommands ){
             turtleCommands.push( GREEN );
         } else {
             argb = TurtleGreen;
         }
         return this;
     }
     public inline
     function cyan(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( CYAN );
             }
         if( repeatCommands ){
             turtleCommands.push( CYAN );
         } else {
             argb = TurtleCyan;
         }
         return this;
     }
     public inline
     function red(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( RED );
             }
         if( repeatCommands ){
             turtleCommands.push( RED );
         } else {
             argb = TurtleRed;
         }
         return this;
     }
     public inline
     function magenta(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( MAGENTA );
             }
         if( repeatCommands ){
             turtleCommands.push( MAGENTA );
         } else {
             argb = TurtleMagenta;
         }
         return this;
     }
     public inline
     function yellow(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( YELLOW );
             }
         if( repeatCommands ){
             turtleCommands.push( YELLOW );
         } else {
             argb = TurtleYellow;
         }
         return this;
     }
     public inline
     function white(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( WHITE );
             }
         if( repeatCommands ){
             turtleCommands.push( WHITE );
         } else {
             argb = TurtleWhite;
         }
         return this;
     }
     public inline
     function brown(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( BROWN );
             }
         if( repeatCommands ){
             turtleCommands.push( BROWN );
         } else {
             argb = TurtleBrown;
         }
         return this;
     }
     public inline
     function lightBrown(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( LIGHT_BROWN );
             }
         if( repeatCommands ){
             turtleCommands.push( LIGHT_BROWN );
         } else {
             argb = TurtleLightBrown;
         }
         return this;
     }
     public inline
     function darkGreen(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( DARK_GREEN );
             }
         if( repeatCommands ){
             turtleCommands.push( DARK_GREEN );
         } else {
             argb = TurtleDarkGreen;
         }
         return this;
     }
     public inline
     function darkishBlue(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( DARKISH_BLUE );
             }
         if( repeatCommands ){
             turtleCommands.push( DARKISH_BLUE );
         } else {
             argb = TurtleDarkishBlue;
         }
         return this;
     }
     public inline
     function tan(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( TAN );
             }
         if( repeatCommands ){
             turtleCommands.push( TAN );
         } else {
             argb = TurtleTan;
         }
         return this;
     }
     public inline
     function plum(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( PLUM );
             }
         if( repeatCommands ){
             turtleCommands.push( PLUM );
         } else {
             argb = TurtlePlum;
         }
         return this;
     }
     public inline
     function orange(): Turtle {
             if( turtleHistoryOn ){
                 historyAdd( ORANGE );
             }
         if( repeatCommands ){
             turtleCommands.push( ORANGE );
         } else {
             argb = TurtleOrange;
         }
         return this;
     }
     public inline
     function grey(): Turtle {
         if( turtleHistoryOn ){
                 historyAdd( GREY );
             }
         if( repeatCommands ){
             turtleCommands.push( GREY );
         } else {
             argb = TurtleGrey;
         }
         return this;
     }
}

@:forward
enum abstract TurtleCommand( String ) to String from String {
    var BEGIN_REPEAT = 'BEGIN_REPEAT';
    var END_REPEAT = 'END_REPEAT';
    // note don't need the actual string as compiler an infer ... but leave for now.
    var FORWARD = 'FORWARD';
    var FORWARD_CHANGE = 'FORWARD_CHANGE';
    var FORWARD_FACTOR = 'FORWARD_FACTOR';
    var BACKWARD = 'BACKWARD';
    var PEN_UP = 'PEN_UP';
    var PEN_DOWN = 'PEN_DOWN';
    var LEFT = 'LEFT';
    var RIGHT = 'RIGHT';
    var SET_ANGLE = 'SET_ANGLE';
    var NORTH = 'NORTH';
    var SOUTH = 'SOUTH';
    var WEST = 'WEST';
    var EAST = 'EAST';
    var SET_POSITION = 'SET_POSITION';
    var PEN_SIZE = 'PEN_SIZE';
    var PEN_SIZE_CHANGE = 'PEN_SIZE_CHANGE';
    var PEN_SIZE_FACTOR = 'PEN_SIZE_FACTOR';
    var CIRCLE = 'CIRCLE'; // CONSIDER DOT FOR FILLED ONE!
    var CIRCLE_SIDES = 'CIRCLE_SIDES';
    var ARC = 'ARC';
    var ARC_SIDES = 'ARC_SIDES';
    var MOVE_PEN = 'MOVE_PEN';
    var TRIANGLE_ARCH = 'TRIANGLE_ARCH';
    var ARCH_BEZIER = 'ARCH_BEZIER';
    var FILL_ON = 'FILL_ON';
    var FILL_OFF = 'FILL_OFF';
    var LINE_STYLE = 'LINE_STYLE';
    // Colors as per... https://fmslogo.sourceforge.io/workshop/
    // reconsider names!
    var PEN_COLOR   = 'PEN_COLOR';
    var PEN_COLOR_CHANGE = 'PEN_COLOR_CHANGE';
    var PEN_COLOR_CHANGE_B = 'PEN_COLOR_CHANGE_B';
    var PEN_COLOR_CHANGE_C = 'PEN_COLOR_CHANGE_C';
    var PEN_COLOR_B = 'PEN_COLOR_B'; // used for gradients
    var PEN_COLOR_C = 'PEN_COLOR_C';
    var BLACK       = 'BLACK'; // 	[0 0 0] 	 
    var BLUE        = 'BLUE'; //1 	blue 	[0 0 255] 	 
    var GREEN       = 'GREEN';// 2 	green 	[0 255 0] 	 
    var CYAN        = 'CYAN';//3 	cyan (light blue) 	[0 255 255] 	 
    var RED         = 'RED';//4 	red 	[255 0 0] 	 
    var MAGENTA     = 'MAGENTA';//5 	magenta (reddish purple) 	[255 0 255] 	 
    var YELLOW      = 'YELLOW';//6 	yellow 	[255 255 0] 	 
    var WHITE       = 'WHITE';//7 	white 	[255 255 255] 	 
    var BROWN       = 'BROWN';//8 	brown 	[155 96 59] 	 
    var LIGHT_BROWN = 'LIGHT_BROWN';//9 	light brown 	[197 136 18] 	 
    var DARK_GREEN  = 'DARK_GREEN';//10 	dark green 	[100 162 64] 	 
    var DARKISH_BLUE = 'DARKISH_BLUE';// 11 	darkish blue 	[120 187 187] 	 
    var TAN          = 'TAN';//12 	tan 	[255 149 119] 	 
    var PLUM         = 'PLUM';//13 	plum (purplish) 	[144 113 208] 	 
    var ORANGE       = 'ORANGE';//14 	orange 	[255 163 0] 	 
    var GREY         = 'GREY';//15 	gray 	[183 183 183]
}

#if NO_ALPHA
// useful for canvas
@:forward
enum abstract TurtleColors( Int ) to Int from Int {
    var TurtleBlack       = 0x000000;
    var TurtleBlue        = 0x0000FF;
    var TurtleGreen       = 0x00FF00; 
    var TurtleCyan        = 0x00FFFF;
    var TurtleRed         = 0xFF0000;
    var TurtleMagenta     = 0xFF00FF;	 
    var TurtleYellow      = 0xFFFF00; 
    var TurtleWhite       = 0xFFFFFF;
    var TurtleBrown       = 0x9B603B;	 
    var TurtleLightBrown  = 0xC58812;	 
    var TurtleDarkGreen   = 0x64A240; 
    var TurtleDarkishBlue = 0x78BBBB; 
    var TurtleTan         = 0xFF9577;
    var TurtlePlum        = 0x9071D0; 
    var TurtleOrange      = 0xFFA300;
    var TurtleGrey        = 0xB7B7B7;
}
#else
@:forward
enum abstract TurtleColors( Int ) to Int from Int {
    var TurtleBlack       = 0xFF000000;
    var TurtleBlue        = 0xFF0000FF;
    var TurtleGreen       = 0xFF00FF00; 
    var TurtleCyan        = 0xFF00FFFF;
    var TurtleRed         = 0xFFFF0000;
    var TurtleMagenta     = 0xFFFF00FF;	 
    var TurtleYellow      = 0xFFFFFF00; 
    var TurtleWhite       = 0xFFFFFFFF;
    var TurtleBrown       = 0xFF9B603B;	 
    var TurtleLightBrown  = 0xFFC58812;	 
    var TurtleDarkGreen   = 0xFF64A240; 
    var TurtleDarkishBlue = 0xFF78BBBB; 
    var TurtleTan         = 0xFFFF9577;
    var TurtlePlum        = 0xFF9071D0; 
    var TurtleOrange      = 0xFFFFA300;
    var TurtleGrey        = 0xFFB7B7B7;
}
#end
#if INCLUDE_TURTLE_RGB_ARRAY
// mainly for reference
enum abstract TurtleRGB( String )  {
    var TurtleRGB_BLACK        = '0,0,0';
    var TurtleRGB_BLUE         = '0,0,255';
    var TurtleRGB_GREEN        = '0,255,0';
    var TurtleRGB_CYAN         = '0,255,255';
    var TurtleRGB_RED          = '255,0,0';
    var TurtleRGB_MAGENTA      = '255,0,255';
    var TurtleRGB_YELLOW       = '255,255,0';
    var TurtleRGB_WHITE        = '255,255,255';
    var TurtleRGB_BROWN        = '155,96,59';
    var TurtleRGB_LIGHT_BROWN  = '197,136,18';
    var TurtleRGB_DARK_GREEN   = '100,162,64';
    var TurtleRGB_DARKISH_BLUE = '120,187,187';
    var TurtleRGB_TAN          = '255,149,119';
    var TurtleRGB_PLUM         = '144,113,208';
    var TurtleRGB_ORANGE       = '255,163,0';
    var TurtleRGB_GREY         = '183,183,183';
    public inline function getRGB( c: TurtleRGB ): Array<Int>{
        var arrS =  cast( c, String ).split(',');
        var arrI = new Array<Int>();
        for( i in 0...arrS.length ){
            arrI[i] = Std.parseInt( arrS[i] );
        }
        return arrI;
    }
}
#end