/**
 * Console by Big Spaceship. 2006-2009
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
package com.bigspaceship.utils{
	
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	
	import com.bigspaceship.events.ConsoleEvent;
	import com.bigspaceship.events.OutEvent;
	
	/**
	 * Console
	 *
	 * @copyright 		2009 Big Spaceship, LLC
	 * @author			
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class Console extends Sprite{
		
		private var _output_tf	: TextField;
		private var _input_tf	: TextField;
		private var _bg			: Sprite;
		private var _titlebar	: Sprite;
		private var _isMinimized: Boolean;
		
		private var INPUT_H		: Number = 16;
		private var PADDING		: Number = 5;
		private var TITLE_BAR_H	: Number = 8;
		
		public function Console($w:Number, $h:Number){
			_titlebar = new Sprite();
			_titlebar.graphics.beginFill(0x000000, .8);
			_titlebar.graphics.drawRect(0,0,$w,TITLE_BAR_H);
			_titlebar.doubleClickEnabled = true;
			
			_bg = new Sprite();
			_bg.graphics.beginFill(0x000000, .7);
			_bg.graphics.drawRect(0,TITLE_BAR_H + 1,$w,$h-TITLE_BAR_H);
			
			var tFormat = new TextFormat("Monaco", 10, 0xffffff);
			
			_output_tf = new TextField();
			_output_tf.width = $w - (PADDING * 2);
			_output_tf.height = $h - (INPUT_H - 2) - (PADDING * 2) - TITLE_BAR_H;
			_output_tf.x = PADDING;
			_output_tf.y = PADDING + TITLE_BAR_H;
			_output_tf.defaultTextFormat = tFormat;
			_output_tf.multiline = true;
			_output_tf.wordWrap = true;
			
			_input_tf = new TextField();
			_input_tf.width = $w - (PADDING * 2);
			_input_tf.height = INPUT_H;
			_input_tf.y = $h - INPUT_H - PADDING;
			_input_tf.x = PADDING;
			_input_tf.type = TextFieldType.INPUT;
			_input_tf.defaultTextFormat = tFormat;
			_input_tf.background = true;
			_input_tf.backgroundColor = 0x333333;
			
			addChild(_titlebar);
			addChild(_bg);
			addChild(_output_tf);
			addChild(_input_tf);
			
			_isMinimized = false;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(ConsoleEvent.COMMAND, _onCommand);
		};
		
		public function output($str:String):void{
			_output_tf.appendText("\n" + $str);
			_output_tf.scrollV = _output_tf.maxScrollV;
		};
		
		public function onOutputEvent($evt:OutEvent):void{
			output($evt.output);
		};
		
		public function minimize():void{
			_isMinimized = false;
			_toggleMinimize();
		};
		
		private function _onAddedToStage($evt:Event):void{
			_bg.addEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			_titlebar.addEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			_titlebar.addEventListener(MouseEvent.DOUBLE_CLICK, _toggleMinimize);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onRelease);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
		};
		
		private function _onPress($evt:MouseEvent):void{
			startDrag();
		};

		private function _onRelease($event:MouseEvent):void{
			stopDrag();
		};
		
		private function _onKeyDown($evt:KeyboardEvent):void{
			if($evt.keyCode == Keyboard.ENTER && _input_tf.text != "" && stage.focus == _input_tf){
				output("> " + _input_tf.text);
				dispatchEvent(new ConsoleEvent(ConsoleEvent.COMMAND, _input_tf.text));
				_input_tf.text = "";
			}
		};

		private function _onCommand($evt:ConsoleEvent):void{
			switch($evt.cmd){
				case "clear":
					_output_tf.text = "";
					break;
			}
		};
		
		private function _toggleMinimize($evt:MouseEvent = null):void{
			_bg.visible = _isMinimized;
			_input_tf.visible = _isMinimized;
			_output_tf.visible = _isMinimized;
			_isMinimized = !_isMinimized;
		};
	}
}