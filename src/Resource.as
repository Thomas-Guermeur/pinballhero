package  
{
	import flash.utils.ByteArray;
	
	import com.adobe.serialization.json.*;
	
	/**
	 * ...
	 * @author spotco
	 */
	public class Resource {
		
		[Embed(source = "../resc/background/groundtile_1.png")] public static var GROUNDTILE_1:Class;
		[Embed(source = "../resc/background/checkertile.png")] public static var CHERCKERTILE:Class;
		[Embed(source = "../resc/background/beach_entry.png")] public static var BEACH_ENTRY:Class;
		
		[Embed(source = "../resc/character/fox_small.png")] public static var ENEMY:Class;
		[Embed(source = "../resc/character/bear_idle.png")] public static var BEAR:Class;
		[Embed(source = "../resc/character/Hero1.png")] public static var PLAYER:Class;
		[Embed(source = "../resc/character/princess.png")] public static var PRINCESS:Class;
		[Embed(source = "../resc/character/dog.png")] public static var DOG:Class;
		
		[Embed(source = "../resc/character/airship.png")] public static var AIRSHIP:Class;
		[Embed(source = "../resc/character/airship_shadow.png")] public static var AIRSHIP_SHADOW:Class;
		
		[Embed(source = "../resc/mapobj/town.png")] public static var TOWN:Class;
		[Embed(source = "../resc/mapobj/castle.png")] public static var CASTLE:Class;
		[Embed(source = "../resc/mapobj/princess_help.png")] public static var PRINCESS_HELP:Class;
		
		[Embed(source = "../resc/mapobj/gate.png")] public static var GATE:Class;
		[Embed(source = "../resc/mapobj/key.png")] public static var KEY:Class;

		[Embed(source = "../resc/ui/aimretic.png")] public static var AIMRETIC:Class;
		[Embed(source = "../resc/ui/aimretic_empty.png")] public static var AIMRETIC_EMPTY:Class;
		[Embed(source = "../resc/ui/hud_tilttext.png")] public static var HUD_TILTTEXT:Class;
		[Embed(source = "../resc/ui/hud_tiltcontrols.png")] public static var HUD_TILTCONTROLS:Class;
		[Embed(source = "../resc/ui/hud_tiltbar.png")] public static var HUD_TILTBAR:Class;
		[Embed(source = "../resc/ui/hud_tiltbar_empty.png")] public static var HUD_TILTBAR_EMPTY:Class;
		[Embed(source = "../resc/ui/nexthero_popup.png")] public static var NEXTHERO_POPUP:Class;
		[Embed(source = "../resc/ui/chat_cover.png")] public static var CHAT_COVER:Class;
		[Embed(source = "../resc/ui/castle_finish_cover.png")] public static var CASTLE_FINISH_COVER:Class;
		
		[Embed(source = "../resc/mapobj/Guild.png")] public static var PUB:Class;
		[Embed(source = "../resc/mapobj/inn.png")] public static var INN:Class;
		[Embed(source = "../resc/mapobj/town.png")] public static var SIGN:Class;
		[Embed(source = "../resc/mapobj/treebumper.png")] public static var TREEBUMPER:Class;
		[Embed(source = "../resc/mapobj/treebumper2.png")] public static var TREEBUMPER2:Class;
		[Embed(source = "../resc/mapobj/treebumper3.png")] public static var TREEBUMPER3:Class;
		/*[Embed(source = "../resc/mapobj/town.png")] public static var TREE:Class;
		[Embed(source = "../resc/mapobj/town.png")] public static var DEATH:Class*/

		[Embed(source = "../resc/effects/question.png")] public static var QUESTION:Class;
		[Embed(source = "../resc/effects/explosion.png")] public static var EXPLOSION:Class;
		[Embed(source = "../resc/effects/heroghost.png")] public static var HEROGHOST:Class;
		[Embed(source = "../resc/effects/star.png")] public static var SPARKLE:Class;
		[Embed(source = "../resc/effects/hp_spark.png")] public static var HP_SPARK:Class;
		
		[Embed(source = "../resc/background/mountain_small.png")] public static var MOUNTAIN_SMALL:Class;
		[Embed(source = "../resc/background/mountain.png")] public static var MOUNTAIN_MED:Class;
		[Embed(source = "../resc/background/mountain_large.png")] public static var MOUNTAIN_BIG:Class;
		
		[Embed(source = "../resc/mapobj/gold.png")] public static var GOLD:Class;
		
		/*[Embed( source = "../resc/sound/punch.mp3" )] public static var SFX_PUNCH:Class;
		[Embed( source = "../resc/sound/pop.mp3" )] public static var SFX_POP:Class;
		[Embed( source = "../resc/sound/slap.mp3" )] public static var SFX_SLAP:Class;*/
		
		
		[Embed( source = "../resc/levels/level1.json", mimeType="application/octet-stream")] private static var LEVEL1_DATA:Class;
		public static var LEVEL1_DATA_OBJECT:Object = JSON.decode((new LEVEL1_DATA as ByteArray).toString());
		
		[Embed( source = "../resc/levels/level2.json", mimeType="application/octet-stream")] private static var LEVEL2_DATA:Class;
		public static var LEVEL2_DATA_OBJECT:Object = JSON.decode((new LEVEL2_DATA as ByteArray).toString());
		
		[Embed( source = "../resc/levels/level2.json", mimeType="application/octet-stream")] private static var LEVEL3_DATA:Class;
		public static var LEVEL3_DATA_OBJECT:Object = JSON.decode((new LEVEL3_DATA as ByteArray).toString());
	}

}