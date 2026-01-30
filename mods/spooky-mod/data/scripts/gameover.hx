import funkin.backend.MusicBeatState;

var character;
var camFollow;
var sound;
var confirmSound;

var defaultCamZoom = 0.5;

var zoomTween;

public function snapCamera(sprite)
{
	camera.scroll.x = sprite.x - camera.deadzone.x;
	camera.scroll.y = sprite.y - camera.deadzone.y;
}

function create(event)
{
	confirmSound = event.retrySFX;
	event.cancelled = true;

	sound = FlxG.sound.play(Paths.sound("death"));

	add(character = new Character(event.x, event.y, event.character, event.player));
	character.playAnim('firstDeath');

	var camPos = character.getCameraPosition();
	add(camFollow = new FlxSprite(camPos.x, camPos.y));
	camFollow.visible = false;
	snapCamera(camFollow);
	FlxG.camera.target = camFollow;

	camera.zoom = 0.75;
}

function update()
{
	if (character.getAnimName() == "firstDeath" && character.isAnimFinished()) start();
	if (FlxG.mouse.justPressed) end();
	camera.zoom = lerp(camera.zoom, defaultCamZoom, 0.05);
}

function start()
{
	character.playAnim("deathLoop");
	zoomTween = FlxTween.num(defaultCamZoom, 0.8, 25, {ease: FlxEase.sineInOut}, (val:Float) -> {
		defaultCamZoom = val;
	});
}

var ended = false;
function end() if (!ended)
{
	ended = true;

	new FlxTimer().start(2, function(tmr:FlxTimer)
	{
		MusicBeatState.skipTransOut = true;
		FlxG.switchState(new PlayState());
	});

	sound.stop();

	sound = FlxG.sound.play(Paths.sound(confirmSound));
	sound.pitch = 1.5;
	sound.volume = 0.5;

	character.playAnim('deathConfirm', true);

	if (zoomTween != null) zoomTween.cancel();
	defaultCamZoom = defaultCamZoom * 1.2;
}