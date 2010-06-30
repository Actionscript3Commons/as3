/**
 * Out by Big Spaceship. 2006-2010
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2006-2010 Big Spaceship, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/
package com.bigspaceship.utils
{
	import com.bigspaceship.events.OutEvent;
	import com.bigspaceship.utils.out.adaptors.IOutAdapter;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Out
	 *
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			
	 * @version			1.1
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class Out extends EventDispatcher{
		
		public  static const INFO      : Number = 0;
		public  static const STATUS    : Number = 1;
		public  static const DEBUG     : Number = 2;
		public  static const WARNING   : Number = 3;
		public  static const ERROR     : Number = 4;
		public  static const FATAL     : Number = 5;
		
		private static var __levels    : Array  = [];
		private static var __silenced  : Object = {};
		private static var __instance  : Out;	
		
		private static var __debuggers	: Array = [];
		
		public function Out() {}
		
		/**
		 * Enable a specific debugging level 
		 * @param $level The level to enable
		 */		
		public static function enableLevel($level:Number):void {
			__levels[$level] = __output;
		}
		
		/**
		 * Disable a specific debugging level 
		 * @param $level The level to disable
		 */		
		public static function disableLevel($level:Number):void {
			__levels[$level] = null;
		}
		
		/**
		 * Enable all debugging levels 
		 */		
		public static function enableAllLevels():void {
			enableLevel(INFO   );
			enableLevel(STATUS );
			enableLevel(DEBUG  );
			enableLevel(WARNING);
			enableLevel(ERROR  );
			enableLevel(FATAL  );
		}
		
		/**
		 * Disable all debugging levels 
		 */		
		public static function disableAllLevels():void {
			disableLevel(INFO   );
			disableLevel(STATUS );
			disableLevel(DEBUG  );
			disableLevel(WARNING);
			disableLevel(ERROR  );
			disableLevel(FATAL  );
		}
		
		public static function registerDebugger($debugger:IOutAdapter):void {
			__debuggers[__debuggers.length] = $debugger;
		}
		
		/**
		 * Check to see if an object is currently being silenced 
		 * @param $o The object being checked
		 * @return A boolean indicating it's silenced state 
		 * @see silence
		 * @see unsilence
		 */
		public static function isSilenced($o:*):Boolean {
			var s:String = __getClassName($o);
			
			return __silenced[s];
		}
		
		/**
		 * Silence a specific object from making debug calls. 
		 * @param $o
		 * @see unsilence
		 */
		public static function silence($o:*):void {
			var s:String = __getClassName($o);
			
			__silenced[s] = true;
		}
		
		/**
		 * Enable an object to start making debug calls again after it has been silenced using <code>silence</code>.
		 * @param $o
		 * @see silence
		 */
		public static function unsilence($o:*):void {
			var s:String = __getClassName($o);
			
			__silenced[s] = false;
		}
		
		public static function info($origin:*, ...$args):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(INFO) && __levels[INFO]!=null)
				__levels[INFO].apply(null, ["INFO", $origin, OutEvent.INFO].concat($args) );
		}
		
		public static function status($origin:*, ...$args):void {
			if(isSilenced($origin)) return;

			if(__levels.hasOwnProperty(STATUS) && __levels[STATUS]!=null)
				__levels[STATUS].apply(null, ["STATUS", $origin, OutEvent.STATUS].concat($args) );
		}
		
		public static function debug($origin:*, ...$args):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(DEBUG) && __levels[DEBUG]!=null)
				__levels[DEBUG].apply(null, ["DEBUG", $origin, OutEvent.DEBUG].concat($args) );
		}
		
		public static function warning($origin:*, ...$args):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(WARNING) && __levels[WARNING]!=null)
				__levels[WARNING].apply(null, ["WARNING", $origin, OutEvent.WARNING].concat($args) );
		}
		
		public static function error($origin:*, ...$args):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(ERROR) && __levels[ERROR]!=null)
				__levels[ERROR].apply(null, ["ERROR", $origin, OutEvent.ERROR].concat($args) );
		}
		
		public static function fatal($origin:*, $str:String, ...$args):void {
			if(isSilenced($origin)) return;
			
			if(__levels.hasOwnProperty(FATAL) && __levels[FATAL]!=null)
				__levels[FATAL].apply(null, ["FATAL", $origin, OutEvent.FATAL].concat($args) );
		}
		
		/**
		 * Sends a clear message to any registered debuggers.  Doesn't do anything within the IDE.
		 */
		public static function clear():void {
			if(__debuggers.length)
				for each(var i:IOutAdapter in __debuggers) i.clear();
		}
		
		public static function traceObject($origin:*, $str:String, $obj:*):void {
			if(isSilenced($origin)) return;
			
			__output("OBJECT", $origin, $str, OutEvent.ALL);
			for(var p:* in $obj) __output("", null, p + " : " + $obj[p], OutEvent.ALL);
		}
		
		public static function addEventListener($type:String, $func:Function):void {
			__getInstance().addEventListener($type, $func);
		}
		
		public static function removeEventListener($type:String, $func:Function):void {
			__getInstance().removeEventListener($type, $func);
		}
		
		private static function __getInstance():Out{
			return (__instance ? __instance : (__instance = new Out()));
		}
		
		public static function createInstance():void {
			var i:*;
			var ii:*;
			var reSilence:Object = {};			
			var reDisable:Array = [];
			
			for(i in __silenced) { reSilence[i] = __silenced; }
			for(i in __levels) { if(__levels[i] && __levels[i] != null) reDisable.push(i); }			
			enableAllLevels();
			for(ii in reSilence) { silence(ii); }
			for(ii=0;ii<reDisable.length;ii++) { disableLevel(reDisable[ii]); }
		}
		
		private static function __output($level:String, $origin:*, $type:String, ...$objects):void {
			var l:String = $level;
			var s:String = $origin ? __getClassName($origin) : "";
			var i:Out    = __getInstance();
			
			while(l.length < 8) l += " ";
			
			var prefix:String = l + ":::	" + s + "	:: ";
			var output:String = prefix;
			for(var k:String in $objects){
				output += " "+$objects[k].toString();
			}
			
			if(__debuggers.length){
				for each(var j:IOutAdapter in __debuggers) j.output.apply(null, [prefix, $level].concat($objects) );
			}
			
			i.dispatchEvent(new OutEvent(OutEvent.ALL, 	output));
			i.dispatchEvent(new OutEvent($type,           	output));
		}
		
		private static function __getClassName($o:*):String {
			var c:String = flash.utils.getQualifiedClassName($o);
			var s:String = (c == "String" ? $o : c.split("::")[1] || c);
			
			return s;
		}
		
	}
}