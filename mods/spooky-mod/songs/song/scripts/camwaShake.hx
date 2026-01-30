var shakeStrum = 0;

public var camShakeStrength = 2;
var shakeLength = 0.1;
var shakeAmount = 10;

var cameras = [camGame, camHUD];

public var smolCamShake = false;

var camShakeTimer;
var camResetTimer;
var smolCamShakeTimer;
function onNoteHit(event) if (event.note.strumLine.ID == shakeStrum)
{
	if (camShakeTimer != null) camResetTimer.cancel();
	if (smolCamShakeTimer != null) smolCamShakeTimer.cancel();
	camShakeTimer = new FlxTimer().start(shakeLength/shakeAmount, function(tmr:FlxTimer)
	{
		for (cam in cameras) cam.setPosition(FlxG.random.int(-camShakeStrength, camShakeStrength), FlxG.random.int(-camShakeStrength, camShakeStrength));
	}, shakeAmount);
	if (camResetTimer != null) camResetTimer.cancel();
	camResetTimer = new FlxTimer().start(shakeLength, function(tmr:FlxTimer)
	{
		for (cam in cameras) cam.setPosition();
		if (smolCamShake) smolCamShakeTimer = new FlxTimer().start(shakeLength/shakeAmount, function(tmr:FlxTimer)
		{
			for (cam in cameras) cam.setPosition(FlxG.random.int(camShakeStrength/-2, camShakeStrength/2), FlxG.random.int(camShakeStrength/-2, camShakeStrength/2));
		}, 0);
	});
}

function create() cameras.push(camNotes);