# hxWebsocketOpenFL_test

Testing hxWebsocketServer in an openfl project.

Requires a slightly modified version of hxWebsockets.
in WebSocketServer.hx

change

`
  MainLoop.add(function() {  
      tick();  
      Sys.sleep(sleepAmount);  
   });  
 `

To

`
 #if (target.threaded)
     sys.thread.Thread.create(() -> {  
        while (true) {  
          tick();  
          Sys.sleep(sleepAmount);  
        }  
     });  
#else  
  MainLoop.add(function() {  
      tick();  
      Sys.sleep(sleepAmount);  
   });  
 #end  
`
