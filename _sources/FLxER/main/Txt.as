﻿package FLxER.main{	import flash.text.TextField;	import flash.text.TextFormat;	import flash.events.*;  	import flash.ui.Keyboard; 	public class Txt extends TextField {		var fnz:Function;		var startVal:String;		public function Txt(xx:Number,yy:Number,ww:uint,hh:uint,t:String,tf:TextFormat,tipo:String, f:Function=null):void {			x = xx			y = yy			//border = true;			startVal = text = t;			embedFonts=true;			//trace(t+""+tf)			setTextFormat(tf);			defaultTextFormat = tf			styleSheet = Preferences.pref.tsHtml			if (ww > 0) {				width = ww;				if (textWidth > width) {					wordWrap = true;				}			} else {				width=textWidth + 7;			}			if (hh > 0) {				height = hh;			} else {				height=textHeight + 4;			}			if (tipo == "input" || tipo == "puls") {				selectable = (tipo == "input");				if (tipo == "input") {					this.type="input";					this.addEventListener(FocusEvent.FOCUS_IN, myFocus);					fnz = f;				}				background = true;				border = false;				//borderColor = Preferences.pref.myCol.brdCol;				backgroundColor = Preferences.pref.myCol.bkgCol;			} else {				selectable=false;			}		}		public function resetta():void {			text = startVal;		}		function pressKey(event:KeyboardEvent):void {			if(event.keyCode == Keyboard.ENTER) {				stage.removeEventListener(KeyboardEvent.KEY_DOWN, pressKey);				Preferences.pref.interfaceTrgt.parent.myKeyboard.myEnable()				this.stage.focus=Preferences.pref.interfaceTrgt.parent;				if (fnz is Function) {					fnz(text)				}			}		}		function myFocus(event:Event):void {			trace("myFocus"+this.setSelection)			this.stage.focus=this			this.setSelection(0, this.text.length);			Preferences.pref.interfaceTrgt.parent.myKeyboard.myDisable()			//this.alwaysShowSelection = true;			stage.addEventListener(KeyboardEvent.KEY_DOWN, pressKey);  		}	}}