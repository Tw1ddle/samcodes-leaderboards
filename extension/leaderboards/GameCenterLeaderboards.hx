package extension.leaderboards;

#if gamecenterleaderboards

import extension.gamecenter.GameCenter;
import extension.gamecenter.GameCenterEvent;

class GameCenterLeaderboards {
	public static var get(default, never):GameCenterLeaderboards = new GameCenterLeaderboards();
	
	private function new() {
		// No explicit initialize necessary
	}
	
	public function openLeaderboard(id:String):Void {
		if (!isSignedIn()) {
			return;
		}
		
		GameCenter.showLeaderboard(id);
	}
	
	public function openAchievements():Void {
		if (!isSignedIn()) {
			return;
		}
		
		GameCenter.showAchievements();
	}
	
	public function isSignedIn():Bool {
		return GameCenter.available; // Really means whether the service is available at all, not simply whether you are signed in or not
	}
	
	public function signIn():Void {
		if (isSignedIn()) {
			return;
		}
		
		GameCenter.authenticate();
	}
	
	public function submitScore(id:String, score:Int):Void {
		if (!isSignedIn()) {
			return;
		}
		
		GameCenter.reportScore(id, score);
	}

	public function updateAchievementProgress(id:String, percent:Float, showBanner:Bool = true):Void {
		if (!isSignedIn()) {
			return;
		}
		
		GameCenter.reportAchievement(id, percent, showBanner);
	}
}

#end