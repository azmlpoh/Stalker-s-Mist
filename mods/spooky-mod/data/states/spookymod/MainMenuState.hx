import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.options.OptionsMenu;
import funkin.menus.credits.CreditsMain;
import funkin.backend.MusicBeatState;

importScript("data/scripts/touchingMouse");
importScript("data/scripts/menuBG");

var song = "song";
var diff = "normal";

var imageFolder = "menus/";

var freeplayItems:Array<String> = CoolUtil.coolTextFile(Paths.txt("config/menuItems"));

add(textGroup = new FlxSpriteGroup(0, FlxG.height - 250));

var textSpacing = 75;
var textSize = 50;
var textWidth = 400;
for (i=>item in freeplayItems)
{
	textGroup.add(text = new FunkinText(0, textSpacing*i, textWidth, item, textSize));
	text.font = Paths.font("Endless Scarry.ttf");
	text.alignment = "center";
	text.alpha = 0.5;
}

var opponentMode = false;

add(opponentTxt = new FunkinText(0, 0, FlxG.width, "Opponent Mode (" + opponentMode + ")
(F to switch)", 25));
opponentTxt.alignment = "right";

add(fade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));
fade.alpha = 0;

function toggleOpponent()
{
	opponentMode = !opponentMode;
	opponentTxt.text = "Opponent Mode (" + opponentMode + ")
(F to switch)";
}

function create()
{
	CoolUtil.playMenuSong();
}

function updateCurSelectedItem()
{
	var item = freeplayItems[curSelected];
	var text;
	
	if (oldSelected != null)
	{
		var item = freeplayItems[oldSelected];
		var text = textGroup.members[oldSelected];

		text.alpha = 0.5;
	}

	text = textGroup.members[curSelected];
	text.alpha = 1;
}

var curSelected = 0;
var oldSelected;
function changeSelected(amount:Int = 0)
{
	if (amount != 0) oldSelected = curSelected;
	curSelected += amount;
	if (curSelected > freeplayItems.length-1) curSelected = 0;
	if (curSelected < 0) curSelected = freeplayItems.length-1;
	updateCurSelectedItem();
	CoolUtil.playMenuSFX(0);
}

updateCurSelectedItem();

function selectItem(item) switch(item)
{
	case "play" :
	{
		PlayState.loadSong(song, diff, opponentMode, false);
		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			MusicBeatState.skipTransOut = true;
			FlxG.switchState(new PlayState());
		});
		FlxTween.tween(camera, {zoom:1.5}, 2, {ease: FlxEase.quartOut});
		FlxTween.tween(camera.scroll, {x:200, y:100}, 2, {ease: FlxEase.quartOut});
		FlxTween.tween(fade, {alpha:1}, 1.5, {ease: FlxEase.sineIn});
		FlxTween.tween(FlxG.sound.music, {pitch:0}, 2, {ease: FlxEase.sineOut});
		interactable = false;
	}
	case "options" :
	{
		FlxG.switchState(new OptionsMenu());
	}
	case "credits" :
	{
		FlxG.switchState(new CreditsMain());
	}
}

var interactable = true;
function update(elapsed) if (interactable)
{
	if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = false;
		persistentDraw = true;
	}

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		persistentDraw = true;
		openSubState(new EditorPicker());
	}

	if (FlxG.keys.justPressed.F) toggleOpponent();

	if (controls.UP_P || FlxG.mouse.wheel) changeSelected(-1);
	if (controls.DOWN_P || -FlxG.mouse.wheel) changeSelected(1);

	if (controls.ACCEPT) selectItem(freeplayItems[curSelected]);
}

function postUpdate() if (interactable)
{
	var mousePressed = FlxG.mouse.justReleased;
	
	if (mousePressed && touchingMouse(opponentTxt, false)) {
		toggleOpponent();
		return;
	}
	
	for (i in 0...textGroup.members.length)
	{
		var text = textGroup.members[i];
		if (touchingMouse(text, false))
		{
			if (text != textGroup.members[curSelected])
			{
				oldSelected = curSelected;
				curSelected = i;
				updateCurSelectedItem();
				CoolUtil.playMenuSFX(0);
			}
			
			if (mousePressed)
			{
				selectItem(freeplayItems[curSelected]);
			}
			return;
		}
	}
}