package com.thaumaturgistgames.flakit
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
    public class XMLLoader
    {		
        private var loader:URLLoader;
		
		public var XMLData:XML;
		public var loaded:Boolean;
    
        public function XMLLoader()
        {
			//	If the error stack is empty, we're in release mode and should search in this directory for the library path
			if (new Error().getStackTrace().search(/:[0-9]+]$/m) > -1)
				this.loader = new URLLoader(new URLRequest("../lib/Library.xml"));
			else
				this.loader = new URLLoader(new URLRequest("lib/Library.xml"));
			
            loader.addEventListener(Event.COMPLETE, onComplete);
        }
    
        private function onComplete(event:Event):void
        {
			XMLData = new XML(loader.data);
			loaded = true;
        }
    }
}