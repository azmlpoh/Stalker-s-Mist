import funkin.backend.MusicBeatState;

MusicBeatState.skipTransIn = true;

rngNum = FlxG.random.int(1, 100);
trace("fish:" + rngNum);

add(warning = new FunkinText(0, 0, FlxG.width, "!WARNING!
This mod contains flashing imagery and may not be suitable for Photosensitive epilepsy

(Tap to continue)", 50));
warning.alignment = "center";
warning.screenCenter(FlxAxes.Y);

function update(elapsed)
{
	if (FlxG.mouse.justPressed)
	{
		remove(warning);
		MusicBeatState.skipTransOut = true;
		var state = "MainMenuState";
		if (rngNum == 1) state = "rareEpicFishREAL";
		FlxG.switchState(new ModState("spookymod/"+state));
	}
}