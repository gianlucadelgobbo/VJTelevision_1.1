﻿package VJTV {	import flash.display.Sprite;	import flash.utils.*;	import flash.display.DisplayObjectContainer.*	import flash.geom.ColorTransform;	import flash.xml.XMLDocument;	import flash.net.*;	import flash.events.*;	import flash.display.Loader;    import flash.net.FileReference;	import fl.transitions.*;	import fl.transitions.easing.*;	import FLxER.main.Rett;	import FLxER.main.Txt;	import FLxER.comp.ButtonTxt;	import VJTV.VJTVListItem;	import VJTV.DatePicker;	public class VJTVChCtrl extends Sprite {		public var ch:Number;		//		var fondino:Rett;		var myFileList:XMLDocument;		/**/		var a:uint;		var c:uint;		var l:uint;		var current_mov:String;		var lastLiveAct:String;		var tipo:String;		var oldTipo:String;		////		var currLib:String;		var myLoader:URLLoader		var MyFile:FileReference;		var firstTime:Boolean = true;		public var goToSec:Number;		var now:Date;		//		var list:Sprite;		var prev:ButtonTxt;		var succ:ButtonTxt;		var listSprites:Array;		var listPulsa:Array;		var h:uint;		var listTit:Txt		var listN:uint;		public var myY;		var page;		var chiudi		var cal:DatePicker		var myTween:Tween;		var pages:Txt;		public function VJTVChCtrl(hh):void {			ch = 0;			listSprites = new Array();			list = new Sprite();			this.addChild(list);			fondino = new Rett(0, 0, 370, 100, 0x333333, -1, .9);			list.addChild(fondino);			//			var now = new Date();			listTit = new Txt(0, -3, 250, 15, "Today: "+now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate(), Preferences.pref.th, "");			list.addChild(listTit);			listTit.scaleX=listTit.scaleY=2			/////// COLORS ///			listPulsa = new Array();			listPulsa.push(new ButtonTxt(-94, 30, 92, 15, "TODAY", paletteHideShow, "today", null));			listPulsa.push(new ButtonTxt(-94, 47, 92, 15, "CHOOSE A DAY", paletteHideShow, "cal", null));			list.addChild(listPulsa[0]);			list.addChild(listPulsa[1]);			for (a=0; a<Preferences.pref.libraryList.childNodes[0].childNodes.length; a++) {				listPulsa.push(new ButtonTxt(-94, 30+(17*(a+2)), 92, 15, Preferences.pref.libraryList.childNodes[0].childNodes[a].attributes.m, paletteHideShow, a.toString(), null));				trace(Preferences.pref.libraryList.childNodes[0].childNodes[a])				list.addChild(listPulsa[(a+2)]);			}			succ = new ButtonTxt(370-60, h-17, 58, 15, "NEXT", pager, 1, null);			list.addChild(succ);			prev = new ButtonTxt(370-60-60, h-17, 58, 15, "PREVIOUS", pager, -1, null);			list.addChild(prev);			chiudi = new ButtonTxt(370-17, 3, 15, 15, "X", Preferences.pref.interfaceTrgt.apriMenu, -1, null);			list.addChild(chiudi);			pages = new Txt(0, h-17, 100, 15, "0 of 0 PAGES",Preferences.pref.th, "");			list.addChild(pages);			//succ.scaleX=succ.scaleY=2			//prev.scaleX=prev.scaleY=2			//pages.scaleX=pages.scaleY=2			//////////////////////////////////			//			/*myLibSel = new ListMenu(2, 13, 128, 15, "select playlist", loadLib, "PAGE UP / PAGE DOWN", Preferences.pref.libraryList.childNodes[0], 3);			this.addChild(myLibSel);			myFileSel = new ListBox(2, 25, 128, 15, myLoadMovie, null, 1, "ARROW UP", "ARROW DOWN");			this.addChild(myFileSel);			myMovie = new Txt(2, 1, 105, 15, "Media", Preferences.pref.th, "");			this.addChild(myMovie);*/			//			cal = new DatePicker();			cal.setMaxDate(Preferences.pref.libraryList.childNodes[0].attributes.maxDate);			cal.setMinDate(Preferences.pref.libraryList.childNodes[0].attributes.minDate);			//cal.setDatum(1,1,2010);	//  optional: set initial Date (dd, mm, yyyy). if not set: default value is today			cal.setLang("en");  		//  "en" or "de", default: "de"			//cal.setSkin("white");		// "blue" or "white", default: "blue"			cal.addEventListener(Event.SELECT, function(e:Event):void{				var cc = cal.getDatum().split(".");				listTit.text = "Day: "+(cc[0].length<2 ? "0"+cc[0] : cc[0])+"-"+(cc[1].length<2 ? "0"+cc[1] : cc[1])+"-"+cc[2]				loaderLib(Preferences.pref.sitePath+"/playlists/"+cc[2]+"-"+(cc[1].length<2 ? "0"+cc[1] : cc[1])+"-"+(cc[0].length<2 ? "0"+cc[0] : cc[0])+".xml");				removeChild(cal)				cal.alpha = 0;//				myTween = new Tween(cal,"alpha",Strong.easeOut,cal.alpha,0,1,true);			});			cal.alpha = 0;			//			setPos(hh);		}		function pager(p:String):void {			page+=parseInt(p);			if (page<0) {				page = 0;			} else {				if (page>int(myFileList.childNodes[0].childNodes.length/listN)) page = int(myFileList.childNodes[0].childNodes.length/listN); 				setPage()			}		}		function paletteHideShow(pp:String):void {			var p = pp			if (p == "today") {				var now = new Date();				var path = Preferences.pref.libraryList.childNodes[0].childNodes[0].attributes.val;				Preferences.pref.sitePath = path.substring(0, path.indexOf("/",8));								listTit.text = "Today: "+(now.getDate().toString().length<2 ? "0"+now.getDate().toString() : now.getDate().toString())+"-"+((now.getMonth()+1).toString().length<2 ? "0"+(now.getMonth()+1).toString() : (now.getMonth()+1).toString())+"-"+now.getFullYear();				loaderLib(Preferences.pref.sitePath+"/playlists/"+now.getFullYear()+"-"+((now.getMonth()+1).toString().length<2 ? "0"+(now.getMonth()+1) : now.getMonth()+1)+"-"+(now.getDate().toString().length<2 ? "0"+now.getDate() : now.getDate())+".xml");			} else if (p == "cal") {				this.addChild(cal)				myTween = new Tween(cal,"alpha",Strong.easeOut,cal.alpha,1,1,true);			} else {				if (p.indexOf("event:")>-1) {					p = Preferences.myReplace(p,"event:","");					for (var a = 0; a<Preferences.pref.libraryList.childNodes[0].childNodes.length; a++) {						if (Preferences.pref.libraryList.childNodes[0].childNodes[a].attributes.val.indexOf(p)>-1) {							p = a;						}					}				} else {					p = parseInt(pp);				}				listTit.text = Preferences.pref.libraryList.childNodes[0].childNodes[p].attributes.m				loaderLib(Preferences.pref.libraryList.childNodes[0].childNodes[p].attributes.val);			}			for (var b=0;b<listN;b++){				listSprites[b].svuota();			}			for (a=0; a<listPulsa.length; a++) {				if (listPulsa[a].param!=p) {					listPulsa[a].myEnable()				} else {					listPulsa[a].myDisable()				}			}		}		function loaderLib(b:String):void {			trace("loaderLib "+b);			Preferences.pref.interfaceTrgt.startLoading();			Preferences.pref.interfaceTrgt.myloaded = false;			myLoader = new URLLoader(new URLRequest(b));			myLoader.addEventListener("complete", loadLibEsito);			myLoader.addEventListener("ioError", loadLibEsito);		}		public function loadLibEsito(event:Event):void {			trace("loadLibEsito"+firstTime)			if (event.type == "complete") {				Preferences.pref.interfaceTrgt.myloaded = true;				Preferences.pref.interfaceTrgt.stopLoading();				myFileList = new XMLDocument();				myFileList.ignoreWhite = true;				myFileList.parseXML(myLoader.data);				//myMovie.text = myFileList.childNodes[0].attributes.path;				//myMovie.textColor = Preferences.pref.th.color;				/*trace(myFileList.childNodes[0]);				for (var a=0;a<myFileList.childNodes[0].childNodes.length;a++){					trace("tit "+myFileList.childNodes[0].childNodes[a].childNodes[1].childNodes[0])				}*/				var a = 0;				if (firstTime) {					firstTime = false;					var t = 0;					var now = getDaySeconds()*1000;					//var now = 1600000;					while (t<now) {						t+=parseFloat(myFileList.childNodes[0].childNodes[a].childNodes[1].childNodes[2].childNodes[0].toString());						a++;					}					a--;					t-=parseFloat(myFileList.childNodes[0].childNodes[a].childNodes[1].childNodes[2].childNodes[0].toString());					goToSec = int((now-t)/1000);					if (goToSec > 40) {						Preferences.pref.interfaceTrgt.startAlert();					}					trace("goToSec "+a+" "+goToSec)					if (goToSec) {						//trace("Buffer "+Preferences.pref.monitorTrgt.levels["ch_"+0].NS.bufferTime)						Preferences.pref.monitorTrgt.levels["ch_"+0].NS.bufferTime+= goToSec;						//trace("Buffer "+Preferences.pref.monitorTrgt.levels["ch_"+0].NS.bufferTime)					}				}				Preferences.pref.currentMedia = a;				myLoad(a);				updatePage()			} else {				if (l == 0) {					loaderLib(Preferences.pref.libraryList.childNodes[0].attributes.path+currLib);				} else if (l == 1) {					loaderLib(Preferences.pref.libraryList.childNodes[0].attributes.path+currLib+".flx");				} else if (l == 2) {					loaderLib("library/"+currLib+".flx");				} else {					loadErr();				}				l++;			}		}		public function updatePage() {			page = int(Preferences.pref.currentMedia/listN);			trace("page"+page)			trace("page"+int(page))			setPage()		}		public function setPage() {			pages.text = page+ " of "+int(myFileList.childNodes[0].childNodes.length/listN)+" PAGES"			for (var b=0;b<listN;b++){				if (b+(listN*page)<myFileList.childNodes[0].childNodes.length){					listSprites[b].riempi(myFileList.childNodes[0].childNodes[b+(listN*page)],b+(listN*page));				} else {					listSprites[b].svuota();				}			}		}		function getDaySeconds():Number {			now = new Date();			var today = new Date(now.getFullYear(),now.getMonth(),now.getDate());			return int((now.getTime()-today.getTime())/1000);		}		function myLoad(a):void {			//Preferences.pref.monitorTrgt.mbuto((getTimer()-Preferences.pref.lastTime)+",loadMedia,1,"+"http://www.vjtelevision.com/_swf/sottopancia.swf"+",swf,100");			//trace(Preferences.pref.monitorTrgt.levels["ch_"+1].swfLoader.content.riempi)			//if (Preferences.pref.monitorTrgt.levels["ch_"+1].swfLoader.content.riempi is Function)			/*var str = "";			for (var b=0;b<myFileList.childNodes[0].childNodes[a].childNodes[1].childNodes.length;b++){				var node = myFileList.childNodes[0].childNodes[a].childNodes[1].childNodes[b].nodeName;				if (node=="author" || node=="categories") {					str+=node+"="+escape(myFileList.childNodes[0].childNodes[a].childNodes[1].childNodes[b].childNodes[0].childNodes[0])+"&";					str+=node+"href="+escape(myFileList.childNodes[0].childNodes[a].childNodes[1].childNodes[b].childNodes[0].attributes.href)+"&";				} else {					str+=node+"="+escape(myFileList.childNodes[0].childNodes[a].childNodes[1].childNodes[b].childNodes[0])+"&";				}			}			Preferences.pref.interfaceTrgt.mbuto((getTimer()-Preferences.pref.lastTime)+",loadMedia,1,"+"http://www.vjtelevision.com/_swf/"+"sottopanciaIphone.swf?"+str+",swf,100");			*/			Preferences.pref.interfaceTrgt.mySottopancia.riempi(myFileList.childNodes[0].childNodes[a],a);			//Preferences.pref.interfaceTrgt.showSottopancia();			Preferences.pref.interfaceTrgt.firstPlay = true;			Preferences.pref.currentMedia = a;			//trace("myLoad " + a)			//trace("myLoad" + myFileList.childNodes[0].childNodes[a].childNodes[0].childNodes[0])			myLoadMovieMore(myFileList.childNodes[0].childNodes[a].childNodes[0].childNodes[0],myFileList.childNodes[0].childNodes[a].childNodes[0].childNodes[0]);			updatePage()		}		function myLoadMovie(a:String,p:String):void {			Preferences.pref.nLoadErr["ch_"+ch] = 0;			myLoadMovieMore(a,p);		}		public function myLoadMovieMore(a:String,p:String):void {			Preferences.pref.monitorTrgt.myStarted = Preferences.pref.monitorTrgt.myloaded = false;			if (p.indexOf("/") == -1) {				p = myPath+p;			}			current_mov = p;			tipo = p.substring(p.length-3, p.length).toLowerCase();			trace(tipo);			if (tipo == "txt") {				this.tipo = "swf";				this.myTxtEditor.myTxtLoader.load(new URLRequest(this.current_mov));			} else {				if (tipo == "flv" || tipo == "avi" || tipo == "mov" || tipo == "mpg" || tipo == "mp4" || tipo == "m4v") {					tipo = "flv";					lastLiveAct = ",loadFlv,"+ch+","+current_mov+","+tipo+","+100;				} else if (tipo == "mp3") {					lastLiveAct = ",loadMp3,"+ch+","+current_mov+","+tipo+","+100;				} else {					tipo = "swf";					lastLiveAct = ",loadMedia,"+ch+","+current_mov+","+tipo+","+100;				}				trace("VJTVch")				Preferences.pref.monitorTrgt.mbuto((getTimer()-Preferences.pref.lastTime)+lastLiveAct);			}			oldTipo = tipo;			Preferences.pref.interfaceTrgt.startLoading();		}		function load_url(a:String):void {			var tmp:String = Preferences.myReplace(current_mov,myPath,"");			myLoadMovie(tmp,tmp);		}		public function loadErr():void {			trace("FILE NOT FOUND")			/*myMovie.text = "FILE NOT FOUND";			myMovie.textColor = 0xFF0000;			myMovie.setSelection(0, 0);*/		}		public function setPos(hh):void {			x = int((Preferences.pref.w-370)/2)+45;			h = int(int((hh-50)/105)*105)-12+50;			pages.y = succ.y = prev.y = h-17;			myY = int((hh-h)/2)-10;			if (Preferences.pref.interfaceTrgt.menuIsClose) {				y = Preferences.pref.h;			} else {				y = myY;			}			trace("myY "+y)			listN = int((hh-50)/105);			fondino.height = h;			var a			var oldListSprites = listSprites.length;			if (listN>oldListSprites) {				for (a=oldListSprites;a<listN;a++){					listSprites.push(new VJTVListItem((a*105)+25, myLoad, Preferences.pref.interfaceTrgt.showInfo));					list.addChild(listSprites[a]);				}			} else if (listN<oldListSprites) {				for (a=oldListSprites-1;a>=listN;a--){					list.removeChild(listSprites[a]);					listSprites.pop();				}			}			cal.x = int((370-242)/2);			cal.y = int((fondino.height-177)/2);			if (myFileList is XMLDocument) setPage()		}	}}