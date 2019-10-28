package;

import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;
import openfl.events.Event;
import openfl.events.HTTPStatusEvent;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ErrorEvent;
import openfl.events.TimerEvent;
import openfl.display.Sprite;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.Assets;
import openfl.utils.Timer;

import hx.ws.Log;
import hx.ws.WebSocketServer;

class Main extends Sprite
{
	var wsserver:WebSocketServer<MyHandler>;
	var txtStatus:TextField;
	var tfStatus:TextFormat;
	var testTimer:Timer;
	var loader:URLLoader;
	var request:URLRequest;

	public function new()
	{
		super();
		
		tfStatus = new TextFormat(Assets.getFont('assets/fonts/Squada_One.ttf').name,12,0xffffff);
		tfStatus.align = TextFormatAlign.LEFT;

		txtStatus = new TextField();
		txtStatus.defaultTextFormat = tfStatus;
		txtStatus.x = 16;txtStatus.y = 16;
		txtStatus.width = 800;txtStatus.height = 600;
		addChild(txtStatus);


		MyHandler.onStatus.add( showMessage );
		Log.mask = Log.INFO | Log.DEBUG | Log.DATA;
        wsserver = new WebSocketServer<MyHandler>("127.0.0.1", 3000, 10);
        wsserver.start();

		addEventListener(Event.ENTER_FRAME, onEnterFrame);

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

		testTimer = new Timer(200,0);
		testTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent){
			loader.load(request);
		});

		testTimer.start();
	}
	
	function showMessage(msg:String){
		if(msg!=null){
			//txtStatus.appendText(msg + "\n");
			txtStatus.text = msg + "\n";
		}
	}

	function onEnterFrame(e:Event){
		wsserver.tick();
	}
}
