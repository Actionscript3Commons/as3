/**
 * AudioManager by Big Spaceship. 2007-2010
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2007-2010 Big Spaceship, LLC
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

package com.bigspaceship.audio{
		
	import com.bigspaceship.events.AudioEvent;
	import com.bigspaceship.tween.SoundTransformTween;
	import com.bigspaceship.utils.Out;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	/**
	* The <code>AudioManager()</code> Class is a Singleton and handles all Audio-Effect calls except Transition videos.
	* 
	* @copyright 		2010 Big Spaceship, LLC
	* @author			Daniel Scheibel 
	* @version			1.1
	* @langversion		ActionScript 3.0 			
	* @playerversion 	Flash 9.0.0
	*/
	
	public class AudioManager extends EventDispatcher{
		
	//////////////////////////////////
	
		//Libraries (reference to loaded SWF Files that contain Sound in the Library)
		private var _libraries:Object = new Object(); 
		
		//ds: used for playSequencedEffectSound
		private var _sequenceDic							:Dictionary = new Dictionary();
		
		//ds: Object that holds Sound-Instances
		private var _soundInstances							:Object = new Object();
		
		//ds: Object that keeps references to soundchannels
		private var _effectsChannels 						:Object = new Object();
		
		//ds: dictionary and object to manage fade-functionality
		private var _soundTweens	 						:Object = new Object();
		private var _soundTweens_dic						:Dictionary = new Dictionary();
		
		private var _mute									:Boolean = false;
		private var _masterVolume							:Number = 1;
		
		
	//////////////////////////////////
				
		public function get masterVolume():Number{
			return _masterVolume;
		}
		public function get isMute():Boolean{
			return _mute;
		}
	
	//////////////////////////////////
		private static var __instance					: AudioManager;
		
		public static function getInstance() : AudioManager {
			return initialize();
		}
		
		public static function initialize() : AudioManager {
			if (__instance == null){
				__instance = new AudioManager();
			}
			return __instance;
		}
		
		public function AudioManager(){
			super();
			if( __instance != null ) throw new Error( "Error:Model already initialised." );
			if( __instance == null ) __instance = this;	
		}	
		
	////////////////////////////////// PUBLIC sound effects functions::
		
		/**
	     *  The <code>addAudioLibrary()</code> method adds a loaded SWF-file to a list of SWF-files
	     *  that get searched to create an Audio-Instance.
		 *
	     *  @param $id  
		 *
	     *  @param $lib loaded SWF-file (MovieClip)
     	*/
		public function addAudioLibrary($id:String, $lib:MovieClip):void{
			_libraries[$id] = $lib;
			//Out.debug(this, 'Library added, id: '+$id+', lib: '+_libraries[$id]);
		}
		
		
		
		/**
	     *  The <code>loadSound()</code> method starts to load and play sound. 
	     *  	
		 *
	     *  @param $url   
		 *
	     *  @param $vol Specifies the volume.
	     * 
 	     *  @return SoundChannel 
     	*/ 
		public function loadAndPlaySound($url:String, $vol:Number):SoundChannel{
			try {
				var tmpSound:Sound = new Sound();
				//_tmpSound.addEventListener(IOErrorEvent.IO_ERROR, onIOError_handler);
				//_tmpSound.addEventListener(Event.ID3, onID3_handler, false, 0 , true);   
				tmpSound.load(new URLRequest($url));
			} catch(err:Error) {
				trace(err.message);	
			}
			return tmpSound.play(0, 0, new SoundTransform($vol*_masterVolume));
		}		
				
		/**
	     *  The <code>playSound()</code> method starts to play a sound. 
	     *  Nothing is happening if sound is playing already.
	     * 		
		 *
	     *  @param $id library id.  
		 *
	     *  @param $loops Specifies the number of loops.
		 *
	     *  @param $vol Specifies the volume.
	     * 
 	     *  @param $restart Boolean to specify if sounds needs to restart if it's already playing.
		 *
     	*/ 
		public function playSound($id:String, $loops:int = 1, $vol:Number = 1, $restart:Boolean = false):void{	
			//_startMusic($id);
			if(!_mute){
				if(_getSoundInstance($id)){
					if(!_effectsChannels[$id]){
						_effectsChannels[$id] = _getSoundInstance($id).play(0, $loops, new SoundTransform($vol*_masterVolume));
					}else if($restart){
						stopSound($id);
						_effectsChannels[$id] = _getSoundInstance($id).play(0, $loops, new SoundTransform($vol*_masterVolume));
					}					
				}
			}
		};
		
		/**
	     *  The <code>playEffectSound()</code> method starts a sound to play.
	     *	
	     * 
		 *
	     *  @param $id library id.    
		 *
	     *  @param $killSameEffectSoundfirst Boolean to specify if sound needs to be stopped first if same sound is currently playing.
		 *
		 *  @param $loops Specifies the number of loops.
		 * 
	     *  @param $vol Specifies the volume.
	     * 
	     *  @param $panning
		 *
	     *  @return SoundChannel 
     	*/ 
		public function playEffectSound($id:String, $killSameEffectSoundfirst:Boolean = false, $loops:int = 1, $vol:Number = 1, $panning:Number=0):SoundChannel{
			if(!_mute){
				if(_effectsChannels[$id] && $killSameEffectSoundfirst){
					SoundChannel(_effectsChannels[$id]).stop();
				}
				if(_getSoundInstance($id)){
					_effectsChannels[$id] = _getSoundInstance($id).play(0, $loops, new SoundTransform($vol*_masterVolume, $panning));
				}
			}
			return _effectsChannels[$id];
		};
		
		/**
	     *  The <code>playRandomEffectSound()</code> method starts 
	     *  a random Sound out of a provided set of sounds.
	     *	
	     * 
		 *
	     *  @param $set An Array that specifies the set of Sounds to choose from. Array consists of Sound-Ids (Strings). The order of the aray is going to be changed.  
		 *
	     *  @param $nonStandard Specifies the number of excluding previously played sounds);
		 *
	     *  @param $vol Specifies the volume.
		 *
	     *  @param $loops Specifies the number of loops.
		 *
	     *  @return SoundChannel 
     	*/  
		public function playRandomEffectSound($set:Array, $nonStandard:int = 2, $vol:Number = 1, $loops:int = 1):SoundChannel{
			 if(!_mute){
				var random:int = int(Math.random()*($set.length-$nonStandard));
				var id:String = $set[random];
				$set.splice(random, 1);
				$set.push(id);
				if(_getSoundInstance(id)){
					_effectsChannels[id] = _getSoundInstance(id).play(0, $loops, new SoundTransform($vol*_masterVolume));
				}
			}
			return _effectsChannels[$set];
		};
		
		/**
		 * The <code>playSequencedEffectSound()</code> method plays a set of Sounds in sequence.
	     * 
	     * 
		 * @param $id The base-name of the set of sounds.
		 * @param $range The range of sounds within the set e.g. a range of 5 means there are 5 sounds.
		 * @param $vol Specifies the volume.
		 * @param $loops Specifies the number of loops.
		 * @return SoundChannel
		 * 
		 */		
		public function playSequencedEffectSound($id:String, $range:int, $vol:Number = 1, $loops:int = 1):SoundChannel{
			if(!_mute){
				if(_sequenceDic[$id]!=null){
					_sequenceDic[$id] = _sequenceDic[$id] + 1;
				}else{
					_sequenceDic[$id] = 0;
				}
				var libId:String = $id+'_'+(_sequenceDic[$id]%($range));
				if(_getSoundInstance(libId)){
					_effectsChannels[libId] = _getSoundInstance(libId).play(0, $loops, new SoundTransform($vol*_masterVolume));
				}
			}
			return _effectsChannels[libId];
		};
		
		
		
		public function setMasterVolume($volume:Number):void{
			_masterVolume = $volume;
			
			if(_masterVolume <= 0){
				_masterVolume = 0;
				//ds: TODO don't toggle mute! but set mute to true
				mute();
			}else if(!_mute){
				var st:SoundTransform = new SoundTransform();
				st.volume = _masterVolume;
				for each(var channel:* in _effectsChannels){
					if(channel){
						//ds: TODO multiply with all currrent sound volume
						channel.soundTransform = st;
					}
				}
			}else{
				mute();
			}
		}
		
		
		public function setVolume($id:String, $volume:Number):void{
			if(!_mute && _effectsChannels[$id]){
				var st:SoundTransform = new SoundTransform();
				st.volume = $volume*_masterVolume;
				SoundChannel(_effectsChannels[$id]).soundTransform = st;
			}
					
		}
		
		public function fadeVolume ($id:String, $volume:Number, $speed:int = 100, $stopIfFadeToZero:Boolean = true ):void{
			if(!_mute){
				if(_effectsChannels[$id]){
					if(_soundTweens.hasOwnProperty($id)){
						_soundTweens[$id].stop();
					}
					var tween:SoundTransformTween = new SoundTransformTween(_effectsChannels[$id], _effectsChannels[$id].soundTransform, new SoundTransform($volume*_masterVolume), $speed);
					if($stopIfFadeToZero && $volume == 0){
						tween.addEventListener(Event.COMPLETE, _onSoundTweenComplete_StopSound_handler);
					}else{
						tween.addEventListener(Event.COMPLETE, _onSoundTweenComplete_handler);
					}
					_soundTweens_dic[tween] = $id;
					tween.addEventListener(Event.CANCEL, _onSoundTweenCancel_handler);
					if(_soundTweens.hasOwnProperty($id)){
						Out.fatal(this, 'fadeVolume('+$id+') called. tween still exists. somethings wrong!'); 
					}
					_soundTweens[$id] = tween;
				}
			}			
		}  
		
		public function stopSound($id:String):void{
			if(_effectsChannels[$id]){
				_effectsChannels[$id].stop();
				delete _effectsChannels[$id];
				Out.info(this, "Sound ID:"+$id+" stopped.");
			}
		}
		
		
		////////////////////////////////// PUBLIC common functions ::
		
		//ds: TODO create toggleMute();
		//ds: TODO create mute();
		//ds: TODO create unMute();
		
		public function mute(forceMute:Boolean = false):void{
			
			if(_mute){
				_mute = false;
				SoundMixer.soundTransform = new SoundTransform();
				/* for (var id:String in _effectsChannels){
					fadeVolume(id, _masterVolume);
				} */
			}else{
				_mute = true;
				for each(var channel:* in _effectsChannels){
					SoundChannel(channel).stop();
				} 
				
				SoundMixer.stopAll();
				SoundMixer.soundTransform = new SoundTransform(0);
				/* for (var id:String in _effectsChannels){
					fadeVolume(id, 0);
					//SoundChannel(_effectsChannels[id]).stop();
				} */
			}
			this.dispatchEvent(new AudioEvent(AudioEvent.MUTE));
			
		};
		
		
		////////////////////////////////// PRIVATE functions ::
		
		private function _onSoundTweenComplete_handler($evt:Event):void{
			$evt.target.removeEventListener(Event.COMPLETE, _onSoundTweenComplete_handler);
			$evt.target.removeEventListener(Event.CANCEL, _onSoundTweenCancel_handler);
			var tween:SoundTransformTween = SoundTransformTween($evt.target);
			delete _soundTweens[_soundTweens_dic[tween]];
			delete _soundTweens_dic[tween];
		}
		
		private function _onSoundTweenCancel_handler($evt:Event):void{
			$evt.target.removeEventListener(Event.COMPLETE, _onSoundTweenComplete_StopSound_handler);
			$evt.target.removeEventListener(Event.COMPLETE, _onSoundTweenComplete_handler);
			$evt.target.removeEventListener(Event.CANCEL, _onSoundTweenCancel_handler);
			var tween:SoundTransformTween = SoundTransformTween($evt.target);
			delete _soundTweens[_soundTweens_dic[tween]];
			delete _soundTweens_dic[tween];
		}
		
		private function _onSoundTweenComplete_StopSound_handler($evt:Event):void{
			$evt.target.removeEventListener(Event.COMPLETE, _onSoundTweenComplete_StopSound_handler);
			var tween:SoundTransformTween = SoundTransformTween($evt.target);
			stopSound(_soundTweens_dic[tween]);
			_onSoundTweenComplete_handler($evt);
		}
		
		
		private function _getSoundInstance($id:String):Sound{
			if(_soundInstances[$id]){
				return _soundInstances[$id];
			}else{
				if(_getApplicationDomain($id)){
					//return _soundInstances[$id] = Lib.createSound(_getLibrarySWF($id), $id);
					
					var c:Class = Class(_getApplicationDomain($id).getDefinition($id));
					return _soundInstances[$id] = Sound( new c() );	
					
				}else{
					Out.info(this, "SoundLibrary not loaded! Can't play ID: "+$id);
					return null;
				}
			}
		}
		
		private function _getApplicationDomain($id:String):ApplicationDomain{
			var applicationDomain:ApplicationDomain;
			if(ApplicationDomain.currentDomain.hasDefinition($id)){
				return ApplicationDomain.currentDomain;
			}else{
				for each(var mc:MovieClip in _libraries){
					if(mc.loaderInfo.applicationDomain.hasDefinition($id)){
						return mc.loaderInfo.applicationDomain;
					}
				} 
			}
			return applicationDomain;
		}
		
		
	};
};