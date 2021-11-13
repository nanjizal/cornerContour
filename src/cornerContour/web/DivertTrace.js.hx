package cornerContour.web;
#if js
import js.html.DivElement;
import js.Browser;
import js.html.Event;
import haxe.ds.Either;
class DivertTrace {
    var traceString:            String = '';
    var traceDiv:               DivElement;
    var textStyle0 = '<span style="font-size:12px; color:Silver">';
    var textStyle1 = '<span style="font-size:14px; color:Grey">';
    var left: Int;
    public function new( left_: Int = 610 ){
        var doc        = Browser.document;
        traceDiv       = doc.createDivElement();
        doc.body.appendChild( cast traceDiv );
        var dom        = cast traceDiv;
        var style      = dom.style;
        style.position = 'absolute';
        style.top      = px( 0 );
        style.left     = px( left_ );
        style.height   = px( 500 );
        style.width    = px( 500 );
        style.zIndex   = '99';
        style.overflow = 'auto';
        haxe.Log.trace = myTrace;
        js.Browser.window.onerror = cast myError;
        //onerror:(EitherType<Event, String>, String, Int, Int, Dynamic) ‑> Dynamic
        
    }
    inline
    function px( v: Int ): String {
        return Std.string( v + 'px' );
    }
    /*
msg – The message associated with the error, e.g. “Uncaught ReferenceError: foo is not defined”
url – The URL of the script or document associated with the error, e.g. “/dist/app.js”
lineNo – The line number (if available)
columnNo – The column number (if available)
error – The Error object associated with this error (if available)
    */
    
    function myError( msg: haxe.ds.Either<js.html.Event,String>, url: String, lineNo: Int, columnNo: Int, errorObj: Dynamic ): Dynamic {
        var arr = url.split('/');
        var file = arr[ arr.length-2 ] + ' ' + arr[ arr.length-1 ];
        var str = textStyle0;
        str += 'ERROR: '+file +' ( '+ Std.string( lineNo ) + ': ' + Std.string( columnNo ) + ' )';
        str += '</span>';
        str += '<br> - ';
        str += textStyle1;
        str += Std.string( msg );
        //str += Std.string( errorObj ); // maybe nice to extract this
        str += '</span>';
        str += '<br>';
        traceString += str;
        traceDiv.innerHTML = traceString;
        return false;
    }
    function myTrace( v : Dynamic, ?inf : haxe.PosInfos ) {
        if( Std.string( v ) == '' ) return;
        traceString += textStyle0
            	    + inf.className
                    + '.' + inf.methodName 
                    + ' ( ' + Std.string( inf.lineNumber ) + ' )'
                    + '</span>'
                    + '<br> - '
                    + textStyle1
                    + Std.string( v ) 
                    + '</span>'
                    + '<br>';
        traceDiv.innerHTML = traceString;
    }
}
#end