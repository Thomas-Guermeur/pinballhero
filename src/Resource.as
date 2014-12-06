package  
{
	import flash.utils.ByteArray;
	
	import com.adobe.serialization.json.*;
	
	/**
	 * ...
	 * @author spotco
	 */
	public class Resource {
		
		[Embed(source = "../resc/background/testbackground.png")] public static var TEST_BACKGROUND:Class;
		[Embed(source = "../resc/character/enemy.png")] public static var ENEMY:Class;
		[Embed(source = "../resc/character/player.png")] public static var PLAYER:Class;
		[Embed(source = "../resc/mapobj/town.png")] public static var TOWN:Class;
		[Embed(source = "../resc/effects/explosion.png")] public static var EXPLOSION:Class;
		[Embed(source = "../resc/ui/aimretic.png")] public static var AIMRETIC:Class;
		
		[Embed( source = "../resc/levels/level1.json", mimeType="application/octet-stream")] private static var LEVEL1_DATA:Class;
		public static var LEVEL1_DATA_OBJECT:Object = JSON.decode((new LEVEL1_DATA as ByteArray).toString());
	}

}