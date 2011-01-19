/**
 * Environment by Big Spaceship. 2006-2010
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
 
package com.bigspaceship.utils{

	import flash.system.Security;
	import flash.system.Capabilities;
	import flash.net.LocalConnection;
	
	import com.bigspaceship.utils.Out;
	
	/**
	 * Environment
	 *
	 * @copyright 		2010 Big Spaceship, LLC
	 * @author			Jamie Kosoy, Daniel Scheibel
	 * @version			1.1
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class Environment{
			
		public static function get IS_IN_BROWSER():Boolean {
			return (Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX");
		}
	
		public static function get DOMAIN():String{
			return new LocalConnection().domain;
		}
		
		public static function get IS_LOCAL():Boolean {
			return (DOMAIN == "localhost");
		}
	
		public static function get IS_AREA51():Boolean{
			return (DOMAIN == "area51.bigspaceship.com");
		}
	
		public static function get IS_BIGSPACESHIP():Boolean{
			return(DOMAIN == "www.bigspaceship.com" || DOMAIN == "bigspaceship.com");
		}
		
		public static function get IS_IN_AIR():Boolean {
			return Capabilities.playerType == "Desktop";
		}
		public static function get IS_ON_SERVER():Boolean {
			//ds: 'remote' (Security.REMOTE) — This file is from an Internet URL and operates under domain-based sandbox rules.
			return Security.sandboxType == Security.REMOTE;
		}
	}
}