/**
 * Lib by Big Spaceship. 2009
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2009 Big Spaceship, LLC
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
	import com.bigspaceship.utils.Out;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Lib
	 *
	 * @copyright 		2009 Big Spaceship, LLC
	 * @author			Daniel Scheibel, Jamie Kosoy, Joshua Hirsch
	 * @version			1.1
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class Lib{
		
		/**
		 * The <code>loadSound()</code> method creates a new Instance of a class.
		 * 
		 * @param 	$appDomainOrMc	Object			ApplicationDomain or MovieClip (reference to swf) where the classDefinition can be found.
		 * @param	$classname 		String			Name of the Class that you want to create
		 * @return 					DisplayObject	Instance of the Class $classname, null if class definition couldn't be found.
		 * 
		 */		
		public static function createAsset($classname:String, $appDomainOrMc:Object ):DisplayObject{
			var c:Class = _getClassDefinition($classname, $appDomainOrMc);
			return new c();
		}
		
		/**
		 * The <code>createMovieClip()</code> method
		 * 
		 * @param 	$appDomainOrMc	Object		ApplicationDomain or MovieClip (reference to swf) where the classDefinition can be found.
		 * @param 	$classname 		String			Name of the Class that you want to create
		 * @return 					MovieClip
		 * 
		 */		
		public static function createMovieClip($classname:String, $appDomainOrMc:Object):MovieClip{
			return MovieClip(createAsset($classname, $appDomainOrMc));
		}
		
		/**
		 * The <code>createSound()</code> method
		 * 
		 * @param 	$appDomainOrMc	Object		ApplicationDomain or MovieClip (reference to swf) where the classDefinition can be found.
		 * @param 	$classname 		String			Name of the Class that you want to create
		 * @return 					Sound
		 * 
		 */		
		public static function createSound($classname:String, $appDomainOrMc:Object):Sound{
			return Sound(createAsset($classname, $appDomainOrMc));		
		}
		
		/**
		 * The <code>createBitmapData()</code> method
		 * 
		 * @param 	$appDomainOrMc	Object		ApplicationDomain or MovieClip (reference to swf) where the classDefinition can be found.
		 * @param 	$classname 		String		Name of the Class that you want to create
		 * @return 					BitmapData
		 * 
		 */		
		public static function createBitmapData($classname:String, $appDomainOrMc:Object):BitmapData{
			var c:Class = _getClassDefinition($classname, $appDomainOrMc);
			// width and height parameters that get passed to the constructor 
			// have no influence on the size of bitmap. 
			// the returning bitmapdata is the size of the image that is in the library. 
			return BitmapData(new c(0,0));
		}
		
		/**
		 * The <code>createClassObject()</code> method
		 * 
		 * @param 	$classname
		 * @return 
		 * 
		 */		
		public static function createClassObject($classname:String):*{
			var c:Class = Class(getDefinitionByName($classname));
			return new c();
		}
		
		
		private static function _getClassDefinition($classname:String, $appDomainOrMc:Object):Class{
			/*if($appDomainOrMc == null){
				$appDomainOrMc = ApplicationDomain.currentDomain;
			}*/
			var appDomain:ApplicationDomain;
			if($appDomainOrMc is ApplicationDomain){
				appDomain = ApplicationDomain($appDomainOrMc);
			}else{
				appDomain = $appDomainOrMc.loaderInfo.applicationDomain;
			}
			var c:Class;
			try{
				c = Class(appDomain.getDefinition($classname));
			}catch($error:Error){
				//trace($error.errorID+' || '+$error.name+' || '+$error.message);
				throw new Error("#1065: Big Spaceship Lib - Flash Library Error. || Variable "+$classname+" is not defined in ApplicationDomain/MovieClip", $error.errorID);	
			}
			return c;
		}
		
	}
}