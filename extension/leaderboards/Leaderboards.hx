package extension.leaderboards;

#if googleplayleaderboards
import extension.leaderboards.Leaderboards;
#end

#if gamecircleleaderboards
import extension.leaderboards.GameCircleLeaderboards;
#end

#if gamecenterleaderboards
import extension.leaderboards.GameCenterLeaderboards;
#end

#if kongregateleaderboards
import extension.leaderboards.KongregateFacade;
#end

#if gamejoltleaderboards
import flixel.util.FlxTimer; // For pinging the GameJolt session
import extension.leaderboards.GameJoltFacade;
#end

#if newgroundsleaderboards
import extension.leaderboards.NewgroundsFacade;
#end

#if steamworksleaderboards
import extension.leaderboards.SteamworksFacade;
import extension.leaderboards.SteamworksFacade.DialogName;
#end

class Leaderboards {
	public static var get(default, never):Leaderboards = new Leaderboards();
	
	private function new() {
	}
	
	public static function init():Void {
		#if gamecenterleaderboards
		GameCenterLeaderboards.get;
		#end
		
		#if googleplayleaderboards
		GooglePlayLeaderboards.get;
		#end
		
		#if gamecircleleaderboards
		GameCircleLeaderboards.get;
		#end
		
		#if kongregateleaderboards
		KongregateFacade.init(onKongregateLoaded);
		#end
		
		#if gamejoltleaderboards
		if (gameJoltGameId == 0 || gameJoltPrivateKey == null) {
			throw "Set (at minimum) the GameJolt gameId and privateKey before initializing leaderboards";
		}
		GameJoltFacade.init(gameJoltGameId, gameJoltPrivateKey, gameJoltAutoAuth, gameJoltUserName, gameJoltUserToken, onGameJoltLoaded);
		#end
		
		#if newgroundsleaderboards
		if (newgroundsGameId == null) {
			throw "Set (at minimum) the Newgrounds gameId and privateKey before initializing leaderboards";
		}
		NewgroundsFacade.init(newgroundsGameId, newgroundsPrivateKey, newgroundsShowPopUp, onNewgroundsConnected);
		#end
		
		#if steamworksleaderboards
		if (steamGameId == 0) {
			throw "Set the Steamworks gameId before initializing leaderboards";
		}
		SteamworksFacade.init(steamGameId);
		#end
	}
	
	public static function openLeaderboard(id:Dynamic):Void {
		#if gamecenterleaderboards
		GameCenterLeaderboards.get.openLeaderboard(id);
		#end
		
		#if googleplayleaderboards
		GooglePlayLeaderboards.get.openLeaderboard(id);
		#end
		
		#if gamecircleleaderboards
		GameCircleLeaderboards.get.openLeaderboard(id);
		#end
		
		#if kongregateleaderboards
		#end
		
		#if gamejoltleaderboards
		#end
		
		#if newgroundsleaderboards
		#end
		
		#if steamworksleaderboards
		SteamworksFacade.openOverlayToDialog(DialogName.ACHIEVEMENTS); // TODO how to open leaderboards tab?
		#end
	}
	
	public static function openAchievements():Void {
		#if gamecenterleaderboards
		GameCenterLeaderboards.get.openAchievements();
		#end
		
		#if googleplayleaderboards
		GooglePlayLeaderboards.get.openAchievements();
		#end
		
		#if gamecircleleaderboards
		GameCircleLeaderboards.get.openAchievements();
		#end
		
		#if kongregateleaderboards
		#end
		
		#if gamejoltleaderboards
		#end
		
		#if newgroundsleaderboards
		#end
		
		#if steamworksleaderboards
		SteamworksFacade.openOverlayToDialog(DialogName.ACHIEVEMENTS);
		#end
	}
	
	public static function signIn():Void {
		#if gamecenterleaderboards
		GameCenterLeaderboards.get.signIn();
		#end
		
		#if googleplayleaderboards
		GooglePlayLeaderboards.get.signIn();
		#end
		
		#if gamecircleleaderboards
		GameCircleLeaderboards.get.signIn();
		#end
		
		#if kongregateleaderboards
		#end
		
		#if gamejoltleaderboards
		#end
		
		#if newgroundsleaderboards
		#end
		
		#if steamworksleaderboards
		#end
	}
	
	public static function isSignedIn():Bool {
		#if gamecenterleaderboards
		return GameCenterLeaderboards.get.isSignedIn();
		#end
		
		#if googleplayleaderboards
		return GooglePlayLeaderboards.get.isSignedIn();
		#end
		
		#if gamecircleleaderboards
		return GameCircleLeaderboards.get.isSignedIn();
		#end
		
		#if kongregateleaderboards
		#end
		
		#if gamejoltleaderboards
		#end
		
		#if newgroundsleaderboards
		#end
		
		#if steamworksleaderboards
		#end
		
		trace("Defaulting to signed in == true for unimplemented leaderboards signed in check");
		return true;
	}
	
	public static function submitScore(score:Int, ?leaderboardId:Dynamic):Void {
		#if gamecenterleaderboards
		GameCenterLeaderboards.get.submitScore(leaderboardId, score);
		#end
		
		#if googleplayleaderboards
		GooglePlayLeaderboards.get.submitScore(leaderboardId, score);
		#end
		
		#if gamecircleleaderboards
		GameCircleLeaderboards.get.submitScore(leaderboardId, score);
		#end
		
		#if kongregateleaderboards
		KongregateFacade.submitScore(score, "normal");
		#end
		
		#if gamejoltleaderboards
		GameJoltFacade.addScore(Std.string(score), score, leaderboardId);
		#end
		
		#if newgroundsleaderboards
		NewgroundsFacade.submitScore(leaderboardId, score);
		#end
		
		#if steamworksleaderboards
		SteamworksFacade.submitScore(leaderboardId, score, 0, 0); // TODO detail/rank parameters?
		#end
	}
	
	#if kongregateleaderboards
	private static function onKongregateLoaded():Void {
		KongregateFacade.connect();
	}
	#end
	
	#if gamejoltleaderboards
	public static var gameJoltGameId:Int = 0;
	public static var gameJoltPrivateKey:String = null;
	public static var gameJoltAutoAuth:Bool = false;
	public static var gameJoltUserName:String = null;
	public static var gameJoltUserToken:String = null;
	
	private static function onGameJoltLoaded(success:Bool):Void {
		GameJoltFacade.authUser(gameJoltUserName, gameJoltUserToken, onGameJoltAuthorized);
	}
	
	private static function onGameJoltAuthorized(success:Bool):Void {
		if (success) {
			#if debug
			trace("Authorized GameJolt session");
			#end
			GameJoltFacade.openSession(onGameJoltSessionOpened);
		} else {
			#if debug
			trace("Failed to authorize GameJolt session");
			#end
		}
	}
	
	private static function onGameJoltSessionOpened(kvs:Dynamic):Void {
		new FlxTimer().start(30, function(t:FlxTimer):Void {
			GameJoltFacade.pingSession(true, onGameJoltPingedSession);
		}, 0);
	}
	
	private static function onGameJoltPingedSession(kvs:Dynamic):Void {
		#if debug
		trace("Pinged GameJolt session");
		#end
	}
	#end
	
	#if newgroundsleaderboards
	public static var newgroundsPrivateKey:String = null;
	public static var newgroundsGameId:String = null;
	public static var newgroundsShowPopUp:Bool = false;
	public static dynamic function onNewgroundsConnected(result:Bool):Void {};
	#end
	
	#if steamworksleaderboards
	public static var steamGameId:Int = 0;
	#end
}