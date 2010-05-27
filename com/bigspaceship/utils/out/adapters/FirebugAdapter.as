/**
 * FirebugAdapter by Big Spaceship. 2010
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2010 Big Spaceship, LLC
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
package com.bigspaceship.utils.out.adaptors
{
	
	import flash.external.ExternalInterface;
	
	/**
	 * A bridge for the Out class with the Firebug extension for Firefox (http://getfirebug.com/)
	 * 
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Charlie Whitney
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 */	
	public class FirebugAdapter implements IOutAdapter
	{
		public function FirebugAdapter(){
		}
		
		public function output($prefix:String, $level:String, ...$objects):void {
			if(!ExternalInterface.available) return;

			var output:String = $prefix;
			for(var k:String in $objects){	output += " "+$objects[k].toString();	}
			
			switch($level)
			{
				case "ERROR" :
					ExternalInterface.call("console.error",output);
					break;
				case "WARNING" :
					ExternalInterface.call("console.warn",output);
					break;
				case "FATAL" :
					ExternalInterface.call("console.error",output);
					break;
				case "DEBUG" :
					ExternalInterface.call("console.debug",output);
					break;
				case "STATUS" :
					ExternalInterface.call("console.log",output);
					break;
				case "INFO" :
					ExternalInterface.call("console.info",output);
					break;
				default:
					ExternalInterface.call("console.log",output);
					break;
			}
		};
		
		public function clear():void{
			if(ExternalInterface.available) ExternalInterface.call("console.clear");
		};
	}
}