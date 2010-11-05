/**
 * Standard by Big Spaceship. 2009-2010
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
package com.bigspaceship.loading
{
	import com.bigspaceship.utils.MathUtils;
	import com.bigspaceship.utils.Out;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * Dispatched when all files are loaded.
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Dispatched during loading process.
	 *
	 * @eventType flash.events.ProgressEvent
	 **/
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 *  Multiple file loader.
	 *	Basic syntax requires creation of an instance of BigLoader. To which assets can then be added.  
	 *	Loader is started with "start".  All events dispatched are in relation to global load.
	 *	<code>
	 *		var l:BigLoader = new BigLoader();
	 *		l.add("assets/myImage.jpg", "assetID", 234, 100);	// parameters are (asset path, uniquie id [not required]], weight in bytes [not required], priority [not required])
	 *		l.add("assets/audioLib.swf", null, 2700);
	 *		l.start();
	 *  </code>
	 *	
	 *	Additionally <code>loader.add()</code> will return an instance of BigLoadItem which will also dispatch OPEN, PROGRESS, COMPLETE and IO_ERROR events for itself.
	 *	
	 *	@dispatches Event.COMPLETE
	 *	@dispatches ProgressEvent.PROGRESS
	 *	
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 10.0.0
	 *
	 *  @author Charlie Whitney, Jamie Kosoy, Daniel Scheibel
	 *  @since  25.05.2010
	 */
	public class BigLoader extends EventDispatcher {
		public static var verbose		:Boolean = true;

		private var _max_connections	:int = 2;

		private var _itemsToLoad	:Vector.<BigLoadItem>;
		private var _itemsLoading	:Vector.<BigLoadItem>;
		private var _itemsLoaded	:Vector.<BigLoadItem>;
		private var _items_dic		:Object;
		
		private var _loaderActive	:Boolean = false;
		private var _totalWeight	:int;
		private var _loadComplete	:Boolean = false;
		
		public function get loadComplete():Boolean{
			return _loadComplete;
		}
		public function set max_connections($value:int):void{
			_max_connections = ($value<1)?1:$value;
		}
		public function get max_connections():int{
			return _max_connections;
		}
		public function get highestPriority():Number{
			var priority:Number = 0;
			if(_itemsToLoad.length>0){
				_itemsToLoad[0].priority;
			}
			return priority;
		}
		
		public function BigLoader($max_connections:int = 2) {
			_max_connections = $max_connections;
			_totalWeight = 0;
			_itemsToLoad = new Vector.<BigLoadItem>();
			_itemsLoading = new Vector.<BigLoadItem>();
			_itemsLoaded = new Vector.<BigLoadItem>();
			
			_items_dic = new Object();
		};

		public function add($url:*, $id:String=null, $priority:Number = 0, $weight:int=1, $type:String = null, $autoload:Boolean=false):BigLoadItem {
			//if(_loaderActive){ _log("You can't add anything after the loader is started.");	return null; }
			if($id == null) $id = $url;
			
			var loadItem:BigLoadItem = new BigLoadItem($url, $id, $weight, $type, $priority);
			loadItem.addEventListener(ProgressEvent.PROGRESS, _onItemProgress, false, 999, true);
			loadItem.addEventListener(IOErrorEvent.IO_ERROR, _onItemLoadError, false, 999, true);
			loadItem.addEventListener('bigloaditemcomplete', _onItemLoadComplete, false, 999, true);
			
			_itemsToLoad.push(loadItem);
			_items_dic[loadItem.id] = loadItem;
			
			_totalWeight += $weight;
			_loadComplete = false;
			if($autoload)start();
			return loadItem;
		};
		
		public function destroy():void{
			for(var i:int=0;i<_itemsToLoad.length;i++) { _itemsToLoad[i].destroy(); }

			_itemsToLoad = null;
			_itemsLoaded = null;
			_itemsLoading = null;
		};
		
		public function start():void {
			if(_loaderActive){ _log("Loader is already started."); return; }
			_loaderActive = true;
			_loadNextItems();
		};
		
		public function stop($killCurrentLoad:Boolean=false):void{
			if(!_loaderActive){ 
				if(_loadComplete){
					_log("Loader is already complete.");
				}else{
					_log("Loader is already stopped.");
				}
			}else{
				_log("Loader stopped. Items loaded: "+_itemsLoaded.length+", items about to finish loading: "+_itemsLoading.length+", items to load: "+_itemsToLoad.length);
				_loaderActive= false;
			}
		}
		
		/**
		 *	Returns the BigLoadItem instance for the passed ID.
		 */
		public function getBigLoadItemById($id:String):BigLoadItem {
			var item:BigLoadItem = null;
			if(_items_dic[$id] == null) {
				_log("Warning: Id does not exist.");
			}else {
				//if(BigLoadItem(_items_dic[$id]).state != BigLoadItem.LOADED)_log("Warning: Asset not loaded yet.");
				item = BigLoadItem(_items_dic[$id]);
			}
			return item;
		};
		
		/**
		 *	Returns the asset from the BigLoadItem instance for the passed ID
		 */
		public function getLoadedAssetById($id:String):* {
			var content:* = null;
			if(getBigLoadItemById($id))content = getBigLoadItemById($id).content;
			return content;
		};
		
		public function logItemsToLoad():void{
			_itemsToLoad.sort(_sortByPriority);
			var str:String = '';
			for(var ii:int=0; ii<_itemsToLoad.length; ii++){
				str += _itemsToLoad[ii];
			}
			_log(str);
		}
		
		// ---------------------------
		// PRIVATE
		// ---------------------------
		private function _loadNextItems():void {
			if(_loaderActive){
				// load the maximum number possible
				var numToLoad:int = (_itemsToLoad.length < _max_connections) ? _itemsToLoad.length : _max_connections;
				while(_itemsLoading.length < numToLoad){
					//sort _itemsToLoad by priority: first element is most important
					_itemsToLoad.sort(_sortByPriority);
					var nextItem:BigLoadItem = _itemsToLoad.shift();
					nextItem.startLoad();
					_itemsLoading.push(nextItem);
					_log("Starting load of "+nextItem+", items loaded: "+_itemsLoaded.length+", items loading: "+_itemsLoading.length+", items to load: "+_itemsToLoad.length);
				}
			}
		};
		
		private function _sortByPriority(x:BigLoadItem, y:BigLoadItem):int{
			var n:int = 0;
			if(x.priority > y.priority){
				n = -1;
			}else if (x.priority < y.priority){
				n = 1;
			}
			return n;
		}
		
		private function _onItemProgress($evt:Event):void {
			var totalPercent:Number = 0;
			var i:int=_itemsToLoad.length;
			for (var key:String in _items_dic) { 
				totalPercent += _items_dic[key].getWeightedPercentage(_totalWeight);
			} 
			// totalPercent will be a number between 0-1
			// ProgressEvent acts weird when you give it floats, so multiply by 100
			dispatchEvent( new ProgressEvent(ProgressEvent.PROGRESS, false, false, totalPercent*100, 100) );
		};
		
		private function _onItemLoadError($evt:IOErrorEvent):void {
			_log("Error loading item. "+$evt);
			_itemLoadedCleanup(BigLoadItem($evt.target));
		};
		
		// when a single item completes its load
		private function _onItemLoadComplete($evt:Event):void {
			_log("Completed load of :: "+$evt.target);
			// store content of loader
			_itemLoadedCleanup(BigLoadItem($evt.target));
		};
		
		// remove listeners, update counters
		private function _itemLoadedCleanup($item:BigLoadItem):void {
			// remove events
			$item.removeEventListener(ProgressEvent.PROGRESS, _onItemProgress);
			$item.addEventListener(IOErrorEvent.IO_ERROR, _onItemLoadError);
			$item.removeEventListener(Event.COMPLETE, _onItemLoadComplete);
			
			// remove from _itemsLoading
			if(_itemsLoading.indexOf($item) > -1){
				_itemsLoading.splice(_itemsLoading.indexOf($item), 1);		
			}
			
			// check if it should start another load
			_itemsLoaded.push($item);
			
			if(_itemsToLoad.length + _itemsLoading.length == 0){
				_allLoadsComplete();
			}else if(_itemsToLoad.length > 0){
				_loadNextItems();
			}
		};
		
		private function _allLoadsComplete():void {
			_loaderActive = false;
			_loadComplete = true;
			// dispatch all complete event
			dispatchEvent( new Event(Event.COMPLETE) );
		};
		
		// tracing
		override public function toString():String {
			return "[BigLoader, (loaded: "+_itemsLoaded.length+", loading: "+_itemsLoading.length+", to load: "+_itemsToLoad.length+")]";
		};
		
		// logging
		private function _log($str:String):void {
			if(verbose) Out.info(this, $str);
		};
	}
}