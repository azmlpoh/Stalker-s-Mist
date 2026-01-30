import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.MusicBeatState;

MusicBeatState.skipTransIn = true;

rngNum = FlxG.random.int(1, 100);
trace("fish:" + rngNum);

function create()
{
	add(fish = new FlxVideoSprite(0, 0));
	fish.load(Assets.getPath(Paths.video("fish")));
	fish.bitmap.onFormatSetup.add(function() {
		fish.setGraphicSize(FlxG.width, FlxG.height);
		fish.screenCenter();
	});
	fish.bitmap.onEndReached.add(function() {
		MusicBeatState.skipTransOut = true;
		FlxG.switchState(new ModState("spookymod/MainMenuState"));
	});
	fish.play();

	add(scarry = new FunkinText(0, 100, FlxG.width, "FISH FROM SAND DE AGEO JUMPSCARE ! !1!", 50));
	scarry.alignment = "center";
}

function update(elapsed)
{
	fish.screenCenter();
	fish.x += FlxG.random.int(-2, 2);
	fish.y += FlxG.random.int(-2, 2);

	scarry.setPosition(0, 100);
	scarry.x += FlxG.random.int(-2, 2);
	scarry.y += FlxG.random.int(-2, 2);
}