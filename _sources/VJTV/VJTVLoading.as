﻿package VJTV {	import flash.display.MovieClip;	public class VJTVLoading extends MovieClip {		public function VJTVLoading():void {			setPos()		}		public function setPos():void {			x = Preferences.pref.w/2;			y = Preferences.pref.h/2;		}	}}