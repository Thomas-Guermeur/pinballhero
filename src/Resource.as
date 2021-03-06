package  
{
	import flash.utils.ByteArray;
	import flash.media.Sound;
	import com.adobe.serialization.json.*;
	
	/**
	 * ...
	 * @author spotco
	 */
	public class Resource {
		
		[Embed(source = "../resc/background/groundtile_1.png")] public static var GROUNDTILE_1:Class;
		[Embed(source = "../resc/background/checkertile.png")] public static var CHERCKERTILE:Class;
		[Embed(source = "../resc/background/beach_entry.png")] public static var BEACH_ENTRY:Class;
		
		[Embed(source = "../resc/character/slime1.png")] public static var SLIME1:Class;
		[Embed(source = "../resc/character/slime2.png")] public static var SLIME2:Class;
		[Embed(source = "../resc/character/fox_small.png")] public static var FOX:Class;
		[Embed(source = "../resc/character/bear.png")] public static var BEAR:Class;
		[Embed(source = "../resc/character/dragon.png")] public static var DRAGON:Class;
		
		
		[Embed(source = "../resc/character/Hero1.png")] public static var PLAYER:Class;
		[Embed(source = "../resc/character/archer.png")] public static var PLAYER_ARCHER:Class;
		[Embed(source = "../resc/character/knight.png")] public static var PLAYER_KNIGHT:Class;
		[Embed(source = "../resc/character/wizard.png")] public static var PLAYER_WIZARD:Class;
		[Embed(source = "../resc/character/princess.png")] public static var PRINCESS:Class;
		[Embed(source = "../resc/character/old_man.png")] public static var OLD_MAN:Class;
		[Embed(source = "../resc/character/bones.png")] public static var BONES:Class;
		[Embed(source = "../resc/character/dog.png")] public static var DOG:Class;
		
		[Embed(source = "../resc/character/airship.png")] public static var AIRSHIP:Class;
		[Embed(source = "../resc/character/airship_shadow.png")] public static var AIRSHIP_SHADOW:Class;
		
		[Embed(source = "../resc/mapobj/town.png")] public static var TOWN:Class;
		[Embed(source = "../resc/mapobj/castle.png")] public static var CASTLE:Class;
		[Embed(source = "../resc/mapobj/princess_help.png")] public static var PRINCESS_HELP:Class;
		
		[Embed(source = "../resc/mapobj/gate.png")] public static var GATE:Class;
		[Embed(source = "../resc/mapobj/key.png")] public static var KEY:Class;
		[Embed(source = "../resc/mapobj/tutorial_launch.png")] public static var TUTORIAL_LAUNCH:Class;
		[Embed(source = "../resc/mapobj/tutorial_tilt.png")] public static var TUTORIAL_TILT:Class;

		[Embed(source = "../resc/ui/aimretic.png")] public static var AIMRETIC:Class;
		[Embed(source = "../resc/ui/aimretic_empty.png")] public static var AIMRETIC_EMPTY:Class;
		[Embed(source = "../resc/ui/hud_tilttext.png")] public static var HUD_TILTTEXT:Class;
		[Embed(source = "../resc/ui/hud_tiltbar.png")] public static var HUD_TILTBAR:Class;
		[Embed(source = "../resc/ui/hud_tiltbar_empty.png")] public static var HUD_TILTBAR_EMPTY:Class;
		[Embed(source = "../resc/ui/hud_tiltbar_full.png")] public static var HUD_TILTBAR_FULL:Class;
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
		[Embed(source = "../resc/character/ghost.png")] public static var HEROGHOST:Class;
		[Embed(source = "../resc/effects/star.png")] public static var SPARKLE:Class;
		[Embed(source = "../resc/effects/hp_spark.png")] public static var HP_SPARK:Class;
		
		[Embed(source = "../resc/background/mountain_small.png")] public static var MOUNTAIN_SMALL:Class;
		[Embed(source = "../resc/background/mountain.png")] public static var MOUNTAIN_MED:Class;
		[Embed(source = "../resc/background/mountain_large.png")] public static var MOUNTAIN_BIG:Class;
		
		[Embed(source = "../resc/mapobj/gold.png")] public static var GOLD:Class;
		
		[Embed(source = "../resc/ui/title_screen.png")] public static var TITLE_SCREEN:Class;
		[Embed(source = "../resc/ui/title_text.png")] public static var TITLE_TEXT:Class;
		[Embed(source = "../resc/ui/gameover_screen.png")] public static var GAMEOVER_SCREEN:Class;
		
		
		[Embed( source = "../resc/levels/level1.json", mimeType="application/octet-stream")] public static var LEVEL1_DATA:Class;
		[Embed( source = "../resc/levels/level2.json", mimeType="application/octet-stream")] public static var LEVEL2_DATA:Class;
		[Embed( source = "../resc/levels/level3.json", mimeType="application/octet-stream")] public static var LEVEL3_DATA:Class;
		[Embed( source = "../resc/levels/level4.json", mimeType="application/octet-stream")] public static var LEVEL4_DATA:Class;
		[Embed( source = "../resc/levels/test.json", mimeType="application/octet-stream")] public static var LEVELTEST_DATA:Class;
	
		[Embed( source = "../resc/sound/world_bgm.mp3" )] private static var IMPORT_BGM_WORLD:Class;
		public static var BGM_WORLD:Sound = new IMPORT_BGM_WORLD as Sound;
		[Embed( source = "../resc/sound/menu_bgm.mp3" )] private static var IMPORT_BGM_MENU:Class;
		public static var BGM_MENU:Sound = new IMPORT_BGM_MENU as Sound;
		
		[Embed( source = "../resc/sound/gameover.mp3" )] public static var SFX_GAMEOVER:Class; 
		[Embed( source = "../resc/sound/powerup.mp3" )] public static var SFX_POWERUP:Class; 
		[Embed( source = "../resc/sound/sfx_bone_1.mp3" )] public static var SFX_COLLECT_1:Class; 
		[Embed( source = "../resc/sound/sfx_explosion.mp3" )] public static var SFX_EXPLOSION:Class; 
		[Embed( source = "../resc/sound/sfx_hit.mp3" )] public static var SFX_HIT:Class;
		[Embed( source = "../resc/sound/sfx_rockbreak.mp3" )] public static var SFX_ROCKBREAK:Class; 
		[Embed( source = "../resc/sound/sfx_spin.mp3" )] public static var SFX_SPIN:Class; 
		[Embed( source = "../resc/sound/shoot_orca.mp3" )] public static var SFX_BULLET2:Class;
		[Embed( source = "../resc/sound/shoot1.mp3" )] public static var SFX_BULLET3:Class;
		[Embed( source = "../resc/sound/shoot2.mp3" )] public static var SFX_BULLET4:Class;
		[Embed( source = "../resc/sound/sfx_boss_enter.mp3" )] public static var SFX_BOSS_ENTER:Class;
		[Embed( source = "../resc/sound/sfx_jump.mp3" )] public static var SFX_JUMP:Class;
	}

}