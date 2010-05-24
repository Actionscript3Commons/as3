/**
 * DisplayUtils by Big Spaceship. 2006-2009
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2006-2009 Big Spaceship, LLC
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
	import flash.display.MovieClip;
	import flash.display.FrameLabel;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * DisplayUtils
	 *
	 * @copyright 		2009 Big Spaceship, LLC
	 * @author			Stephen Koch, Daniel Scheibel, Jamie Kosoy
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class DisplayUtils{
		
		/**
		 * The <code>ignoreMouse()</code> method sets the <code>mouseEnabled</code> and <code>mouseChildren</code> properties 
		 * of the passed in DisplayObjectContainer and its Children to <code>false</code>.
		 * 
		 * @param	$do	DisplayObject
		 * 
		 */		
		public static function ignoreMouse($do:DisplayObjectContainer):void{
           if($do.mouseEnabled) $do.mouseEnabled = false;
           if($do.mouseChildren) $do.mouseChildren = false;

           if($do.numChildren && $do.numChildren > 0)
           {
               for(var i:int=0;i<$do.numChildren;i++)
               {
                   if($do.mouseEnabled) DisplayUtils.ignoreMouse(($do.getChildAt(i) as DisplayObjectContainer));
               }
			}	
		}
		
		/**
		 * The <code>ignoreMouse()</code> method sets the <code>mouseEnabled</code> and <code>mouseChildren</code> properties 
		 * of the passed in DisplayObjectContainer and its Children to <code>true</code>.
		 * 
		 * @param	$do	DisplayObject 
		 * 
		 */		
		public static function respondToMouse($do:DisplayObjectContainer):void{
			if(!$do.mouseEnabled) $do.mouseEnabled = true;
			if(!$do.mouseChildren) $do.mouseChildren = true;

			if($do.numChildren && $do.numChildren > 0)
			{
				for(var i:int=0;i<$do.numChildren;i++)
				{
					if(!$do.mouseEnabled) DisplayUtils.respondToMouse(($do.getChildAt(i) as DisplayObjectContainer));
				}
			}
		}
		
		
		
		/**
		 *  The <code>stopAllChildren()</code> method stops the passed Movieclip and all it's children-Movieclips.
		 *
		 *  @param	$mc	Movieclip 
		 *
		*/
		public static function stopAllChildren($mc:MovieClip):void{
			//trace('STOP called for: '+$mc);
			$mc.stop();
			for(var i:int = 0; i < $mc.numChildren; i++){
				if($mc.getChildAt(i)){
					if($mc.getChildAt(i).hasOwnProperty('currentFrame')){
						stopAllChildren(MovieClip($mc.getChildAt(i)));
					}
				}
			}   
		}
		
        /**
		 *  The <code>playAllChildren()</code> method starts playing the passed Movieclip and all it's children-Movieclips.
		 *	You can add "var doNotPlay:Boolean=true;" on the Timeline of the Movieclip or on the Timeline on one of the child-Movieclips 
		 *	if you don't want the movieclip to play.
		 *	
		 *  @param	$mc	Movieclip 
		 *
		*/
		public static function playAllChildren($mc:MovieClip):void{
			//trace('PLAY called for: '+$mc.replayable);
			if(!$mc.doNotPlay)$mc.play();
			for(var i:int = 0; i < $mc.numChildren; i++){
				if($mc.getChildAt(i)){
					if($mc.getChildAt(i).hasOwnProperty('currentFrame')){		
						playAllChildren(MovieClip($mc.getChildAt(i)));
					}
				}
			}   
		}
		
		/**
		 *  The <code>generateFrameLabelObject()</code> method returns an Object that contains 
		 *	Frame-Labels as Keys and corresponding Frame-number as a value.
		 *	
		 *  @param $mc A Movieclip to analyse
		 *	
		 *	@return	Object that contains Frame-Labels as Keys and corresponding Frame-number as a value
		 *
		*/
		public static function generateFrameLabelObject($mc:MovieClip):Object{
			var labels:Array = $mc.currentLabels;
			var frameLabelObj:Object = new Object();
			//trace('_generateFrameLabelObject:: '+$mc.name);
			for (var i:uint = 0; i < labels.length; i++) {
        
			    var label:FrameLabel = labels[i];
			    //trace(label.name+': '+label.frame);
			    frameLabelObj[label.name] = label.frame;
			}
			return frameLabelObj;
		}
		
		
		/**
		 *  The <code>removeAllChildren()</code> method returns an Boolean whether or not all the children of a DisplayObjectContainer have been removed
		 *	
		 *  @param $do	DisplayObject
		 *	
		 *	@return	Boolean whether or not all the children of a DisplayObjectContainer have been removed
		 *
		*/
		public static function removeAllChildren($do:DisplayObjectContainer):Boolean{
			while($do.numChildren) $do.removeChildAt(0);
			if($do.numChildren == 0) return true;
			return false;
		}
		
	}
}