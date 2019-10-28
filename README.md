# hxWebsocketOpenFL_test

Testing hxWebsocketServer in an openfl project.

Requires a slightly modified version of hxWebsockets.
in WebSocketServer.hx

comment out the following

`
  MainLoop.add(function() {  
      tick();  
      Sys.sleep(sleepAmount);  
   });  
 `
