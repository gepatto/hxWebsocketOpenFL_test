package;

import signals.Signal1;
import hx.ws.SocketImpl;
import hx.ws.WebSocketHandler;

class MyHandler extends WebSocketHandler {
    public static var onStatus = new Signal1<String>();

    public function new(s:SocketImpl) {
        super(s);
        onopen = function() {
            onStatus.dispatch(id + ". OPEN");
        }
        onclose = function() {
           onStatus.dispatch(id + ". CLOSE");
        }
        onmessage = function(message) {
            trace(id + ". DATA: " + message.data.length + ", " + message.type);
            if (message.type == "text") {
               trace("echo: " + message.data);
               onStatus.dispatch( message.data.toString() );
            } else {
                trace(message.data,message.type);
            }
        }
        onerror = function(error) {
           onStatus.dispatch(id + ". ERROR: " + error);
        }
    }
}