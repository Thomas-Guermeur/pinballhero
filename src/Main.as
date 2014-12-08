package 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import gameobjs.*;
	import org.flixel.*;
	import flash.ui.*;
	import flash.events.*;
	
	[SWF(frameRate = "60", width = "1000", height = "500", backgroundColor="#000000")]
	
	/**
	 * ...
	 * @author spotco
	 */
	public class Main extends FlxGame 
	{
		
		public function Main():void 
		{	
			super(1000, 500, GameEngineState);
		}
		
	}
	
}