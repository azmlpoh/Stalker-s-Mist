import funkin.game.GameOverSubstate;
import funkin.menus.PauseSubState;
import funkin.menus.BetaWarningState;
import funkin.menus.credits.CreditsMain;

import funkin.backend.utils.WindowUtils;
import openfl.Lib;
import lime.graphics.Image;

var windowTitle = "Spooky mod oooo";

if (false) window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('icon'))));

var redirectStates:Map<FlxState, String> = [
    TitleState => "spookymod/warning"
	BetaWarningState => "spookymod/warning"
    MainMenuState => "spookymod/MainMenuState"
    FreeplayState => "spookymod/MainMenuState"
	CreditsMain => "spookymod/CreditsState"
];

function preStateSwitch() {
    for (redirectState in redirectStates.keys()) if (Std.isOfType(FlxG.game._requestedState, redirectState))
	{
		FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
	}
}

function destroy()
{
    WindowUtils.resetTitle();
}