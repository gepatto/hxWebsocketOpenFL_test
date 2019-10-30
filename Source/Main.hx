package;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.Assets;
import hx.ws.Log;
import hx.ws.WebSocketServer;

import HttpTest;

class Main extends Sprite
{
	var wsserver:WebSocketServer<MyHandler>;
	var txtName:TextField;
	var txtStatus:TextField;
	var tfStatus:TextFormat;
	var msgBuffer:Array<String> = [];
	var httptest:HttpTest;

	public function new()
	{
		super();
		
		tfStatus = new TextFormat(Assets.getFont('assets/fonts/Squada_One.ttf').name,12,0xffffff);
		tfStatus.align = TextFormatAlign.LEFT;

		txtName = new TextField();
		txtName.defaultTextFormat =  new TextFormat(Assets.getFont('assets/fonts/Squada_One.ttf').name,18,0xffffff);
		txtName.x = 16;txtName.y = 4;
		txtName.width = 300;
		txtName.height = 16;
		txtName.text = "hxWebsocketServer OpenFL Test";
		addChild(txtName);

		txtStatus = new TextField();
		txtStatus.defaultTextFormat = tfStatus;
		txtStatus.x = 16;txtStatus.y = 32;
		txtStatus.width = stage.stageWidth - 32;
		txtStatus.height = stage.stageHeight - 56;
		txtStatus.multiline = true;
		txtStatus.border = true;
		txtStatus.borderColor = 0xe0e0e0;
		addChild(txtStatus);


		MyHandler.onStatus.add( showMessage );

		Log.mask = Log.DEBUG; //Log.INFO | Log.DEBUG | Log.DATA;

        wsserver = new WebSocketServer<MyHandler>("127.0.0.1", 3000, 10);
        wsserver.start();

		addEventListener(Event.ENTER_FRAME, e->wsserver.tick());
		stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyup);

		httptest = new HttpTest(1000);
	}

	function stage_keyup(e:KeyboardEvent){
		switch( e.keyCode ){
			case Keyboard.T:
				httptest.running?httptest.stop():httptest.start();
		}
	}
	
	function showMessage(msg:String){
		if(msg!=null){
			msgBuffer.push(msg);
			txtStatus.text = msgBuffer.join("\n");
			if(txtStatus.maxScrollV > 1){
				msgBuffer.shift();
			}
		}
	}
}
