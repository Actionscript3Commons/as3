/**
* IconManager by Big Spaceship. 2008
*
* To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
* Visit http://labs.bigspaceship.com for documentation, updates and more free code.
*
*
* Copyright (c) 2008 Big Spaceship, LLC
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

package com.bigspaceship.air
{
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.desktop.NativeApplication;

	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.Environment;
	
	/**
	 * IconManager is a Singleton Class.
	 *
	 * @copyright 		2008 Big Spaceship, LLC
	 * @author			Jamie Kosoy
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.41
	 *
	 */

	public class IconManager
	{
		private static var __instance	:IconManager;
		
		public function IconManager() {};	// don't construct directly, fool.
		
		public static function update($b128:BitmapData):void
		{
			if(!__instance) __instance = new IconManager();
			
			if(!Environment.IS_IN_AIR) Out.warning(__instance,"SWF is not written for AIR. API calls may break your site.");
			if($b128.width != 128 || $b128.height != 128) Out.warning(__instance,"BitmapData must be 120x120");
			
			var b48:BitmapData = _resizeBitmapData($b128,48);
			var b32:BitmapData = _resizeBitmapData($b128,32);
			var b16:BitmapData = _resizeBitmapData($b128,16);

			NativeApplication.nativeApplication.icon.bitmaps = [b16,b32,b48,$b128];			
		};	

		private static function _resizeBitmapData($bmd:BitmapData,$size:int):BitmapData
		{
			var p:Number = $size/$bmd.width;
			var bmd:BitmapData = new BitmapData($size,$size,$bmd.transparent,$bmd.transparent ? 0 :  0xFFFFFFFF);
				bmd.draw($bmd,new Matrix(p,0,0,p,0,0));

			return bmd;
		};	
	};
};