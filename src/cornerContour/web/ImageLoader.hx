package cornerContour.web;

// taken from my htmlHelper added promise approach.
import js.Lib;
import js.html.ImageElement;
import js.html.Event;
import js.html.Document;
import js.Browser;
import js.html.Image;
import js.lib.Promise;

typedef Hash<T> = haxe.ds.StringMap<T>;
class ImageLoader{
    public var images:   Hash<Image>;//Hash<ImageElement>;
    public var imageArr: Array<Image>;//Array<ImageElement>;
    var imageLoaded: ( String, Int ) -> Void;
    var imageFinish: Void -> Void;
    private var loaded:  Void -> Void;
    private var count:   Int;
    public
    function new( imageNames: Array<String>, loaded_: Void -> Void, traceOut: Bool = false ){
        images = new Hash();
        if( traceOut == true ) {
            imageLoaded = traceImageLoad;
            imageFinish = traceFinish;
        }
        imageArr = new Array<Image>();//Array<ImageElement>();
        loaded = loaded_;
        count = imageNames.length;
        for( name in imageNames ) load( name );
    }
    function traceImageLoad( name: String, count: Int ): Void {
        trace( 'store ' + name + ' ' + count ); 
    }
    function traceFinish(){
        trace('finish');
    }
    function load( img: String ){ 
        // var image: ImageElement     = js.Browser.document.createImageElement();
        var image: Image = js.Syntax.code( "new Image()" );
        var imgStyle                = image.style;
        topLeft( image );
        image.onload                = store.bind( image, img.split('/').pop() );
        image.src                   = img;
    }
    // for use when images are base64 encoded to a string.
    public
    function loadEncoded( imageEncoded: Array<String>, imageNames: Array<String> ){
        count = imageNames.length;
        for( i in 0...count ){ 
            trace( 'loadEncoded ' + i + 'imageNames ' + imageNames[i] );
            encodedLoad( imageEncoded[ i ],  imageNames[ i ], i ); 
        }
    }
    // for use when image is base64 encoded to a string.
    function encodedLoad( imgStr: String, name: String, index: Int ){
        trace(' load encode ');
        //var image: ImageElement     = js.Browser.document.createImageElement();
        var image: Image = js.Syntax.code( "new Image()" );
        topLeft( image );
        image.onload                = store.bind( image, name, index );
        image.src                   = imgStr;
        trace( image );
    }
    function topLeft( image: ImageElement ){
        var imgStyle                = image.style;
        imgStyle.left               = '0px';
        imgStyle.top                = '0px';
        imgStyle.paddingLeft        = "0px";
        imgStyle.paddingTop         = "0px";
        imgStyle.position           = "absolute";
    }
    function store( image: Image /*ImageElement*/, name: String, index: Int, e: Event ){
        count--;
        if( imageLoaded != null ) imageLoaded( name, count );
        images.set( name, image );
        imageArr[ index ] = image;
        if( count == 0 ){
            loaded();
            if( imageFinish != null ) imageFinish();
        }
    }
    public static inline
    function loadImagePromise( url: String, drawn ) {
        return new Promise( function( resolve, reject ) {
            var image = new Image();
            image.onload = function () {
                //image.crossOrigin = "";
                resolve( drawn( image ) );
            }
            image.src = url;
      });
    }
    
}