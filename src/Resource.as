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

		[Embed(source = "../resc/ui/aimretic.png")] public static var AIMRETIC:Class;
		
		[Embed(source = "../resc/mapobj/pub.png")] public static var PUB:Class;
		[Embed(source = "../resc/mapobj/inn.png")] public static var INN:Class;
		
		[Embed(source = "../resc/effects/explosion.png")] public static var EXPLOSION:Class;
		[Embed(source = "../resc/effects/heroghost.png")] public static var HEROGHOST:Class;
		[Embed(source = "../resc/effects/star.png")] public static var SPARKLE:Class;
		
		[Embed(source = "../resc/mapobj/gold.png")] public static var GOLD:Class;
		
		
		
		[Embed( source = "../resc/levels/level1.json", mimeType="application/octet-stream")] private static var LEVEL1_DATA:Class;
		public static var LEVEL1_DATA_OBJECT:Object = JSON.decode((new LEVEL1_DATA as ByteArray).toString());
	}

}