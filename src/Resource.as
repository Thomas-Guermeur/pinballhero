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
		[Embed(source = "../resc/character/fox_small.png")] public static var ENEMY:Class;
		[Embed(source = "../resc/character/bear.png")] public static var BEAR:Class;
		[Embed(source = "../resc/character/Hero1.png")] public static var PLAYER:Class;
		[Embed(source = "../resc/mapobj/town.png")] public static var TOWN:Class;
		[Embed(source = "../resc/mapobj/castle.png")] public static var CASTLE:Class;

		[Embed(source = "../resc/ui/aimretic.png")] public static var AIMRETIC:Class;
		
		[Embed(source = "../resc/mapobj/pub.png")] public static var PUB:Class;
		[Embed(source = "../resc/mapobj/inn.png")] public static var INN:Class;
		[Embed(source = "../resc/mapobj/town.png")] public static var SIGN:Class;
		[Embed(source = "../resc/mapobj/town.png")] public static var TREE:Class;
		[Embed(source = "../resc/mapobj/town.png")] public static var DEATH:Class;
		
		[Embed(source = "../resc/effects/explosion.png")] public static var EXPLOSION:Class;
		[Embed(source = "../resc/effects/heroghost.png")] public static var HEROGHOST:Class;
		[Embed(source = "../resc/effects/star.png")] public static var SPARKLE:Class;
		
		[Embed(source = "../resc/mapobj/gold.png")] public static var GOLD:Class;
		
		
		
		[Embed( source = "../resc/levels/level1.json", mimeType="application/octet-stream")] private static var LEVEL1_DATA:Class;
		public static var LEVEL1_DATA_OBJECT:Object = JSON.decode((new LEVEL1_DATA as ByteArray).toString());
		
		[Embed( source = "../resc/levels/level2.json", mimeType="application/octet-stream")] private static var LEVEL2_DATA:Class;
		public static var LEVEL2_DATA_OBJECT:Object = JSON.decode((new LEVEL2_DATA as ByteArray).toString());
		
		[Embed( source = "../resc/levels/level2.json", mimeType="application/octet-stream")] private static var LEVEL3_DATA:Class;
		public static var LEVEL3_DATA_OBJECT:Object = JSON.decode((new LEVEL3_DATA as ByteArray).toString());
	}

}