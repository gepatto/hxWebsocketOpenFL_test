package;

import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.events.IOErrorEvent;
import openfl.events.ErrorEvent;
import openfl.events.HTTPStatusEvent;
import openfl.events.Event;
import openfl.net.URLRequest;
import openfl.net.URLLoader;

class HttpTest{
    
    var testTimer:Timer;
    var loader:URLLoader;
	var request:URLRequest;

	public var running:Bool = false;

    public function new(?requestDelay:Int=500){
       
        loader = new URLLoader();
		request = new URLRequest("http://127.0.0.1:3000");

		//request.method = URLRequestMethod.GET;
		loader.addEventListener(Event.COMPLETE, function(e:Event) {
			trace("complete", e);
		});
		loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(e:HTTPStatusEvent) {
			trace("HTTPSTATUS", e.status);
		});
		loader.addEventListener(ErrorEvent.ERROR, function(err:ErrorEvent) {
			trace("Error", err.text);
		});
		loader.addEventListener(IOErrorEvent.IO_ERROR, function(err:IOErrorEvent) {
			trace("IOError", err.text);
		});

		testTimer = new Timer(requestDelay,0);
		testTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent){
			loader.load(request);
		});

    }

    public function start(){
        loader.load(request);
		testTimer.start();
		running = true;
    }

     public function stop(){
		testTimer.reset();
		running = false;
    }
    
}